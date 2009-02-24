-module(ramtab).

-behaviour(mnesia_ext).

-include ("../src/mnesia.hrl").

-export([info/2, lookup/2, insert/2, match_object/2,  
         select/1, select/2, select/3, delete/2,
         match_delete/2, first/1, next/2, last/1,
         prev/2, slot/2, update_counter/3,
         create_table/2, delete_table/1, 
         add_index/2, delete_index/2,
         init_index/2, fixtable/2, init_table/3
         ]).

unmangle(Mangled) ->
  case atom_to_list(Mangled) of
    "_hide_me_" ++ T -> list_to_atom (T)
  end.

mangle(Tab) ->
  list_to_atom("_hide_me_" ++ atom_to_list(Tab)).

info(Tab, name) ->
     unmangle(ets:info(mangle(Tab), name));
info(Tab, Item) ->
     ets:info(mangle(Tab), Item).

lookup(Tab, Key) ->
    ets:lookup(mangle(Tab), Key).

insert(Tab, Val) ->
    ets:insert(mangle(Tab), Val).

match_object(Tab, Pat) ->
    ets:match_object(mangle(Tab), Pat).

select(Tab, Pat) ->
    ts:select(mangle(Tab), Pat).

select(Cont) ->
    ets:select(Cont).

select(Tab, Pat, Limit) ->
    ets:select(mangle(Tab), Pat, Limit).

fixtable(Tab, Bool) ->
    ets:safe_fixtable(mangle(Tab), Bool).

delete(Tab, Key) ->
    ets:delete(mangle(Tab), Key).

match_delete(Tab, Pat) ->
    ets:match_delete(mangle(Tab), Pat).

first(Tab) ->
    ets:first(mangle(Tab)).

next(Tab, Key) ->
    ets:next(mangle(Tab), Key).

last(Tab) ->
    ets:last(mangle(Tab)).

prev(Tab, Key) ->
    ets:prev(mangle(Tab), Key).

slot(Tab, Pos) ->
    ets:slot(mangle(Tab), Pos).

update_counter(Tab, C, Val) ->
    ets:update_counter(mangle(Tab), C, Val).

create_table(Tab, Cs) ->
    { _, Type, _ } = Cs#cstruct.type,
    Args = [{keypos, 2}, public, named_table, Type],
    unmangle(ets:new(mangle(Tab), Args)).

delete_table(Tab) ->
    ets:delete(mangle(Tab)).

add_index(_Tab, _Pos) ->
    ok.

delete_index(_Tab, _Pos) ->
    ok.

init_index(_Tab, _Pos) ->
    ok.

init_table(Tab, InitFun, _Sender) ->
    ets:init_table(mangle(Tab), InitFun).
