%%%-------------------------------------------------------------------
%%% @author adrian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Mar 2015 2:56 PM
%%%-------------------------------------------------------------------
-module(tcpserver).
-compile(export_all).
-author("adrian").
-import(lists, [reverse/1]).
-export([start_server/0]).


start_server() ->
  PortNo = 666,
  Options = [
    binary,
    {packet, 0},
    {reuseaddr, true},
    {active, true}],

  case gen_tcp:listen(PortNo, Options) of
    {ok, ListenSocket} ->
      io:format("server listening!\n"),
      listen_loop(ListenSocket)
  end.


listen_loop(ListenSocket) ->
  case gen_tcp:accept(ListenSocket) of
    {ok, AcceptSocket} ->
      receive_func(AcceptSocket),
      listen_loop(ListenSocket)
  end.


receive_func(Socket) ->
  receive
    {tcp, Socket, Bin} ->
      io:format("received binary = ~p~n", [Bin]),
      Str = binary_to_list(Bin),
      io:format("unpacked to list  ~p~n", [Str]),
      Reply = "Ok, got your message\n",
      io:format("Server replying = ~p~n", [Reply]),
      gen_tcp:send(Socket, list_to_binary(Reply));
    {tcp_closed, Socket} ->
      io:format("socket closed\n")
  end.