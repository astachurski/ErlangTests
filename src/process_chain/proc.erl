%%generic registered process template
%%
%%Package name: 
%%Created by adrian at 4/3/2015 on %TIME

-module(proc).
-export([start/0, echo_data/2, loop/0, do_stupid_thing/1, showup/1, start_chain_of/1]).

%---------------------- client side ---------------

start() ->
  spawn(?MODULE, loop, []).


start_chain_of(NoOfProcesses) ->
  start_chain_of_impl(start(), NoOfProcesses, 0).

start_chain_of_impl(SrcPid, NoOfProcesses, Acc) when Acc =< NoOfProcesses ->
  SrcPid ! {self(), spawn_new},
  receive
    {_, NewPid} ->
      io:format("got response"),
      start_chain_of_impl(NewPid, NoOfProcesses, Acc + 1)
  end;

start_chain_of_impl(SrcPid, _, _) -> SrcPid.


%----public API ----------

echo_data(DestPid, SomeArgs) ->
  rpc(DestPid, SomeArgs).


do_stupid_thing(DestPid) ->
  rpc(DestPid, dostupid).


showup(DestPid) ->
  rpc(DestPid, showup).

%----private API ---------

rpc(DestPid, Request) ->
  DestPid ! {self(), Request},
  receive
  %receive ONLY from registered process
    {DestPid, Response} -> {ok, Response}
  end.

%---------------------- server side ---------------
-define(reply_with(X), Client ! {self(), X}).
-define(on_receive_from_client(X), {Client, X}).

loop() ->
  receive
    ?on_receive_from_client(spawn_new) ->
      ChildPid = spawn_link(?MODULE, loop, []),
      ?reply_with(ChildPid),
      loop();
    ?on_receive_from_client(dostupid) ->
      io:format("now gonna do really stupid thing..."),
      ?reply_with(ididstupid),
      1 div 0,
      loop();
    ?on_receive_from_client(showup) ->
      ProcInfo = erlang:process_info(self(), [links, trap_exit]),
      ?reply_with(ProcInfo),
      loop();
    ?on_receive_from_client(Data) ->
      %just echo received data
      ?reply_with(Data),
      loop()
  end.