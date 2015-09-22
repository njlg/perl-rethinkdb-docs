---
title: Rethinkdb::Query::Table
template: package.jade
synopsis: RethinkDB Query Table
description: Rethinkdb::Query::Table is a type of query that represents a table in a database.
---
# Rethinkdb::Query::Table

Rethinkdb::Query::Table is a type of query that represents a table in a database. This classes contains methods to interact with said table.

## ATTRIBUTES

[Rethinkdb::Query::Table](/perl-rethinkdb/rethinkdb/query/table) implements the following attributes.

### name

```perl
my $table = r->db('comics')->table('superheros');
say $table->name;

```

The name of the table.

## METHODS

[Rethinkdb::Query::Table](/perl-rethinkdb/rethinkdb/query/table) implements the following methods.

### create

```perl
r->db('test')->table('dc_universe')->create->run;

```

Create this table. A RethinkDB table is a collection of JSON documents.

If successful, the operation returns an object: `{created => 1}`. If a
table with the same name already exists, the operation returns a
`runtime_error`.

**Note:** that you can only use alphanumeric characters and underscores for the
table name.

### drop

```perl
r->db('test')->table('dc_universe')->drop->run(conn)

```

Drop this table. The table and all its data will be deleted.

If successful, the operation returns an object: `{dropped => 1}`. If the
specified table doesn't exist a `runtime_error` is returned.

### index_create

```perl
r->table('comments')->index_create('post_id')->run;

```

Create a new secondary index on a table.

### index_drop

```perl
r->table('dc')->index_drop('code_name')->run;

```

Delete a previously created secondary index of this table.

### index_list

```perl
r->table('marvel')->index_list->run;

```

List all the secondary indexes of this table.

### index_rename

```perl
r->table('marvel')->index_rename('heroId', 'awesomeId')->run;

```

Rename an existing secondary index on a table. If the optional argument
`overwrite` is specified as `true`, a previously existing index with the new
name will be deleted and the index will be renamed. If `overwrite` is `false`
(the default) an error will be raised if the new index name already exists.

### index_status

```perl
r->table('test')->index_status->run;
r->table('test')->index_status('timestamp')->run;

```

Get the status of the specified indexes on this table, or the status of all
indexes on this table if no indexes are specified.

### index_wait

```perl
r->table('test')->index_wait->run;
r->table('test')->index_wait('timestamp')->run;

```

Wait for the specified indexes on this table to be ready, or for all indexes on
this table to be ready if no indexes are specified.

### changes

```perl
my $stream = r->table('games')->changes(sub {
  my $item;
  say Dumper $_;
})->run;

```

Return an infinite stream of objects representing changes to a table. Whenever
an `insert`, `delete`, `update` or `replace` is performed on the table, an
object of the form `{'old_val' => ..., 'new_val' => ...}` will be appended
to the stream. For an `insert`, `old_val` will be `null`, and for a
`delete`, `new_val` will be `null`.

### insert

```perl
r->table('posts')->insert({
  id => 1,
  title => 'Lorem ipsum',
  content => 'Dolor sit amet'
})->run;

```

Insert documents into a table. Accepts a single document or an array of
documents.

### sync

["sync"](#sync) ensures that writes on a given table are written to permanent storage.
Queries that specify soft durability `{durability => 'soft'}` do not give
such guarantees, so sync can be used to ensure the state of these queries. A
call to sync does not return until all previous writes to the table are
persisted.

### get

```perl
r->table('posts')->get('a9849eef-7176-4411-935b-79a6e3c56a74')->run;

```

Get a document by primary key.

If no document exists with that primary key, ["get"](#get) will return `null`.

### get_all

```perl
r->table('marvel')->get_all('man_of_steel', { index => 'code_name' })->run;

```

Get all documents where the given value matches the value of the requested
index.

### between

```perl
r->table('marvel')->between(10, 20)->run;

```

Get all documents between two keys. Accepts three optional arguments: `index`,
`left_bound`, and `right_bound`. If `index` is set to the name of a
secondary index, ["between"](#between) will return all documents where that index's value
is in the specified range (it uses the primary key by default). `left_bound`
or `right_bound` may be set to open or closed to indicate whether or not to
include that endpoint of the range (by default, `left_bound` is closed and
`right_bound` is open).

### get_intersecting

```perl
r->table('geo')
  ->get_intersecting(
  r->circle( [ -122.423246, 37.770378359 ], 10, { unit => 'mi' } ),
  { index => 'location' } )->run;

```

Get all documents where the given geometry object intersects the geometry
object of the requested geospatial index.

### get_nearest

```perl
r->table('geo')->get_nearest(
  r->point( -122.422876, 37.777128 ),
  { index => 'location', max_dist => 5000 }
)->run;

```

Get all documents where the specified geospatial index is within a certain
distance of the specified point (default 100 kilometers).

### config

```perl
r->table('marvel')->config->run;

```

Query (read and/or update) the configurations for individual tables.

### rebalance

```perl
r->table('marvel')->rebalance->run;

```

Rebalances the shards of a table.

### reconfigure

```perl
r->table('marvel')->reconfigure({ shards => 2, replicas => 1 })->run;
r->table('marvel')->reconfigure(
  {
    shards              => 2,
    replicas            => { wooster => 1, wayne => 1 },
    primary_replica_tag => 'wooster'
  }
)->run;

```

Reconfigure a table's sharding and replication.

### status

```perl
r->table('marvel')->status->run;

```

Return the status of a table. The return value is an object providing
information about the table's shards, replicas and replica readiness states

### wait

```perl
r->table('marvel')->wait->run;

```

Wait for a table to be ready. A table may be temporarily unavailable
after creation, rebalancing or reconfiguring. The ["wait"](#wait) command
blocks until the given table is fully up to date.