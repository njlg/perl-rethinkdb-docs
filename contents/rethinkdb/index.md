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

[Rethinkdb](/perl-rethinkdb/rethinkdb) implements the following attributes.

### io

```perl
my $io = r->io;
r->io(Rethinkdb::IO->new);

```

The `io` attribute returns the current [Rethinkdb::IO](/perl-rethinkdb/rethinkdb/io) instance that
[Rethinkdb](/perl-rethinkdb/rethinkdb) is currently set to use. If `io` is not set by the time `run`
is called, then an error will occur.

### term

```perl
my $term = r->term;

```

The `term` attribute returns an instance of the RethinkDB Query Langague
protocol.

## METHODS

[Rethinkdb](/perl-rethinkdb/rethinkdb) inherits all methods from [Rethinkdb::Base](/perl-rethinkdb/rethinkdb/base) and implements the
following methods.

### r

```perl
my $r = r;
my $conn = r->connect;

```

`r` is a factory method to begin a new Rethink DB query. The `r` sub is
exported in the importer's namespace so that it can be used as short-hand;
similar to what the official drivers provide. In addition, to creating a
new instance, if a [Rethinkdb::IO](/perl-rethinkdb/rethinkdb/io) connection has been repl-ized, then that
connection will be set via `io` in the new instance.

### connect

```perl
my $conn1 = r->connect;
my $conn2 = r->connect('localhost', 28015, 'test', 'auth_key', 20);

```

Create a new connection to a RethinkDB shard. Creating a connection tries to
contact the RethinkDB shard immediately and will fail if the connection fails.

### server

```perl
r->server->run;

```

Return information about the server being used by the default connection.

The server command returns either two or three fields:

- `id`: the UUID of the server the client is connected to.
- `proxy`: a boolean indicating whether the server is a [RethinkDB proxy node](http://rethinkdb.com/docs/sharding-and-replication/#running-a-proxy-node).
- `name`: the server name. If proxy is `r->true`, this field will not
be returned.

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

Compute the logical `and` of two or more values.

### or

```perl
r->or(true, false)->run;

```

Compute the logical `or` of two or more values.

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

["thursday"](#thursday) is a literal day of the week for comparisions.

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
["get_all" in Rethinkdb::Query::Table](/perl-rethinkdb/rethinkdb/query/table#get_all) with a set of arguments produced at runtime.

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

### circle

```perl
r->circle( [ -122.423246, 37.770378359 ], 10, { unit => 'mi' } )

```

Construct a circular line or polygon. A circle in RethinkDB is a polygon or
line approximating a circle of a given radius around a given center,
consisting of a specified number of vertices (default 32).

### distance

```perl
r->distance(
  r->point( -122.423246, 37.779388 ),
  r->point( -117.220406, 32.719464 ),
  { unit => 'km' }
)->run;

```

Compute the distance between a point and another geometry object. At least
one of the geometry objects specified must be a point.

### geojson

```perl
r->geojson(
  { 'type' => 'Point', 'coordinates' => [ -122.423246, 37.779388 ] } )

```

Convert a [GeoJSON](http://geojson.org/) object to a ReQL geometry object.

### line

```perl
r->line( [ -122.423246, 37.779388 ], [ -121.886420, 37.329898 ] )

```

Construct a geometry object of type Line. The line can be specified in one of
two ways:
(1) Two or more two-item arrays, specifying latitude and longitude numbers of
the line's vertices;
(2) Two or more ["point"](#point) objects specifying the line's vertices.

### point

```perl
r->point( -122.423246, 37.779388 )

```

Construct a geometry object of type Point. The point is specified by two
floating point numbers, the longitude (-180 to 180) and latitude (-90 to 90)
of the point on a perfect sphere.

### polygon

```perl
r->polygon(
  [ -122.423246, 37.779388 ],
  [ -122.423246, 37.329898 ],
  [ -121.886420, 37.329898 ],
  [ -121.886420, 37.779388 ]
)

```

Construct a geometry object of type Polygon. The Polygon can be specified in
one of two ways:
(1) Three or more two-item arrays, specifying longitude and latitude numbers
of the polygon's vertices;
(2) Three or more ["point"](#point) objects specifying the polygon's vertices.

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

### wait

```perl
r->wait->run;

```

Wait on all the tables in the default database (set with the ["connect"](#connect)
command's `db` parameter, which defaults to `test`). A table may be
temporarily unavailable after creation, rebalancing or reconfiguring. The
["wait"](#wait) command blocks until the given all the tables in database is fully up
to date.

### minval

```perl
r->table('marvel')->between( r->minval, 7 )->run;

```

The special constants ["minval"](#minval) is used for specifying a boundary, which
represent "less than any index key". For instance, if you use ["minval"](#minval) as the
lower key, then ["between" in Rethinkdb::Query::Table](/perl-rethinkdb/rethinkdb/query/table#between) will return all documents
whose primary keys (or indexes) are less than the specified upper key.

### maxval

```perl
r->table('marvel')->between( 8, r->maxval )->run;

```

The special constants ["maxval"](#maxval) is used for specifying a boundary, which
represent "greater than any index key". For instance, if you use ["maxval"](#maxval) as
the upper key, then ["between" in Rethinkdb::Query::Table](/perl-rethinkdb/rethinkdb/query/table#between) will return all
documents whose primary keys (or indexes) are greater than the specified lower
key.

### round

```perl
r->round(-12.567)->run;

```

Rounds the given value to the nearest whole integer. For example, values of
1.0 up to but not including 1.5 will return 1.0, similar to ["floor"](#floor); values
of 1.5 up to 2.0 will return 2.0, similar to ["ceil"](#ceil).

### ceil

```perl
r->ceil(-12.567)->run;

```

Rounds the given value up, returning the smallest integer value greater than
or equal to the given value (the value's ceiling).

### floor

```perl
r->floor(-12.567)->run;

```

Rounds the given value down, returning the largest integer value less than or
equal to the given value (the value's floor).

### grant

```perl
r->grant('username', {read => r->true, write => r->false })->run;

```

Grant or deny access permissions for a user account globally.

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

