---
title: Rethinkdb
template: package.jade
synopsis: Pure Perl RethinkDB Driver
description: Rethinkdb enables Perl programs to interact with RethinkDB in a easy-to-use way.
---
# Rethinkdb

Rethinkdb enables Perl programs to interact with RethinkDB in a easy-to-use way. This particular driver is based on the official Python, Javascript, and Ruby drivers.  To learn more about RethinkDB take a look at the official documentation.

```perl
package MyApp;
use Rethinkdb;

r->connect->repl;
r->table('agents')->get('007')->update(
  r->branch(
    r->row->attr('in_centrifuge'),
    {'expectation': 'death'},
    {}
  )
)->run;

```

## ATTRIBUTES

[Rethinkdb](/packages/rethinkdb) implements the following attributes.

### io

```perl
my $io = r->io;
r->io(Rethinkdb::IO->new);

```

The `io` attribute returns the current [Rethinkdb::IO](/packages/rethinkdb/io) instance that
[Rethinkdb](/packages/rethinkdb) is currently set to use. If `io` is not set by the time `run`
is called, then an error will occur.

### term

```perl
my $term = r->term;

```

The `term` attribute returns an instance of the RethinkDB Query Langague
protocol.

## METHODS

[Rethinkdb](/packages/rethinkdb) inherits all methods from [Rethinkdb::Base](/packages/rethinkdb/base) and implements the
following methods.

### r

```perl
my $r = r;
my $conn = r->connect;

```

`r` is a factory method to begin a new Rethink DB query. The `r` sub is
exported in the importer's namespace so that it can be used as short-hand;
similar to what the official drivers provide. In addition, to creating a
new instance, if a [Rethinkdb::IO](/packages/rethinkdb/io) connection has been repl-ized, then that
connection will be set via `io` in the new instance.

### connect

```perl
my $conn1 = r->connect;
my $conn2 = r->connect('localhost', 28015, 'test', 'auth_key', 20);

```

Create a new connection to a RethinkDB shard. Creating a connection tries to
contact the RethinkDB shard immediately and will fail if the connection fails.

### db_create

```perl
r->db_create('test')->run;

```

Create a database. A RethinkDB database is a collection of tables, similar to
relational databases.

### db_drop

```perl
r->db_drop('test')->run;

```

Drop a database. The database, all its tables, and corresponding data will be
deleted.

### db_list

```perl
r->db_list->run;

```

List all database names in the system.

### db

```perl
r->db('irl')->table('marvel')->run;

```

Reference a database.

### table

```perl
r->table('marvel')->run;
r->table('marvel', 1)->run;
r->table('marvel')->get('Iron Man')->run;
r->table('marvel', r->true)->get('Iron Man')->run;

```

Select all documents in a table. This command can be chained with other
commands to do further processing on the data.

### row

```perl
r->table('users')->filter(r->row->attr('age')->lt(5))->run;
r->table('users')->filter(
  r->row->attr('embedded_doc')->attr('child')->gt(5)
)->run;
r->expr([1, 2, 3])->map(r->row->add(1))->run;
r->table('users')->filter(sub {
  my $row = shift;
  $row->attr('name')->eq(r->table('prizes')->get('winner'));
})->run;

```

Returns the currently visited document.

### literal

```perl
r->table('users')->get(1)->update({
  data: r->literal({ age => 19, job => 'Engineer' })
})->run;

```

Replace an object in a field instead of merging it with an existing object in a
merge or update operation.

### object

```perl
r->object('id', 5, 'data', ['foo', 'bar'])->run;

```

Creates an object from a list of key-value pairs, where the keys must be
strings. `r.object(A, B, C, D)` is equivalent to
`r.expr([[A, B], [C, D]]).coerce_to('OBJECT')`.

### and

```perl
r->and(true, false)->run;

```

Compute the logical "and" of two or more values.

### or

```perl
r->or(true, false)->run;

```

Compute the logical "or" of two or more values.

### random

```perl
r->random()
r->random(number[, number], {float => true})
r->random(integer[, integer])

```

Generate a random number between given (or implied) bounds. `random` takes
zero, one or two arguments.

### now

```perl
r->table("users")->insert({
  name => "John",
  subscription_date => r->now()
})->run($conn);

```

Return a time object representing the current time in UTC. The command `now()`
is computed once when the server receives the query, so multiple instances of
`r.now()` will always return the same time inside a query.

### time

```perl
r->table('user')->get('John')->update({
  birthdate => r->time(1986, 11, 3, 'Z')
})->run;

```

Create a time object for a specific time.

### epoch_time

```perl
r->table('user')->get('John')->update({
  "birthdate" => r->epoch_time(531360000)
})->run;

```

Create a time object based on seconds since epoch. The first argument is a
double and will be rounded to three decimal places (millisecond-precision).

### iso8601

```perl
r->table('user')->get('John')->update({
  birth => r->iso8601('1986-11-03T08:30:00-07:00')
})->run;

```

