%% @doc API for mnesia storage modules.
%% @end

-module(mnesia_ext).

-export([behaviour_info/1]).

-include ("mnesia.hrl").

% Provided for documentation purposes.

-export ([ info/2,
           lookup/2,
           insert/2,
           match_object/2,
           select/1,
           select/2,
           select/3,
           delete/2,
           match_delete/2,
           first/1,
           next/2,
           last/1,
           prev/2,
           slot/2,
           update_counter/3,
           create_table/2,
           delete_table/1,
           init_index/2,
           add_index/2,
           delete_index/2,
           fixtable/2,
           init_table/3
         ]).

%-=====================================================================-
%-                                Public                               -
%-=====================================================================-

behaviour_info(callbacks) ->
    [{info, 2},
     {lookup, 2},
     {insert, 2},
     {match_object, 2},  
     {select, 1},
     {select, 2},	 
     {select, 3},
     {delete, 2},
     {match_delete, 2},
     {first, 1},
     {next, 2},
     {last, 1},
     {prev, 2},
     {slot, 2},
     {init_table, 3},
     {update_counter, 3},
     {create_table, 2},
     {delete_table, 1},
     {init_index, 2},
     {add_index, 2},
     {delete_index, 2},
     {fixtable, 2} % dummy?
    ];

behaviour_info(_Other) ->
    undefined.

-define (is_increment (X), (is_integer (X) orelse
                            (is_tuple (X) andalso
                             size (X) =:= 2 andalso
                             is_integer (element (1, X)) andalso
                             is_integer (element (2, X))))).

%% @type tabid () = atom () | checkpoint_tab ().  A table identifier.
%% @end

-define (is_tabid (X), (is_atom (X) orelse
                        (is_tuple (X) andalso
                         size (X) =:= 2 andalso
                         is_atom (element (1, X))))).

%% @type checkpoint_tab () = { atom (), any () }.  Tables that are part
%% of checkpoint retainers have tuple identifiers.  Implementations should
%% ensure there is no possible collision in (file) namespace between
%% "regular" tables and checkpoint tables.
%% @end

%% @type object () = tuple ().  Everything stored in a table is a tuple.
%% @end

%% @type match_variable () = '$<number>'.
%% A variable in a match specification, e.g., '$1', '$45'.
%% @end

%% @type match_head_part () = any () | '_' | match_variable ().
%% @end

%% @type match_head () = match_variable () | '_' | [ match_head_part () ].
%% Basically a match spec with no conditions or body.  Used for 
%% match_object and match_delete.  A list has OR semantics.
%% @end

%% @type match_function () = { match_head (), match_conditions (), match_body () }.
%% @end

