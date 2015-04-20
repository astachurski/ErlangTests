%%generic registered process template
%%
%%Package name: 
%%Created by adrian at 4/3/2015 on %TIME

-module(proc).
-export([loop/1, start/0, init_zero/1]).
-include_lib("eunit/include/eunit.hrl").

%---------------------- server side macros---------------
-define(reply_with(X), Client ! {self(), X}).
-define(on_receive_from_client(X), {Client, X}).
-define(on_unknown_message(X), ?on_receive_from_client(X)).
-define(NUMBER_OF_RING_PROCESSES, 10).


%----------- small util funs ----------------------

%create some usable suffix from pid passed as list/string
pid_to_proc_id(PidString) ->
  Stringtokens = string:tokens(PidString, "."),
  L = (lists:flatten(Stringtokens)),
  [X || X <- L, X > $0, X =< $9].

%---------------------- client side ---------------

start() ->
  spawn(?MODULE, init_zero, [?NUMBER_OF_RING_PROCESSES]),
  ok.


init_zero(NoOfProcesses) ->
  SrcPid = start_chain_of_impl(self(), NoOfProcesses, 0),
  io:format("\created: ~p with next: ~p\n", [self(), SrcPid]),
  %in fact, the first process becomes logically the last one
  loop({?NUMBER_OF_RING_PROCESSES, SrcPid}).

start_chain_of_impl(SrcPid, _, ?NUMBER_OF_RING_PROCESSES) ->
  SrcPid;

start_chain_of_impl(SrcPid, NoOfProcesses, Acc) ->
  Regname = list_to_atom("p" ++ pid_to_proc_id(erlang:pid_to_list(SrcPid))),
  register(Regname, SrcPid),
  NewPid = spawn_link(?MODULE, loop, [{Acc, SrcPid}]),
  io:format("\created: ~p with next: ~p\n", [NewPid, SrcPid]),
  start_chain_of_impl(NewPid, NoOfProcesses, Acc + 1).


%----public API ----------


%% echo_data(DestPid, SomeArgs) ->
%%   rpc(DestPid, SomeArgs).
%%
%% do_stupid_thing(DestPid) ->
%%   rpc(DestPid, dostupid).
%%
%% showup(DestPid) ->
%%   rpc(DestPid, showup).

%----private API ---------

%% rpc(DestPid, Request) ->
%%   DestPid ! {self(), Request},
%%   receive
%%   %receive ONLY from registered process
%%     {DestPid, Response} -> {ok, Response}
%%   end.

%---------------------- server side ---------------

loop(PrevPid) ->
  {Idx, PrevPidVal} = PrevPid,
  receive
    ?on_receive_from_client(spawn_link_new) ->
      present_creation_info(Idx, PrevPidVal),
      LinkedToPid = spawn_link(?MODULE, loop, [{Idx + 1, self()}]),
      ?reply_with(LinkedToPid),
      loop(PrevPid);
    ?on_receive_from_client(showdata) ->
      present_info_string(),
      ProcInfo = erlang:process_info(self(), [links]),
      ?reply_with(ProcInfo);
    ?on_receive_from_client(showdataall) ->
%present_info_string(),
      io:format("~nselfpid: ~p, prevpid: ~p~n", [self(), PrevPidVal]),
      PrevPidVal ! {self(), showdataall},
      ?reply_with(nothing),
      loop(PrevPid);
    ?on_receive_from_client(ping) ->
%just echo received data
      present_info_string(),
      ?reply_with(pong),
      loop(PrevPid);
    ?on_unknown_message(X) ->
%just echo received data
      ?reply_with(X),
      loop(PrevPid)

  end.

% ================================== helper funs ==========

present_info_string() -> io:format("~p~n~n ", [erlang:process_info(self(), [registered_name, links])]).

present_creation_info(Idx, PrevPidVal) ->
  io:format("~nprocess #~p, current pid : #~p, previous pid: ~p ~n", [Idx, self(), PrevPidVal]),
  present_info_string().

% ================================== EUNIT tests ==========

pid_to_proc_id_test() ->
  TestPid = "<1.70.5>",
  Result = pid_to_proc_id(TestPid),
  ?debugVal(Result),
  ?assertEqual(Result, "1705").

pid_to_proc_id2_test() ->
  TestPid = "",
  Result = pid_to_proc_id(TestPid),
  ?debugVal(Result),
  ?assertEqual(Result, "").

pid_to_proc_id3_test() ->
  TestPid = "arstSRTs.rstri.y",
  Result = pid_to_proc_id(TestPid),
  ?debugVal(Result),
  ?assertEqual(Result, "").