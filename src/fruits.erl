%%%-------------------------------------------------------------------
%%% @author adrian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Mar 2015 12:07 PM
%%%-------------------------------------------------------------------
-module(fruits).
-author("adrian").

%% API
%-export([myextfun/1]).

-compile(export_all).
-import(lists,[filter/2]).


fruit() -> [{apple, red}, {banana, yellow}, {cherry, red}, {pear, yellow}, {plum, purple}, {orange, orange}].


fruitByColor(Color) -> lists:filter(fun({_,C}) -> C == Color end, fruit()).

extractFruit() -> lists:map(fun({F,_}) -> F end, fruit()).

cikaka() ->
	io:format("pupu~p",[bibibi]).



