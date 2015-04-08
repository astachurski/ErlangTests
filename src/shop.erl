%%%-------------------------------------------------------------------
%%% @author adrian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Mar 2015 10:00 PM
%%%-------------------------------------------------------------------
-module(shop).
-author("adrian").

%% API
-export([serve/1, startServer/1, stopServer/0]).

startServer(ClientPid) ->
  SelfPid = spawn(?MODULE, serve, [ClientPid]),
  register(shop, SelfPid).

stopServer() ->
  unregister(shop),
  {unregistered, ok}.



getTotalPrice(Basket) -> getTotalPriceImpl(Basket, 0).

getTotalPriceImpl([{_, Price} | T], Acc) -> getTotalPriceImpl(T, Price + Acc);
getTotalPriceImpl([], Acc) -> Acc.

serve(ClientPid) ->
  receive
    {gettotal, Basket} -> ClientPid ! {total, getTotalPrice(Basket)}
  end,
  serve(ClientPid).


