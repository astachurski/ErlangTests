%%%-------------------------------------------------------------------
%%% @author adrian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Mar 2015 11:40 AM
%%%-------------------------------------------------------------------
-module(tcpclient).
-author("adrian").

-export([connectToHost/1]).
-import(lists, [reverse/1]).


connectToHost(HostIp) ->
  PortNo = 666,
  Options = [binary, {packet, 0}],

  {ok, TcpSocket} = gen_tcp:connect(
    HostIp,
    PortNo,
    Options),

  CurrTimeB = erlang:time(),

  io:format("sending time: ~p~n", [CurrTimeB]),

  DataToSend = list_to_binary(tuple_to_list(CurrTimeB)),

  case gen_tcp:send(TcpSocket, DataToSend) of
    ok -> io:format("success, data sent"),
      receive_data(TcpSocket, [])
  end.



receive_data(Socket, Received) ->
  receive
    {tcp, Socket, Bin} -> receive_data(Socket, [Bin | Received]);
    {tcp_closed, Socket} ->
      Recvd = list_to_binary(reverse(Received)),
      io:format("got from server: ~p~n", [binary_to_list(Recvd)])
  end.