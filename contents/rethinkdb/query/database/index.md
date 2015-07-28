---
title: Rethinkdb::Query::Database
template: package.jade
synopsis: RethinkDB Query Database
description: Rethinkdb::Query::Database is a type of query that represents a database.
---
# Rethinkdb::Query::Database

Rethinkdb::Query::Database is a type of query that represents a database. This classes contains methods to interact with a database or the underlying tables.

## ATTRIBUTES

[Rethinkdb::Query::Database](/perl-rethinkdb/rethinkdb/query/database) implements the following attributes.

### name

```perl
my $db = r->db('better');
say $db->name;

```

The name of the database.

## METHODS

### create

```perl
r->db('test')->create('superheroes')->run;

```

Create a database. A RethinkDB database is a collection of tables, similar to
relational databases.

If successful, the operation returns an object: `{created => 1}`. If a
database with the same name already exists the operation returns an
`runtime_error`.

**Note**: that you can only use alphanumeric characters and underscores for the
database name.

### drop

```perl
r->db('comics')->drop('superheroes')->run;

```

Drop a database. The database, all its tables, and corresponding data will be
deleted.

If successful, the operation returns the object `{dropped => 1}`. If the
specified database doesn't exist a `runtime_error` will be returned.

### list

```perl
r->db('sillyStuff')->list->run;

```

List all database names in the system. The result is a list of strings.

### table

```perl
r->db('newStuff')->table('weapons')->run;

```

Select all documents in a table from this database. This command can be chained
with other commands to do further processing on the data.

### table_create

```perl
r->db('test')->table_create('dc_universe')->run;

```

Create a table. A RethinkDB table is a collection of JSON documents.

If successful, the operation returns an object: `{created => 1}`. If a
table with the same name already exists, the operation returns a
`runtime_error`.

**Note:** that you can only use alphanumeric characters and underscores for the
table name.

### table_drop

```perl
r->db('test')->table_drop('dc_universe')->run;

```

Drop a table. The table and all its data will be deleted.

If successful, the operation returns an object: `{dropped => 1}`. If the
specified table doesn't exist a `runtime_error` is returned.

### table_list

```perl
r->db('test')->table_list->run;

```

List all table names in a database. The result is a list of strings.

### config

```perl
r->db('test')->config->run;

```

Query (read and/or update) the configurations for individual databases.

### rebalance

```perl
r->db('test')->rebalance->run;

```

Rebalances the shards of all tables in the database.

### reconfigure

```perl
r->db('test')->reconfigure({ shards => 2, replicas => 1 })->run;
r->db('test')->reconfigure(
  {
    shards              => 2,
    replicas            => { wooster => 1, wayne => 1 },
    primary_replica_tag => 'wooster'
  }
)->run;

```

Reconfigure all table's sharding and replication.

### wait

```perl
r->db('test')->wait->run;

```

Wait for all the tables in a database to be ready. A table may be
temporarily unavailable after creation, rebalancing or reconfiguring.
The ["wait"](#wait) command blocks until the given database is fully up to date.