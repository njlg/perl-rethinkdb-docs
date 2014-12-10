---
title: Rethinkdb::Query::Datum
template: package.jade
synopsis: RethinkDB Query Datum
description: 
---
# Rethinkdb::Query::Datum

## DESCRIPTION

[Rethinkdb::Query::Datum](/packages/rethinkdb/query/datum) is the smallest building block in the RethinkDB
Query Language. A datum can be thought of as a primative. A datum can have the
following types: `null`, `number`, `string`, or `boolean`.

## ATTRIBUTES

[Rethinkdb::Query::Datum](/packages/rethinkdb/query/datum) implements the following attributes.

### data

```perl
my $datum = r->expr('Lorem Ipsum');
say $datum->data;

```

The actual datum value of this instance.

### datumType

```perl
my $datum = r->expr('Lorem Ipsum');
say $datum->datumType;

```

The actual RQL (RethinkDB Query Language) datum type of this instance.

## SEE ALSO

[Rethinkdb](/packages/rethinkdb), [http://rethinkdb.com](http://rethinkdb.com)