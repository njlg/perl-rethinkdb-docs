---
title: Rethinkdb::Query
template: package.jade
synopsis: RethinkDB Query
description: Rethinkdb::Query is a type of query.
---
# Rethinkdb::Query

Rethinkdb::Query is a type of query.

## ATTRIBUTES

[Rethinkdb::Query](/packages/rethinkdb/query) implements the following attributes.

### args

```perl
my $query = r->table('marvel')->get(1);
say $query->args;

```

The arguments for this instance of a query.

### optargs

```perl
my $query = r->table('marvel')->get_all(1, { index => 'rank' });
say $query->optargs;

```

The optional arguments for this instance of a query.

## METHODS

[Rethinkdb::Query](/packages/rethinkdb/query) implements the following methods.

### new

This is a specialized constructor that enables chaining the queries together
in a rational way. This constructor should never be called directly by
consumers of this library.

### run

```perl
r->table('marvel')->run;

```

Run a query on a connection.

The callback will get either an error, a single JSON result, or a cursor,
depending on the query.

### update

```perl
r->table('posts')->get(1)->update({status => 'published'})->run;

```

Update JSON documents in a table. Accepts a JSON document, a ReQL expression,
or a combination of the two.

### replace

```perl
r->table('posts')->get(1)->replace({
  id      => 1,
  title   => 'Lorem ipsum',
  content => 'Aleas jacta est',
  status  => 'draft'
})->run;

```

Replace documents in a table. Accepts a JSON document or a ReQL expression, and
replaces the original document with the new one. The new document must have the
same primary key as the original document.

### delete

```perl
r->table('comments')->
  get('7eab9e63-73f1-4f33-8ce4-95cbea626f59')->delete->run;

```

Delete one or more documents from a table.

### filter

```perl
r->table('users')->filter({'age' => 30})->run;

```

Get all the documents for which the given predicate is true.

