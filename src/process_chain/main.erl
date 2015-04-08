%%%-------------------------------------------------------------------
%%% @author adrian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Apr 2015 6:30 PM
%%%-------------------------------------------------------------------
-module(main).
-author("adrian").


%% API
-export([init_proc_chain/0, testall/0]).
-import(proc, [start/0, echo_data/2, showup/1]).
-import(lists, [map/2]).

testall() ->
  IdxAndPids = init_proc_chain(),
  L = [{X, Y} || {X, Y} <- IdxAndPids],
  io:format("processes spawn: ~p~n", [L]),
  io:format("info for each process: ~p~n", [show_diagnostic_info(L)]).

init_proc_chain() ->
  P = lists:seq(0, 3),
  lists:map(fun(X) -> prepare_process(X) end, P).

prepare_process(X) ->
  {X, proc:start()}.

show_diagnostic_info(ProcList) ->
  Infos = lists:map(fun({_,Y}) -> proc:showup(Y) end, ProcList),
  Infos.

