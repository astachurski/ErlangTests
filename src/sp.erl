%%%-------------------------------------------------------------------
%%% @author adrian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Mar 2015 8:04 PM
%%%-------------------------------------------------------------------
-module(sp).
-author("adrian").

%% API
-export([procmsgs/0, rpc/2, start/0]).

-record(bubu,{a,b,c}).

start() ->
  Pid = spawn(sp, procmsgs, []),
  io:format("my PID is: ~p~n", [Pid]),
  Pid.

rpc(Pid, Request) ->

  #bubu{a = 9},

  Pid ! {self(), Request},
  receive
    {Pid, Response} -> Response
  end.

procmsgs() ->
  receive
    {Sender, Data} -> Sender ! {self(), "got data " ++ Data},
      %statistics(runtime),
      %statistics(wall_clock),
      procmsgs()
  after 2000 -> io:format("~p~n", [{self(), "i nic?"}]),
    procmsgs()
  end.