%% @type match_specification () = [ match_function () ].
%% For more information see [http://www.erlang.org/doc/apps/erts/match_spec.html].
%% @end

%-=====================================================================-
%-                         mnesia_ext callbacks                        -
%-=====================================================================-

%% @spec info (tabid (), any ()) -> Value::any () | undefined
%% @doc At a minimum, your table must support the following Items:
%%    * size: total number of records
%%    * memory: total space usage.  it's up to you to decide whether
%%              ram or disk (or something else) is the measured space.
%% @end

info (Tab, _What) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec lookup (tabid (), any ()) -> [ object () ] | { error, Reason }
%% @doc Lookup the object(s) associated with the key.
%% @end

lookup (Tab, _Key) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec insert (tabid (), objects ()) -> ok | { error, Reason }
%%   where
%%      objects () = object () | [ object () ]
%% @doc Insert one or more objects into the table.
%% @end

insert (Tab, _Objects) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec match_object (tabid (), match_head ()) -> ok | { error, Reason }
%% @doc Returns all the objects that match the given pattern.
%% @end

match_object (Tab, _Pattern) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec select (select_continuation ()) -> { [ Match::object () ], More::select_continuation () } | '$end_of_table' | { error, Reason }
%% @doc Return additional results from a continuation returned via select/1 
%% or select/3.
%% @end

select (_Continuation) ->
  erlang:throw (not_implemented).

%% @spec select (tabid (), match_specification ()) -> [ Match::object () ] | { error, Reason }
%% @doc Select all the results that match a given specification.
%% @end

select (Tab, _MatchSpec) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec select (tabid (), match_specification (), integer ()) -> { [ Match::object () ], More::select_continuation () } | '$end_of_table' | { error, Reason }
%% @doc Return a limited number of results from a select, plus a continuation
%% which can return more via select/1.  You should attempt to honor the limit
%% field, but the mnesia specification already says the limit is not 
%% guaranteed.
%% @end

select (Tab, _MatchSpec, Limit) when ?is_tabid (Tab),
                                     (is_integer (Limit) andalso Limit > 0) ->
  erlang:throw (not_implemented).

%% @spec delete (tabid (), key ()) -> ok | { error, Reason }
%% @doc Delete all the records associated with Key.
%% @end

delete (Tab, _Key) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec match_delete (tabid (), match_head ()) -> N::integer () | { error, Reason }
%% @doc Delete all objects which match the pattern.  Returns the number of
%% objects deleted.
%% @end

match_delete (Tab, _Pattern) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec first (tabid ()) -> Key::any () | '$end_of_table'
%% @doc Returns the first key stored in the table according to the 
%% table's internal order, or '$end_of_table' if the table is empty.
%% If you support ordered_set semantics, then "internal order" means
%% erlang term order, otherwise, you are free to interpret as you like.
%% @end

first (Tab) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec next (tabid (), any ()) -> NextKey::any () | '$end_of_table'
%% @doc Returns the next key stored in the table according to the 
%% table's internal order, or '$end_of_table' if the table is empty.
%% If you support ordered_set semantics, then "internal order" means
%% erlang term order, otherwise, you are free to interpret as you like.
%% @end

next (Tab, _Key) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec last (tabid ()) -> Key::any () | '$end_of_table'
%% @doc Returns the last key stored in the table according to the 
%% table's internal order, or '$end_of_table' if the table is empty.
%% If you support ordered_set semantics, then "internal order" means
%% erlang term order, otherwise, you are free to interpret as you like.
%% @end

last (Tab) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec prev (tabid (), any ()) -> NextKey::any () | '$end_of_table'
%% @doc Returns the previous key stored in the table according to the 
%% table's internal order, or '$end_of_table' if the table is empty.
%% If you support ordered_set semantics, then "internal order" means
%% erlang term order, otherwise, you are free to interpret as you like.
%% @end

prev (Tab, _Key) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec slot (tabid (), integer ()) -> [ object () ] | '$end_of_table' | { error, Reason }
%% @doc Not sure.
%% @end

slot (Tab, N) when ?is_tabid (Tab), 
                   (is_integer (N) andalso N >= 0) ->
  erlang:throw (not_implemented).

% @spec init_table (tabid (), initfun (), [ option () ]) -> ok | { error, Reason }
%%  where
%%    option () = { format, Format }
%% @doc Replaces the existing objects of the table with
%% objects created by calling the input function InitFun,
%% see below. 
%% 
%% When called with the argument read the function InitFun is
%% assumed to return end_of_input when there is no more input,
%% or { Objects, Fun }, where Objects is a list of objects
%% and Fun is a new input function. Any other value Value is
%% returned as an error { error, { init_fun, Value } }. Each input
%% function will be called exactly once, and should an error
%% occur, the last function is called with the argument close,
%% the reply of which is ignored.
%% 
%% If the type of the table is ordered_set and there is more than
%% one object with a given key, one of the objects is
%% chosen. This is not necessarily the last object with the
%% given key in the sequence of objects returned by the input
%% functions. Extra objects should be avoided, or the file
%% will be unnecessarily fragmented. This holds also for
%% duplicated objects stored in tables of type bag.
%%
%% The Options argument is a list of { Key, Val } tuples where
%% the following values are allowed:
%% 
%%    * { format, Format }. Specifies the format of the objects
%%    returned by the function InitFun. If Format is term
%%    (the default), InitFun is assumed to return a list
%%    of tuples. If Format is bchunk, InitFun is assumed
%%    to return Data as returned by bchunk/2. 
%%
%% TODO: There is no bchunk/2 right now in the mnesia storage api extension.
%% @end

init_table (Tab, InitFun, Options) when ?is_tabid (Tab),
                                        is_function (InitFun, 1),
                                        is_list (Options) ->
  erlang:throw (not_implemented).

%% @spec update_counter (tabid (), any (), increment ()) -> integer ()
%%   where
%%     increment () = { position (), delta () } | delta ()
%%     position () = integer ()
%%     delta () = integer ()
%% @doc Update a counter (integer field) associated with the record
%% associated with key.  Only valid for set type tables.  It is supposed
%% to be implemented atomically at the table driver level.
%% @end

update_counter (Tab, _Key, Increment) when ?is_tabid (Tab),
                                           ?is_increment (Increment) ->
  erlang:throw (not_implemented).
  
%% @spec create_table (tabid (), cstruct ()) -> { ok, Tab::tabid () } | { error, Reason }
%% @doc Open an existing table, creating it if necessary.  If Tab
%% is an atom, the table is a "normal" table.  If Tab is a tuple, then
%% the table is a "checkpointer retainer" table.  You must ensure that
%% the filesystem namespace used for checkpointer retainer tables is 
%% distinct from that used for normal tables; an easy way to ensure this
%% is to use a different filename extension.
%%
%% NB: The user_properties
%% portion of cstruct can be useful for communicating driver-specific 
%% settings.
%%
%% NB: mnesia_lib:dir/0 can be called to locate the mnesia directory
%% where you should place files.
%%
%% NB: The process which calls this function is as long-lived as the 
%% mnesia application; therefore
%% ports, ets tables, and other per-process-deallocated entities can 
%% be safely owned by the calling process.
%% @end

create_table (Tab, Cs) when ?is_tabid (Tab), is_record (Cs, cstruct) ->
  erlang:throw (not_implemented).

%% @spec delete_table (tabid ()) -> ok | { error, Reason }
%% @doc Delete the table, including any associated persistent storage.
%% @end

delete_table (Tab) when ?is_tabid (Tab) ->
  erlang:throw (not_implemented).

%% @spec init_index (tabid (), integer ()) -> ok | { error, Reason }
%% @doc Initialize an index on a given position.  This index will
%% already have been added by add_index/2 at some point in the past
%% (not necessarily during the lifetime of the current Erlang node).
%%
%% Essentially this function advises you to load whatever structures are
%% necessary to utilize a particular index.
%% @end

init_index (Tab, Position) when ?is_tabid (Tab),
                                (is_integer (Position) andalso Position > 2) ->
  erlang:throw (not_implemented).

%% @spec add_index (tabid (), integer ()) -> ok | { error, Reason }
%% @doc Create an index on a given position.  Indices in mnesia_ext
%% are advisory; the low level calls routed to the storage layer are
%% still match_object/2 and match_delete/2.  Essentially users who 
%% create an index on a position expect that match patterns which only
%% that position bound are still reasonably efficient to execute.
%%
%% Thus, this function advises you that steps should be taken to make
%% match patterns with only the given position bound efficient.
%% @end

add_index (Tab, Position) when ?is_tabid (Tab),
                               (is_integer (Position) andalso Position > 2) ->
  erlang:throw (not_implemented).

%% @spec delete_index (tabid (), integer ()) -> ok | { error, Reason }
%% @doc Delete an index on a given position.  
%% @end

delete_index (Tab, Position) when ?is_tabid (Tab),
                               (is_integer (Position) andalso Position > 2) ->
  erlang:throw (not_implemented).

%% @spec fixtable (tabid (), bool ()) -> true
%% @doc (Un)Fixes a table for safe traversal.
%% For ordered_set tables, this function is not required to do anything.
%%
%% For other tables types, when a table is fixed, a sequence of 
%% first/1 and next/2 calls are guaranteed to succeed and each object in 
%% the table will only be returned once, even if objects are
%% removed or inserted during the traversal. The keys for new
%% objects inserted during the traversal may  be returned by
%% next/2  (it depends on the internal ordering of the keys).
%%
%% @end

fixtable (Tab, Bool) when ?is_tabid (Tab), is_boolean (Bool) ->
  erlang:throw (not_implemented).