["filter"](#filter) can be called on a sequence, selection, or a field containing an
array of elements. The return type is the same as the type on which the
function was called on.

The body of every filter is wrapped in an implicit `default(r->false)`,
which means that if a non-existence errors is thrown (when you try to access a
field that does not exist in a document), RethinkDB will just ignore the
document. The `default` value can be changed by passing the named argument
`default`. Setting this optional argument to `r->error` will cause any
non-existence errors to return a `runtime_error`.

### inner_join

```perl
r->table('marvel')->inner_join(r->table('dc'), sub($$) {
  my ($marvel, $dc) = @_;
  return marvel->attr('strength')->lt($dc->attr('strength'));
})->run;

```

Returns the inner product of two sequences (e.g. a table, a filter result)
filtered by the predicate. The query compares each row of the left sequence
with each row of the right sequence to find all pairs of rows which satisfy
the predicate. When the predicate is satisfied, each matched pair of rows of
both sequences are combined into a result row.

### outer_join

```perl
r->table('marvel')->outer_join(r->table('dc'), sub ($$) {
  my ($marvel, $dc) = @_;
  return $marvel->attr('strength')->lt($dc->attr('strength'));
})->run;

```

Computes a left outer join by retaining each row in the left table even if no
match was found in the right table.

### eq_join

```perl
r->table('players')->eq_join('gameId', r->table('games'))->run;

```

Join tables using a field on the left-hand sequence matching primary keys or
secondary indexes on the right-hand table. ["eq_join"](#eq_join) is more efficient than
other ReQL join types, and operates much faster. Documents in the result set
consist of pairs of left-hand and right-hand documents, matched when the
field on the left-hand side exists and is non-null and an entry with that
field's value exists in the specified index on the right-hand side.

### zip

```perl
r->table('marvel')->eq_join('main_dc_collaborator',
  r->table('dc'))->zip()->run;

```

Used to _zip_ up the result of a join by merging the _right_ fields into
_left_ fields of each member of the sequence.

### map

```perl
r->table('marvel')->map(sub {
  my $hero = shift;
  return $hero->attr('combatPower')->add(
    $hero->('compassionPower')->mul(2)
  );
})->run;

```

Transform each element of the sequence by applying the given mapping function.

### with_fields

```perl
r->table('users')->with_fields('id', 'username', 'posts')->run;

```

Plucks one or more attributes from a sequence of objects, filtering out any
objects in the sequence that do not have the specified fields. Functionally,
this is identical to ["has_fields"](#has_fields) followed by ["pluck"](#pluck) on a sequence.

### concat_map

```perl
r->table('marvel')->concatMap(sub {
  my $hero = shift;
  return $hero->attr('defeatedMonsters');
})->run;

```

Concatenate one or more elements into a single sequence using a mapping
function.

### order_by

```perl
r->table('posts')->order_by({index => 'date'})->run;
r->table('posts')->order_by({index => r->desc('date')})->run;

```

Sort the sequence by document values of the given key(s). To specify the
ordering, wrap the attribute with either [`r->asc`](/packages/rethinkdb#asc) or
[`r->desc`](/packages/rethinkdb#desc) (defaults to ascending).

Sorting without an index requires the server to hold the sequence in memory,
and is limited to 100,000 documents. Sorting with an index can be done on
arbitrarily large tables, or after a ["between" in Rethinkdb::Query::Table](/packages/rethinkdb/query/table#between) command
using the same index.

### skip

```perl
r->table('marvel')->order_by('successMetric')->skip(10)->run;

```

Skip a number of elements from the head of the sequence.

### limit

```perl
r->table('marvel')->order_by('belovedness')->limit(10)->run;

```

End the sequence after the given number of elements.

### slice

```perl
r->table('players')->order_by({index => 'age'})->slice(3, 6)->run;

```

Return the elements of a sequence within the specified range.

### nth

```perl
r->expr([1,2,3])->nth(1)->run;

```

Get the nth element of a sequence.

### indexes_of

```perl
r->expr(['a','b','c'])->indexes_of('c')->run;

```

Get the indexes of an element in a sequence. If the argument is a predicate,
get the indexes of all elements matching it.

### is_empty

```perl
r->table('marvel')->is_empty->run;

```

Test if a sequence is empty.

### union

```perl
r->table('marvel')->union(r->table('dc'))->run;

```

Concatenate two sequences.

### sample

```perl
r->table('marvel')->sample(3)->run;

```

Select a given number of elements from a sequence with uniform random
distribution. Selection is done without replacement.

### group

```perl
r->table('games')->group('player')->max('points')->run;

```

Takes a stream and partitions it into multiple groups based on the fields or
functions provided. Commands chained after ["group"](#group) will be called on each of
these grouped sub-streams, producing grouped data.

### ungroup

```perl
r->table('games')
  ->group('player')->max('points')->attr('points')
  ->ungroup()->order_by(r->desc('reduction'))->run;

```

Takes a grouped stream or grouped data and turns it into an array of objects
representing the groups. Any commands chained after ["ungroup"](#ungroup) will operate on
this array, rather than operating on each group individually. This is useful
if you want to e.g. order the groups by the value of their reduction.

### reduce

```perl
r->table('posts')->map(sub { return 1; })->reduce(sub($$) {
  my ($left, $right) = @_;
  return $left->add($right);
})->run;

```

Produce a single value from a sequence through repeated application of a
reduction function.

### count

```perl
r->table('marvel')->count->add(r->table('dc')->count->run

```

Count the number of elements in the sequence. With a single argument, count the
number of elements equal to it. If the argument is a function, it is equivalent
to calling filter before count.

### sum

```perl
r->expr([3, 5, 7])->sum->run;

```

Sums all the elements of a sequence. If called with a field name, sums all the
values of that field in the sequence, skipping elements of the sequence that
lack that field. If called with a function, calls that function on every
element of the sequence and sums the results, skipping elements of the sequence
where that function returns `null` or a non-existence error.

### avg

```perl
r->expr([3, 5, 7])->avg->run;

```

Averages all the elements of a sequence. If called with a field name, averages
all the values of that field in the sequence, skipping elements of the sequence
that lack that field. If called with a function, calls that function on every
element of the sequence and averages the results, skipping elements of the
sequence where that function returns `null` or a non-existence error.

### min

```perl
r->expr([3, 5, 7])->min->run;

```

Finds the minimum of a sequence. If called with a field name, finds the element
of that sequence with the smallest value in that field. If called with a
function, calls that function on every element of the sequence and returns the
element which produced the smallest value, ignoring any elements where the
function returns `null` or produces a non-existence error.

### max

```perl
r->expr([3, 5, 7])->max->run;

```

Finds the maximum of a sequence. If called with a field name, finds the element
of that sequence with the largest value in that field. If called with a
function, calls that function on every element of the sequence and returns the
element which produced the largest value, ignoring any elements where the
function returns null or produces a non-existence error.

### distinct

```perl
r->table('marvel')->concat_map(sub {
  my $hero = shift;
  return $hero->attr('villainList')
})->distinct->run;

```

Remove duplicate elements from the sequence.

### contains

```perl
r->table('marvel')->get('ironman')->
  attr('opponents')->contains('superman')->run;

```

Returns whether or not a sequence contains all the specified values, or if
functions are provided instead, returns whether or not a sequence contains
values matching all the specified functions.

### pluck

```perl
r->table('marvel')->get('IronMan')->
  pluck('reactorState', 'reactorPower')->run;

```

Plucks out one or more attributes from either an object or a sequence of
objects (projection).

### without

```perl
r->table('marvel')->get('IronMan')->without('personalVictoriesList')->run;

```

The opposite of pluck; takes an object or a sequence of objects, and returns
them with the specified paths removed.

### merge

```perl
r->table('marvel')->get('IronMan')->merge(
  r->table('loadouts')->get('alienInvasionKit')
)->run;

```

Merge two objects together to construct a new object with properties from both.
Gives preference to attributes from other when there is a conflict.

### append

```perl
r->table('marvel')->get('IronMan')->
  attr('equipment')->append('newBoots')->run;

```

Append a value to an array.

### prepend

```perl
r->table('marvel')->get('IronMan')->
  attr('equipment')->prepend('newBoots')->run;

```

Prepend a value to an array.

### difference

```perl
r->table('marvel')->get('IronMan')->
  attr('equipment')->difference(['Boots'])->run;

```

Remove the elements of one array from another array.

### set_insert

```perl
r->table('marvel')->get('IronMan')->
  attr('equipment')->set_insert('newBoots')->run;

```

Add a value to an array and return it as a set (an array with distinct values).

### set_union

```perl
r->table('marvel')->get('IronMan')->
  attr('equipment')->set_union(['newBoots', 'arc_reactor'])->run;

```

Add a several values to an array and return it as a set (an array with distinct
values).

### set_intersection

```perl
r->table('marvel')->get('IronMan')->attr('equipment')->
  set_intersection(['newBoots', 'arc_reactor'])->run;

```

Intersect two arrays returning values that occur in both of them as a set (an
array with distinct values).

### set_difference

```perl
r->table('marvel')->get('IronMan')->attr('equipment')->
  set_difference(['newBoots', 'arc_reactor'])->run;

```

Remove the elements of one array from another and return them as a set (an
array with distinct values).

### attr

```perl
r->table('marvel')->get('IronMan')->attr('firstAppearance')->run;

```

Get a single field from an object. If called on a sequence, gets that field
from every object in the sequence, skipping objects that lack it.

### has_fields

```perl
r->table('players')->has_fields('games_won')->run;

```

Test if an object has one or more fields. An object has a field if it has that
key and the key has a non-null value. For instance, the object
`{'a' => 1, 'b' => 2, 'c' => null}` has the fields `a` and `b`.

### insert_at

```perl
r->expr(['Iron Man', 'Spider-Man'])->insert_at(1, 'Hulk')->run;

```

Insert a value in to an array at a given index. Returns the modified array.

### splice_at

```perl
r->expr(['Iron Man', 'Spider-Man'])->splice_at(1, ['Hulk', 'Thor'])->run;

```

Insert several values in to an array at a given index. Returns the modified
array.

### delete_at

```perl
r->expr(['a','b','c','d','e','f'])->delete_at(1)->run;

```

Remove one or more elements from an array at a given index. Returns the
modified array.

### change_at

```perl
r->expr(['Iron Man', 'Bruce', 'Spider-Man'])->change_at(1, 'Hulk')->run;

```

Change a value in an array at a given index. Returns the modified array.

### keys

```perl
r->table('marvel')->get('ironman')->keys->run;

```

Return an array containing all of the object's keys.

### match

```perl
r->table('users')->filter(sub {
  my $doc = shift;
  return $doc->attr('name')->match('^A')
})->run;

```

Matches against a regular expression. If there is a match, returns an object
with the fields:

### split

```perl
r->expr('foo  bar bax')->split->run;
r->expr('foo,bar,bax')->split(",")->run;
r->expr('foo,bar,bax')->split(",", 1)->run;

```

Splits a string into substrings. Splits on whitespace when called with no
arguments. When called with a separator, splits on that separator. When called
with a separator and a maximum number of splits, splits on that separator at
most `max_splits` times. (Can be called with None as the separator if you want
to split on whitespace while still specifying `max_splits`.)

Mimics the behavior of Python's string.split in edge cases, except for
splitting on the empty string, which instead produces an array of
single-character strings.

### upcase

```perl
r->expr('Sentence about LaTeX.')->upcase->run;

```

Uppercases a string.

### downcase

```perl
r->expr('Sentence about LaTeX.')->downcase->run;

```

Lowercases a string.

### add

```perl
r->expr(2)->add(2)->run;

```

Sum two numbers, concatenate two strings, or concatenate 2 arrays.

### sub

```perl
r->expr(2)->sub(2)->run;

```

Subtract two numbers.

### mul

```perl
r->expr(2)->mul(2)->run;

```

Multiply two numbers, or make a periodic array.

### div

```perl
r->expr(2)->div(2)->run;

```

Divide two numbers.

### mod

```perl
r->expr(2)->mod(2)->run;

```

Find the remainder when dividing two numbers.

### and

```perl
r->expr(r->true)->and(r->false)->run;

```

Compute the logical "and" of two or more values.

### or

```perl
r->expr(r->true)->or(r->false)->run;

```

Compute the logical "or" of two or more values.

### eq

```perl
r->expr(2)->eq(2)->run;

```

Test if two values are equal.

### ne

```perl
r->expr(2)->ne(2)->run;

```

Test if two values are not equal.

### gt

```perl
r->expr(2)->gt(2)->run;

```

Test if the first value is greater than other.

### ge

```perl
r->expr(2)->ge(2)->run;

```

Test if the first value is greater than or equal to other.

### lt

```perl
r->expr(2)->lt(2)->run;

```

Test if the first value is less than other.

### le

```perl
r->expr(2)->le(2)->run;

```

Test if the first value is less than or equal to other.

### not

```perl
r->expr(r->true)->not->run;

```

Compute the logical inverse (not) of an expression.

### in_timezone

```perl
r->now->in_timezone('-08:00')->hours->run;

```

Return a new time object with a different timezone. While the time stays the
same, the results returned by methods such as ["hours"](#hours) will change since they
take the timezone into account. The timezone argument has to be of the ISO 8601
format.

### timezone

```perl
r->table('users')->filter(sub {
  my $user = shift;
  return $user->attr('subscriptionDate')->timezone->eql('-07:00');
})->run;

```

Return the timezone of the time object.

### during

```perl
r->table('posts')->filter(
  r->row->attr('date')->during(
    r->time(2013, 12, 1, 'Z'),
    r->time(2013, 12, 10, 'Z')
  )
)->run;

```

Return if a time is between two other times (by default, inclusive for the
start, exclusive for the end).

### date

```perl
r->table('users')->filter(sub {
  my $user = shift;
  return user->attr('birthdate')->date->eql(r->now->date);
})->run;

```

Return a new time object only based on the day, month and year (ie. the same
day at 00:00).

### time_of_day

```perl
r->table('posts')->filter(
  r->row->attr('date')->time_of_day->le(12*60*60)
)->run;

```

Return the number of seconds elapsed since the beginning of the day stored in
the time object.

### year

```perl
r->table('users')->filter(sub {
  my $user = shift;
  return user->attr('birthdate')->year->eql(1986);
})->run;

```

Return the year of a time object.

### month

```perl
r->table('users')->filter(
  r->row->attr('birthdate')->month->eql(11)
)->run;

```

Return the month of a time object as a number between 1 and 12. For your
convenience, the terms [`r->january`](/packages/rethinkdb#january),
[`r->february`](/packages/rethinkdb#february) etc. are defined and map to the
appropriate integer.

### day

```perl
r->table('users')->filter(
  r->row->attr('birthdate')->day->eql(24)
)->run;

```

Return the day of a time object as a number between 1 and 31.

### day_of_week

```perl
r->now->day_of_week->run;

```

Return the day of week of a time object as a number between 1 and 7 (following
ISO 8601 standard). For your convenience, the terms r.monday, r.tuesday etc.
are defined and map to the appropriate integer.

### day_of_year

```perl
r->now->day_of_year->run;

```

Return the day of the year of a time object as a number between 1 and 366
(following ISO 8601 standard).

### hours

```perl
r->table('posts')->filter(sub {
  my $post = shift;
  return $post->attr('date')->hours->lt(4);
})->run;

```

Return the hour in a time object as a number between 0 and 23.

### minutes

```perl
r->table('posts')->filter(sub {
  my $post = shift;
  return $post->attr('date')->minutes->lt(10);
})->run;

```

Return the minute in a time object as a number between 0 and 59.

### seconds

```perl
r->table('posts')->filter(sub {
  my $post = shift;
  return $post->attr('date')->seconds->lt(30);
})->run;

```

Return the seconds in a time object as a number between 0 and 59.999 (double
precision).

### to_iso8601

```perl
r->now->to_iso8601->run;

```

Convert a time object to its ISO 8601 format.

### to_epoch_time

```perl
r->now->to_epoch_time->run;

```

Convert a time object to its epoch time.

### do

```perl
r->table('players')->get('86be93eb-a112-48f5-a829-15b2cb49de1d')->do(sub {
  my $player = shift;
  return $player->attr('gross_score')->sub($player->attr('course_handicap'));
})->run

```

Evaluate an expression and pass its values as arguments to a function or to an
expression.

### for_each

```perl
r->table('marvel')->for_each(sub {
  my $hero = shift;
  r->table('villains')->get($hero->attr('villainDefeated'))->delete;
})->run;

```

Loop over a sequence, evaluating the given write query for each element.

### default

```perl
r->table('posts')->map(sub {
  my $post = shift;
  return {
    title => $post->attr('title'),
    author => $post->attr('author')->default('Anonymous')
  };
})->run

```

Handle non-existence errors. Tries to evaluate and return its first argument.
If an error related to the absence of a value is thrown in the process, or if
its first argument returns `null`, returns its second argument.
(Alternatively, the second argument may be a function which will be called with
either the text of the non-existence error or `null`.)

### coerce_to

```perl
r->table('posts')->map(sub {
  my $post = shift;
  return $post->merge({
    'comments' => r->table('comments')->get_all(
      $post->attr('id'), { index => 'post_id' })->coerce_to('array')
  });
)->run

```

Convert a value of one type into another.

### type_of

```perl
r->expr('foo')->type_of->run;

```

Gets the type of a value.

### info

```perl
r->table('marvel')->info->run;

```

Get information about a ReQL value.

## SEE ALSO

[Rethinkdb](/packages/rethinkdb), [http://rethinkdb.com](http://rethinkdb.com)