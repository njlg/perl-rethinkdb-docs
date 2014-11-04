---
title: Rethinkdb::IO
template: package.jade
synopsis: RethinkDB IO
description: This module handles communicating with the RethinkDB Database.
---
# Rethinkdb::IO

This module handles communicating with the RethinkDB Database.




```perl
package MyApp;
use Rethinkdb::IO;

my $io = Rethinkdb::IO->new->connect;
$io->use('marvel');
$io->close;

```

## ATTRIBUTES

[Rethinkdb::IO](/packages/rethinkdb/io) implements the following attributes.

### host

```perl
my $io = Rethinkdb::IO->new->connect;
my $host = $io->host;
$io->host('r.example.com');

```

The `host` attribute returns or sets the current host name that
[Rethinkdb::IO](/packages/rethinkdb/io) is currently set to use.

### port

```perl
my $io = Rethinkdb::IO->new->connect;
my $port = $io->port;
$io->port(1212);

```

The `port` attribute returns or sets the current port number that
[Rethinkdb::IO](/packages/rethinkdb/io) is currently set to use.

### default_db

```perl
my $io = Rethinkdb::IO->new->connect;
my $port = $io->default_db;
$io->default_db('marvel');

```

The `default_db` attribute returns or sets the current database name that
[Rethinkdb::IO](/packages/rethinkdb/io) is currently set to use.

### auth_key

```perl
my $io = Rethinkdb::IO->new->connect;
my $port = $io->auth_key;
$io->auth_key('setec astronomy');

```

The `auth_key` attribute returns or sets the current authentication key that
[Rethinkdb::IO](/packages/rethinkdb/io) is currently set to use.

### timeout

```perl
my $io = Rethinkdb::IO->new->connect;
my $timeout = $io->timeout;
$io->timeout(60);

```

The `timeout` attribute returns or sets the timeout length that
[Rethinkdb::IO](/packages/rethinkdb/io) is currently set to use.

## METHODS

[Rethinkdb::IO](/packages/rethinkdb/io) inherits all methods from [Rethinkdb::Base](/packages/rethinkdb/base) and implements
the following methods.

### connect

```perl
my $io = Rethinkdb::IO->new;
$io->host('rdb.example.com');
$io->connect->repl;

```

The `connect` method initiates the connection to the RethinkDB database.

### close

```perl
my $io = Rethinkdb::IO->new;
$io->host('rdb.example.com');
$io->connect;
$io->close;

```

The `connect` method closes the current connection to the RethinkDB database.

### reconnect

```perl
my $io = Rethinkdb::IO->new;
$io->host('rdb.example.com');
$io->connect;
$io->reconnect;

```

The `reconnect` method closes and reopens a connection to the RethinkDB
database.

### repl

```perl
my $io = Rethinkdb::IO->new;
$io->host('rdb.example.com');
$io->connect->repl;

```

The `repl` method caches the current connection in to the main program so that
it is available to for all [Rethinkdb](/packages/rethinkdb) queries without specifically specifying
one.

### use

```perl
my $io = Rethinkdb::IO->new;
$io->use('marven');
$io->connect;

```

The `use` method sets the default database name to use for all queries that
use this connection.

### noreply_wait

```perl
my $io = Rethinkdb::IO->new;
$io->noreply_wait;

```

The `noreply_wait` method will tell the database to wait until all "no reply"
have executed before responding.

## SEE ALSO

[Rethinkdb](/packages/rethinkdb), [http://rethinkdb.com](http://rethinkdb.com)