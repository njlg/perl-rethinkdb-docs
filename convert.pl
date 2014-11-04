#!/bin/evn perl

use strict;
use warnings;
use feature ':5.16';

use File::Basename qw{fileparse};
use File::Path qw{ make_path };
use File::Find qw{finddepth};
use File::Slurp;
use Data::Dumper;
use Pod::Simple::XHTML;
use Pod::Markdown;

my @files;
finddepth(sub {
    return if($_ eq '.' || $_ eq '..');
    return if($_ !~ /.pm$/ );
    push @files, $File::Find::name;
}, '/Users/nathan/source/perl-rethinkdb/lib');

sub get_module_name {
  my $content = shift;
  my $syn = q{};

  if( $content =~ /# NAME\n\n([^\n]+)/ ) {
    my @bits = split ' - ', $1;
    $syn = $bits[1];
    $syn =~ s/^\s*//g;
    $syn =~ s/\s*$//g;
    $syn =~ s/\n/ /g;

    return ($bits[0], $syn) if wantarray;
  }

  return $syn;
}

sub remove_module_name {
  my $content = shift;

  $content =~ s/# NAME\n\n([^\n]+)//g;

  return $content;
}

sub remove_synopsis {
  my $content = shift;

  $content =~ s/# SYNOPSIS\n//g;

  return $content;
}

sub get_description {
  my $content = shift;
  my $desc = q{};

  if( $content =~ /# DESCRIPTION\n([^#`]+)\n#/ ) {
    $desc = $1;
    $desc =~ s/^\s*//g;
    $desc =~ s/\s*$//g;
    $desc =~ s/\n/ /g;

    $desc =~ s/\([^)]+\)//g;
    $desc =~ s/[\[\]]//g;
  }

  return $desc;
}

sub remove_description {
  my $content = shift;

  $content =~ s/# DESCRIPTION\n([^#`]+)\n#/#/g;

  return $content;
}

sub downgrade_headers {
  my $content = shift;

  $content =~ s/\n### /\n#### /g;
  $content =~ s/\n## /\n### /g;
  $content =~ s/\n# /\n## /g;

  return $content;
}

sub fixCodeBlocks {
  my $content = shift;

  my $start = 0;
  my @lines = split "\n", $content;
  my @better = ();
  foreach(@lines) {
    if( $_ =~ /^    (.+)$/ ) {
      my $code = $1;
      if( !$start ) {
        $start = 1;
        push @better, '```perl';
        push @better, $code;
      }
      else {
        push @better, $code;
      }
    }
    elsif( $start && $_ ) {
      $start = 0;
      push @better, '```';
      push @better, '';
      push @better, $_;
    }
    else {
      push @better, $_;
    }
  }

  return join "\n", @better;
}

sub clean_link {
  my $link = shift;

  $link = lc $link;
  $link =~ s!::!/!g;

  return $link;
}

sub fix_links {
  my $content = shift;

  $content =~ s!(\(/packages/[^)]+\))!clean_link($1)!ge;

  return $content;
}

sub fix_underscores {
  my $content = shift;

  $content =~ s!\\_!_!g;

  return $content;
}

