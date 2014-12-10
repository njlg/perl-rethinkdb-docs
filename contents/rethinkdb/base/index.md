---
title: Rethinkdb::Base
template: package.jade
synopsis: Minimal base class
description: 
---
# Rethinkdb::Base

```perl
package Cat;
use Rethinkdb::Base -base;

has name => 'Nyan';
has [qw(birds mice)] => 2;

package Tiger;
use Rethinkdb::Base 'Cat';

has friend  => sub { Cat->new };
has stripes => 42;

package main;
use Rethinkdb::Base -strict;

my $mew = Cat->new(name => 'Longcat');
say $mew->mice;
say $mew->mice(3)->birds(4)->mice;

my $rawr = Tiger->new(stripes => 23, mice => 0);
say $rawr->tap(sub { $_->friend->name('Tacgnol') })->mice;

```

## DESCRIPTION

[Rethinkdb::Base](/packages/rethinkdb/base) is a simple base class.

```perl
## Automatically enables "strict", "warnings", "utf8" and Perl 5.10 features
use Rethinkdb::Base -strict;
use Rethinkdb::Base -base;
use Rethinkdb::Base 'SomeBaseClass';

```

All three forms save a lot of typing.

```perl
## use Rethinkdb::Base -strict;
use strict;
use warnings;
use utf8;
use feature ':5.10';
use IO::Handle ();

## use Rethinkdb::Base -base;
use strict;
use warnings;
use utf8;
use feature ':5.10';
use IO::Handle ();
use Rethinkdb::Base;
push @ISA, 'Rethinkdb::Base';
sub has { Rethinkdb::Base::attr(__PACKAGE__, @_) }

## use Rethinkdb::Base 'SomeBaseClass';
use strict;
use warnings;
use utf8;
use feature ':5.10';
use IO::Handle ();
require SomeBaseClass;
push @ISA, 'SomeBaseClass';
use Rethinkdb::Base;
sub has { Rethinkdb::Base::attr(__PACKAGE__, @_) }

```

## FUNCTIONS

[Rethinkdb::Base](/packages/rethinkdb/base) exports the following functions if imported with the `-base`
flag or a base class.

### has

```perl
has 'name';
has [qw(name1 name2 name3)];
has name => 'foo';
has name => sub {...};
has [qw(name1 name2 name3)] => 'foo';
has [qw(name1 name2 name3)] => sub {...};

```

Create attributes for hash-based objects, just like the `attr` method.

## METHODS

[Rethinkdb::Base](/packages/rethinkdb/base) implements the following methods.

### new

```perl
my $object = BaseSubClass->new;
my $object = BaseSubClass->new(name => 'value');
my $object = BaseSubClass->new({name => 'value'});

```

This base class provides a basic constructor for hash-based objects. You can
pass it either a hash or a hash reference with attribute values.

### attr

```perl
$object->attr('name');
BaseSubClass->attr('name');
BaseSubClass->attr([qw(name1 name2 name3)]);
BaseSubClass->attr(name => 'foo');
BaseSubClass->attr(name => sub {...});
BaseSubClass->attr([qw(name1 name2 name3)] => 'foo');
BaseSubClass->attr([qw(name1 name2 name3)] => sub {...});

```

Create attribute accessor for hash-based objects, an array reference can be
used to create more than one at a time. Pass an optional second argument to
set a default value, it should be a constant or a callback. The callback will
be excuted at accessor read time if there's no set value. Accessors can be
chained, that means they return their invocant when they are called with an
argument.

### tap

```perl
$object = $object->tap(sub {...});

```

K combinator, tap into a method chain to perform operations on an object
within the chain.

## DEBUGGING

You can set the RDB_BASE_DEBUG environment variable to get some advanced
diagnostics information printed to `STDERR`.

```perl
RDB_BASE_DEBUG=1

```

## COPYRIGHT AND LICENSE

This package was taken from the Mojolicious project.

Copyright &copy; 2008-2013, Sebastian Riedel.

## SEE ALSO

[Mojo::Base](/packages/mojo/base), [Mojolicious](/packages/mojolicious), [http://mojolicio.us](http://mojolicio.us).