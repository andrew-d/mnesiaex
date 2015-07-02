Mnesia is the Erlang built-in multi-master distributed database.  Unfortunately, Mnesia only ships with support for two types of data storage (ets and dets) both of which have limitations.

This project defines a new behaviour mnesia\_ext, and patches mnesia to support using modules which conform to the behaviour for storage.  This allows for arbitrary storage strategies to be incorporated.

**New**: Now works with mnesia from both `R11` (4.3.5) and `R12` (4.4.7) Erlang releases.

As a (useful!) example [tcerl](http://code.google.com/p/tcerl) contains [an implementation](http://code.google.com/p/tcerl/source/browse/trunk/tcerl/src/tcbdbtab.erl) of an ordered\_set disk-based mnesia table.

Another [Dukes of Erl](http://dukesoferl.blogspot.com/) release.