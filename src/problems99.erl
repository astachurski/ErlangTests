%%%-------------------------------------------------------------------
%%% @author adrian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Mar 2015 8:54 PM
%%%-------------------------------------------------------------------
-module(problems99).
-author("adrian").

-include_lib("eunit/include/eunit.hrl").

-export([last/2, penultimate/1, nth/2, length/2, reverse/2, isPalindrome1/1, flattenAux/2, flatten/1]).

last([], Acc) -> Acc;
last([H|[]], _) -> H;
last([_|T], _) -> last(T, 0).

problem01_test() ->
  L = [1, 1, 2, 3, 5, 8],
  ?assertEqual(last(L,0),8),
  ?assertEqual(last([1,1,2,3,5,8,9,3,0],0),0).

%penultimate([], Acc) -> Acc;
penultimate([X,_|[]] ) -> X;
penultimate([_|T]) -> penultimate(T).

problem02_test() ->
  R = penultimate([1,1,2,3,5,8,9,3,9]),
  io:format("result: ~p",[R]),
  ?assertEqual(R, 3).


nth(0, [H|_]) -> H;
nth(X, [_|T]) -> nth(X-1,T).

problem03_test() ->
  R = nth(3, [1,1,2,3,5,8,9,3,9]),
  ?assertEqual(R,3),
  R2 = nth(5, [1,1,2,3,5,8,9,3,9]),
  ?assertEqual(R2,8).


length([], Acc) -> Acc;
length([_|T], Acc) -> length(T, Acc+1).

problem04_test() ->
  R = length([1,1,2,3,5,8,9,3,9]),
  ?assertEqual(R,9).


reverse([],Acc) -> Acc;
reverse([H|T], Acc) -> (reverse(T, [H|Acc])).


problem05_test() ->
  R = reverse([5,8,9,3,9],[]),
  ?debugVal(R),
  ?assertEqual(R, [9,3,9,8,5]).


isPalindrome1(L) ->
  lists:reverse(L) =:= L.

problem06_test() ->
  ?assertEqual(isPalindrome1([1, 2, 3, 2, 1]),true).


flatten(L) -> flattenAux(L,[]).
%the most complex case - head is a list, tail is a list
flattenAux([X|T],Acc) when is_list(X) -> flattenAux(X, flattenAux(T, Acc));
%otherwise
flattenAux([X|T],Acc) -> flattenAux(T, [X|Acc]);
%base case
flattenAux([],Acc) -> Acc.


problem07_test() ->
  R = flatten([[1,2],3,[4,[5,6]]]),
  ?debugVal(R),
  ?assertEqual(R, [2,1,6,5,4,3]).

problem08_test() ->
  8.