sub convertToMarkdown {
  my $file = shift;
  my $content = read_file $file;

  if( 0 ) {
    $content =~ s/package[.\W\w]*=encoding utf8\n//g;
    $content =~ s/=cut\n//g;

    $content =~ s/=head1/#/g;
    $content =~ s/=head2/##/g;
    $content =~ s/=head3/###/g;

    $content =~ s/\n\n  /\n```perl\n/g;
    $content =~ s/;\n\n/;\n```\n\n/g;

    $content =~ s/L<([^>]+)\|([^>]+)>/[$1]($2)/g;
    $content =~ s/L<([^>]+)>/[$1]($1)/g;

    $content =~ s/C<<(.+)>>/`$1`/g;
    $content =~ s/C<([^>]+)>/`$1`/g;
    $content =~ s/` ([^`]) `/`$1`/g;

    $content =~ s/\(C\)/&copy;/g;
  }

  my $parser = Pod::Markdown->new(perldoc_url_prefix => '/packages/');
  $parser->output_string(\(my $output));
  $parser->parse_string_document("$content");

  # add cool copyright symbol
  $output =~ s/\(C\)/&copy;/g;

  # fix code blocks to use fences
  $output = fixCodeBlocks $output;

  # clean up format for web
  my ($module, $subtitle) = get_module_name $output;
  my $description = get_description $output;

  $output = remove_module_name $output;
  $output = remove_description $output;
  $output = remove_synopsis $output;
  $output = downgrade_headers $output;
  $output = fix_links $output;
  $output = fix_underscores $output;

  # my $start = qq{# $module <small>$subtitle</small>};
  my $start = qq{# $module};
  $start .= "\n\n";
  $start .= $description;
  $start .= "\n\n";
  $start .= $output;

  return ($start, $description, $subtitle);
}

sub buildNavigation {
  my $content = shift;
  my @lines = split '\n', $content;
  my @headers = grep /^#/, @lines;

  my @nav;
  my $open = 0;
  foreach(@headers) {
    if( $_ =~ /^# (.+)/ ) {
      if( $open ) {
        push @nav, q{</ul>};
        push @nav, q{</li>};
        $open = 0;
      }

      my $text = $1;
      my $href = lc $1;
      $href =~ s/ /-/g;

      push @nav, qq{<li><a href="#$href">$text</a></li>};
    }
    elsif( $_ =~ /^## (.+)/ ) {
      if( !$open ) {
        $nav[$#nav] =~ s!</li>$!!;
        $open = 1;
        push @nav, q{<ul class="nav">};
      }

      push @nav, qq{<li><a href="#$1">$1</a></li>};
    }
  }

  if( $open ) {
    push @nav, q{</ul>};
  }

  # say Dumper \@nav;
  return join "\n", @nav;
}

sub makeDirectory {
  my $fn = shift;
  if( ! -f $fn ) {
    my ($name, $dir) = fileparse $fn;
    if( ! -d $dir ) {
      make_path $dir or die "Failed to create path: $dir";
    }
  }
}

sub get_short_description {
  my $desc = shift || q{};

  if( $desc =~ /^([^.]+)[.]\s+/ ) {
    $desc = "$1.";
  }

  return $desc;
}

sub templatize {
  my ($stub, $markdown, $description, $subtitle, $template) = @_;

  my $title = $stub;
  $title =~ s!/!::!g;

  $description = get_short_description $description;

  $template =~ s!{{title}}!$title!;
  $template =~ s!{{description}}!$description!;
  $template =~ s!{{synopsis}}!$subtitle!;

  say "templatize @ $title";
  say "\t $template";

  return $template . $markdown;
}

my @data = <DATA>;
my $template = join '', @data;

my $content;
my $filename;
my $markdown;
my $description;
my $subtitle;
my @pages;
foreach(@files) {
  # save package name
  if( $_ =~ /\/Users\/nathan\/source\/perl-rethinkdb\/lib\/(.+)\.pm$/ ) {
    push @pages, $1;
  }

  # create markdowns
  ($content, $description, $subtitle) = convertToMarkdown $_;
  $content = templatize($pages[$#pages], $content, $description, $subtitle, $template);

  $filename = $_;
  $filename =~ s!/Users/nathan/source/perl-rethinkdb/lib/!contents/packages/!;
  $filename =~ s!.pm$!/index.md!;
  $filename = lc $filename;
  $markdown = $filename;

  say "writing $filename";
  makeDirectory $filename;
  write_file $filename, $content;

  # # make navigation file
  # $content = buildNavigation $content;
  # $filename =~ s!content/!templates/includes/!;
  # $filename =~ s!(\w+).md$!nav-$1.hbs!;
  #
  # say "writing $filename";
  # write_file $filename, $content;
  #
  # # make the template file
  # $content = $template;
  # $content =~ s!{{md}}!$markdown!;
  # $filename = $markdown;
  # $filename =~ s!content/!templates/!;
  # $filename =~ s!.md$!.hbs!;
  #
  # say "writing $filename";
  # write_file $filename, $content;
}

my $menu = q{};
foreach(@pages) {
  my $name = $_;
  my $text = $name;
  my $link = lc $name;
  $link .= '.html';

  $text =~ s!/!::!g;

  $menu .= "- [$text]($link)\n";
};

$filename = 'contents/toc.md';
say "writing $filename";
write_file $filename, $menu;


__DATA__
---
title: {{title}}
template: package.jade
synopsis: {{synopsis}}
description: {{description}}
---
