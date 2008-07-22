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

info(Tab, Item) ->
     ets:info(Tab, Item).

lookup(Tab, Key) ->
    ets:lookup(Tab, Key).

insert(Tab, Val) ->
    ets:insert(Tab, Val).

match_object(Tab, Pat) ->
    ets:match_object(Tab, Pat).

select(Tab, Pat) ->
    ets:select(Tab, Pat).

select(Cont) ->
    ets:select(Cont).

select(Tab, Pat, Limit) ->
    ets:select(Tab, Pat, Limit).

fixtable(Tab, Bool) ->
    ets:safe_fixtable(Tab, Bool).

delete(Tab, Key) ->
    ets:delete(Tab, Key).

match_delete(Tab, Pat) ->
    ets:match_delete(Tab, Pat).

first(Tab) ->
    ets:first(Tab).

next(Tab, Key) ->
    ets:next(Tab, Key).

last(Tab) ->
    ets:last(Tab).

prev(Tab, Key) ->
    ets:prev(Tab, Key).

slot(Tab, Pos) ->
    ets:slot(Tab, Pos).

update_counter(Tab, C, Val) ->
    ets:update_counter(Tab, C, Val).

create_table(Tab, Cs) ->
    { _, Type, _ } = Cs#cstruct.type,
    Args = [{keypos, 2}, public, named_table, Type],
    ets:new(Tab, Args).

delete_table(Tab) ->
    ets:delete(Tab).

add_index(_Tab, _Pos) ->
    ok.

delete_index(_Tab, _Pos) ->
    ok.

init_index(_Tab, _Pos) ->
    ok.

init_table(_Tab, _InitFun, _Sender) ->
    ok.
