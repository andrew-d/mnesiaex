#summary Overview
#labels Featured

# Motivation #

The goal of this project is to provide an extensible storage API for
Mnesia.  This way, the strengths of Mnesia (distributed, transactional,
impedence match to Erlang) can be coupled to the universe of possible
storage strategies.

# Status #

What doesn't work:
  1. upgrading a running mnesia installation.  we have changed the cstruct record and didn't think at all about how to migrate an existing schema over to the new record.
  1. mnesia:change\_table\_copy\_type/3 ; it seems very reasonable to support this in the future, we've just been busy.  submit a patch!

What should work: everything else![[1](#1.md)]  In particular:
  1. "normal" reads, writes, deletes, selects, matches, etc.
  1. index reads; although I confess this hasn't been tested that much.  Plus, indexing is essentially [deferred to the storage layer](#Indexing.md).
  1. backups (and checkpoint retainers).
  1. schema operations (other than mnesia:change\_table\_copy\_type/3).  mnesia:add\_table\_copy/3, mnesia:del\_table\_copy/3, mnesia:move\_table\_copy/3, etc.  For instance, all the unit tests of [fragmentron](http://code.google.com/p/fragmentron) pass.

Working doesn't mean optimized, of course.  For instance, remote table
loading for dets can use bchunks, whereas we just use select always;
so we could improve throughput by defining a bchunk callback to the
mnesia\_ext behaviour and exploiting that.

If you have ideas for improvement, we'd like to hear about them.

# Indexing #

The indexing strategy in mnesia\_ext is "advisory".  Basically, when a
user creates (deletes) an index on a table, the add\_index/2 (delete\_index/2 respectively) callback is executed.  The semantics are "hey, the user
would like match specifications with a particular position bound to
work efficiently." (or "no longer work efficiently" for delete\_index/2).

There are no special read or write calls that correspond to index\_read,
index\_match\_object, etc.  Instead the match\_delete/2, match\_object/2,
and select/1,2,3 callbacks will encounter match specifications where
the key is not bound (but the indexed column is); these match specifications
are supposed to run "fast" if they have been "indexed".

# Example #

Tcerl has a wiki page with [example usage](http://code.google.com/p/tcerl/wiki/Example).

# Footnote #

## 1 ##

We intended it to work anyway.  It would be nice to have some kind of exhaustive mnesia test suite to make stronger statements.