Create a time object based on an ISO 8601 date-time string
(e.g. '2013-01-01T01:01:01+00:00'). We support all valid ISO 8601 formats
except for week dates. If you pass an ISO 8601 date-time without a time zone,
you must specify the time zone with the default_timezone argument. Read more
about the ISO 8601 format at [Wikipedia](http://en.wikipedia.org/wiki/ISO_8601).

### monday

```perl
r->table('users')->filter(
  r->row('birthdate')->day_of_week()->eq(r->monday)
)->run;

```

["monday"](#monday) is a literal day of the week for comparisions.

### tuesday

```perl
r->table('users')->filter(
  r->row('birthdate')->day_of_week()->eq(r->tuesday)
)->run;

```

["tuesday"](#tuesday) is a literal day of the week for comparisions.

### wednesday

```perl
r->table('users')->filter(
  r->row('birthdate')->day_of_week()->eq(r->wednesday)
)->run;

```

["wednesday"](#wednesday) is a literal day of the week for comparisions.

### thursday

```perl
r->table('users')->filter(
  r->row('birthdate')->day_of_week()->eq(r->thursday)
)->run;

```

[thursday](/packages/thursday) is a literal day of the week for comparisions.

### friday

```perl
r->table('users')->filter(
  r->row('birthdate')->day_of_week()->eq(r->friday)
)->run;

```

["friday"](#friday) is a literal day of the week for comparisions.

### saturday

```perl
r->table('users')->filter(
  r->row('birthdate')->day_of_week()->eq(r->saturday)
)->run;

```

["saturday"](#saturday) is a literal day of the week for comparisions.

### sunday

```perl
r->table('users')->filter(
  r->row('birthdate')->day_of_week()->eq(r->sunday)
)->run;

```

["sunday"](#sunday) is a literal day of the week for comparisions.

### january

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->january)
)->run;

```

["january"](#january) is a literal month for comparisions.

### february

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->february)
)->run;

```

["february"](#february) is a literal month for comparisions.

### march

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->march)
)->run;

```

["march"](#march) is a literal month for comparisions.

### april

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->april)
)->run;

```

["april"](#april) is a literal month for comparisions.

### may

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->may)
)->run;

```

["may"](#may) is a literal month for comparisions.

### june

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->june)
)->run;

```

["june"](#june) is a literal month for comparisions.

### july

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->july)
)->run;

```

["july"](#july) is a literal month for comparisions.

### august

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->august)
)->run;

```

["august"](#august) is a literal month for comparisions.

### september

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->september)
)->run;

```

["september"](#september) is a literal month for comparisions.

### october

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->october)
)->run;

```

["october"](#october) is a literal month for comparisions.

### november

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->november)
)->run;

```

["november"](#november) is a literal month for comparisions.

### december

```perl
r->table('users')->filter(
  r->row('birthdate')->month()->eq(r->december)
)->run;

```

["december"](#december) is a literal month for comparisions.

### args

```perl
r->table('people')->get_all('Alice', 'Bob')->run;
# or
r->table('people')->get_all(r->args(['Alice', 'Bob']))->run;

```

`r->args` is a special term that's used to splice an array of arguments into
another term. This is useful when you want to call a variadic term such as
["get_all" in Rethinkdb::Query::Table](/packages/rethinkdb/query/table#get_all) with a set of arguments produced at runtime.

### do

```perl
r->do(r->table('marvel')->get('IronMan'), sub {
  my $ironman = shift;
  return $ironman->attr('name');
})->run;

```

Evaluate the expr in the context of one or more value bindings. The type of
the result is the type of the value returned from expr.

### branch

```perl
r->table('marvel')->map(
  r->branch(
    r->row->attr('victories')->lt(100),
    r->row->attr('name')->add(' is a superhero'),
    r->row->attr('name')->add(' is a hero')
  )
)->run;

```

Evaluate one of two control paths based on the value of an expression. `branch`
is effectively an `if` renamed due to language constraints. The type of the
result is determined by the type of the branch that gets executed.

### error

```perl
r->table('marvel')->get('IronMan')->do(sub {
  my $ironman = shift;
  r->branch(
    $ironman->attr('victories')->lt($ironman->attr('battles')),
    r->error('impossible code path'),
    $ironman
  );
})->run;

```

Throw a runtime error. If called with no arguments inside the second argument
to default, re-throw the current error.

### expr

```perl
r->expr({a => 'b'})->merge({b => [1,2,3]})->run($conn);

```

Construct a RQL JSON object from a native object.

### js

```perl
r->js("'str1' + 'str2'")->run($conn);
r->table('marvel')->filter(
  r->js('(function (row) { return row.age > 90; })')
)->run($conn);
r->js('while(true) {}', 1.3)->run($conn);

```

Create a javascript expression.

### json

```perl
r->json("[1,2,3]")->run($conn);

```

Parse a JSON string on the server.

### http

```perl
r->table('posts')->insert(r->http('httpbin.org/get'))->run;
r->http('http://httpbin.org/post', {
  method => 'POST',
  data   => {
    player => 'Bob',
    game   => 'tic tac toe'
  }
})->run($conn);

```

Retrieve data from the specified URL over HTTP. The return type depends on the
`result_format` option, which checks the `Content-Type` of the response by
default.

### uuid

```perl
r->uuid->run;

```

Return a UUID (universally unique identifier), a string that can be used as a
unique ID.

### asc

```perl
r->table('marvel')->order_by(r->asc('enemies_vanquished'))->run;

```

Specifies that a column should be ordered in ascending order.

### desc

```perl
r->table('marvel')->order_by(r->desc('enemies_vanquished'))->run;

```

Specifies that a column should be ordered in descending order.

### true

```perl
r->true->run;

```

Helper literal since Perl does not have a `true` literal.

### false

```perl
r->false->run;

```

Helper literal since Perl does not have a `false` literal.

