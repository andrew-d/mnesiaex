-module(ext).

-compile([export_all]).

-include_lib("stdlib/include/ms_transform.hrl").
-include_lib("eunit/include/eunit.hrl").
-include("ext.hrl").

init() ->
    init([node()]).

init_frag() ->
    init_frag([node()]).

init(Nodes) ->
    init(testtab, [
                   {external_copies, Nodes}, 
                   {type, {external, bag, ramtab}}, 
                   {attributes, record_info(fields, testtab)},
                   {index, [baz]}
                  ], Nodes).

init_frag(Nodes) ->
    init(testtab,  [
                    {type, {external, bag, ramtab}}, 
                    {frag_properties, 
                     [{node_pool, [node()]}, 
                      {n_fragments, 20}, 
                      {n_external_copies, 1}]},
                    {index, [baz]},
                    {attributes, record_info(fields, testtab)}
                   ], Nodes).

init(Tab, Attrs, Nodes) ->
    mnesia:stop(),
    mnesia:delete_schema(Nodes),
    catch(mnesia:create_schema(Nodes)),
    mnesia:start(),
    case mnesia:create_table(Tab, Attrs) of
	{atomic, ok} ->
	    ok;
	Any ->
	    error_logger:error_report([{message, "Cannot install table"},
				       {table, external},
				       {error, Any},
				       {nodes, Nodes}])
    end.

%%% Tracing

ut() ->
    dbg:ctp().

t(What) ->
    dbg:tracer(),
    dbg:p(all, [call]),
    t1(What).

t() ->
    t([mnesia,
       mnesia_backup,
       mnesia_bup,
       mnesia_checkpoint,
       mnesia_checkpoint_sup,
       mnesia_controller,
       mnesia_dumper,
       mnesia_event,
       mnesia_frag,
       mnesia_frag_hash,
       mnesia_frag_old_hash,
       mnesia_index,
       mnesia_kernel_sup,
       mnesia_late_loader,
       mnesia_lib,
       mnesia_loader,
       mnesia_locker,
       mnesia_log,
       mnesia_monitor,
       mnesia_recover,
       mnesia_registry,
       mnesia_schema,
       mnesia_snmp_hook,
       mnesia_snmp_sup,
       mnesia_sp,
       mnesia_subscr,
       mnesia_sup,
       mnesia_text,
       mnesia_tm
      ]).

ts() ->
    t([mnesia_schema,
       mnesia_controller,
       {mnesia_lib, set},
       {mnesia_lib, val},
       ramtab
      ]),
    ok.

to() ->
    t([{mnesia_lib, db_put},
       {mnesia_lib, db_get},
       ramtab
      ]),
    ok.

t1([]) ->
    ok;

t1([{M, F}|T]) ->
    dbg:tpl(M, F, dbg:fun2ms(fun(_) -> return_trace() end)),
    t1(T);

t1([H|T]) ->
    dbg:tpl(H, dbg:fun2ms(fun(_) -> return_trace() end)),
    t1(T).

%%%
%%% Test suite
%%%

naked_write(Rec) ->
    fun() -> mnesia:write(Rec) end.

naked_read(Key) ->
    fun() -> mnesia:read({testtab, Key}) end.

naked_read(Key, Limit) ->
    MatchHead = #testtab{foo = Key, _ = '_'},
    Guard = [],
    Result = ['$_'],
    MatchSpec = [{MatchHead, Guard, Result}],
    fun() -> read_more(mnesia:select(testtab, MatchSpec, Limit, read)) end.

read_more({L, '$end_of_table'}) ->
    L;
read_more(Cont) ->
    read_more(Cont, []).

read_more({L, '$end_of_table'}, Acc) ->
    [L|Acc];
read_more({L, Cont}, Acc) ->
    read_more(mnesia:select(Cont), [L|Acc]);
read_more('$end_of_table', Acc) ->
    Acc;
read_more(X, _Acc) ->
    X.

read(Key) ->
    mnesia:transaction(naked_read(Key)).

write(Rec) ->
    mnesia:transaction(naked_write(Rec)).

read(Key, Limit) ->
    mnesia:transaction(naked_read(Key, Limit)).

delete(Key) ->
    F = fun() -> mnesia:delete({testtab, Key}) end,
    mnesia:transaction(F).
    
fixlist(L) ->
    L1 = lists:flatten(L),
    lists:keysort(2, L1).
   
read_write_test() ->
    init(),
    mnesia:clear_table(testtab),
    Rec = #testtab{foo = 1, bar = 2, baz = 3},
    Rec1 = Rec#testtab{bar = 3, baz = 2},
    Rec2 = Rec#testtab{foo = 2},
    ?assertMatch({atomic, []}, read(1)),
    ?assertMatch({atomic, ok}, write(Rec)),
    ?assertMatch({atomic, [{testtab, 1, 2, 3}]}, read(1)),
    ?assertMatch({atomic, ok}, delete(1)),
    ?assertMatch({atomic, []}, read(1)),
    %% select with continuations
    ?assertMatch({atomic, ok}, write(Rec)),
    ?assertMatch({atomic, ok}, write(Rec1)),
    ?assertMatch({atomic, ok}, write(Rec2)),
    {atomic, L1} = read(1, 1),
    ?assertMatch([Rec, Rec1], fixlist(L1)),
    {atomic, L2} = read(2, 1),
    ?assertMatch([Rec2], fixlist(L2)),
    ok.

index_test() ->
    X1 = mnesia:del_table_index(testtab, baz),
    ?assertMatch({atomic, ok}, X1),
    X2 = mnesia:add_table_index(testtab, baz),
    ?assertMatch({atomic, ok}, X2),
    ok.

write_frag(Rec) ->
    mnesia:activity(transaction, naked_write(Rec), [], mnesia_frag).

read_frag(Key) ->
    mnesia:activity(transaction, naked_read(Key), [], mnesia_frag).
                 
read_frag(Key, Limit) ->
    mnesia:activity(transaction, naked_read(Key, Limit), [], mnesia_frag).

frag_read_write_test() ->
    init_frag(),
    mnesia:clear_table(testtab),
    Rec = #testtab{foo = 1, bar = 2, baz = 3},
    Rec1 = Rec#testtab{bar = 3, baz = 2},
    Rec2 = Rec#testtab{foo = 2},
    ?assertMatch({atomic, []}, read(1)),
    ?assertMatch({atomic, ok}, write(Rec)),
    ?assertMatch({atomic, [{testtab, 1, 2, 3}]}, read(1)),
    ?assertMatch({atomic, ok}, delete(1)),
    ?assertMatch({atomic, []}, read(1)),
    %% select with continuations
    ?assertMatch({atomic, ok}, write(Rec)),
    ?assertMatch({atomic, ok}, write(Rec1)),
    ?assertMatch({atomic, ok}, write(Rec2)),
    {atomic, L1} = read(1, 1),
    ?assertMatch([Rec, Rec1], fixlist(L1)),
    {atomic, L2} = read(2, 1),
    ?assertMatch([Rec2], fixlist(L2)),
    ok.

cleanup_test() ->
  mnesia:stop (),
  os:cmd ("rm -rf Mnesia.*"),
  ok.
