---
title: Rethinkdb::Response
template: package.jade
synopsis: RethinkDB Response
description: All responses from the driver come as an instance of this class.
---
# Rethinkdb::Response

All responses from the driver come as an instance of this class.

```perl
package MyApp;
use Rethinkdb;

my $res = r->table('marvel')->run;
say $res->type;
say $res->type_description;
say $res->response;
say $res->token;
say $res->error_type;
say $res->profile;
say $res->backtrace;

```

## ATTRIBUTES

[Rethinkdb::Response](/perl-rethinkdb/rethinkdb/response) implements the following attributes.

### type

```perl
my $res = r->table('marvel')->run;
say $res->type;

```

The response type code. The current response types are:

```perl
'success_atom' => 1
'success_sequence' => 2
'success_partial' => 3
'success_feed' => 5
'wait_complete' => 4
'client_error' => 16
'compile_error' => 17
'runtime_error' => 18

```

### type_description

```perl
my $res = r->table('marvel')->run;
say $res->type_description;

```

The response type description (e.g. `success_atom`, `runtime_error`).

### response

```perl
use Data::Dumper;
my $res = r->table('marvel')->run;
say Dumper $res->response;

```

The actual response value from the database.

### token

```perl
my $res = r->table('marvel')->run;
say Dumper $res->token;

```

Each request made to the database must have a unique token. The response from
the database includes that token incase further actions are required.

### error_type

```perl
my $res = r->table('marvel')->run;
say $res->error_type;

```

If the request cause an error, this attribute will contain the error message
from the database.

### backtrace

```perl
my $res = r->table('marvel')->run;
say $res->backtrace;

```

If the request cause an error, this attribute will contain a backtrace for the
error.

### profile

```perl
my $res = r->table('marvel')->run;
say $res->profile;

```

If profiling information was requested as a global argument for a query, then
this attribute will contain that profiling data.

## SEE ALSO

[Rethinkdb](/perl-rethinkdb/rethinkdb), [http://rethinkdb.com](http://rethinkdb.com)