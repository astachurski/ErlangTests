%%%-------------------------------------------------------------------
%%% @author adrian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Mar 2015 11:42 AM
%%%-------------------------------------------------------------------
-module(epl).
-author("adrian").
-include_lib("eunit/include/eunit.hrl").

%% API
-export([sum/1, sumAlternative/1, sumNtoM/2, sumNtoMalternative/2, create/1, createAlternative/1, reverseCreate/1, reverseCreateImpl/1, printNints/1, print_test/0, printEvenRange/1, printEven/1,
  b_not/1, b_and/2, b_or/2, b_nand/2, filter/2, reverse/1, concatenate/1, flatten/1, concatenateImpl/2, quicksort/1, mergesort/1]).


% ========= exercises prior to 2-3 are shell related.============


% ========================== exercise 2-3 =======================
% ========================== Simple pattern matching ============


b_not(true) ->
  false;
b_not(false) ->
  true.

b_and(false, true) ->
  false;
b_and(true, false) ->
  false;
b_and(false, false) ->
  false;
b_and(true, true) ->
  true.

b_or(false, true) ->
  true;
b_or(true, false) ->
  true;
b_or(false, false) ->
  false;
b_or(true, true) ->
  true.

b_nand(Arg1, Arg2) ->
  b_not(b_and(Arg1, Arg2)).


% ========================== exercise 3-1 =======================
% ========================== Evaluating expressions =============


%complex and dirty but tail recursive
sum(Int) -> sumImpl(Int, 0).
sumImpl(0, Acc) -> Acc;
sumImpl(Int, Acc) -> sumImpl(Int - 1, Acc + Int).

sum_test() ->
  %?debugVal(sum(5)),
  ?assertEqual(sum(5), 15).

%exercise 3-1 (1)
%constant time version. Also fold left would do the job.
sumAlternative(Int) -> round(0.5 * Int * (Int + 1)).

%exercise 3-1 (2)
sumAlt_test() ->
  %?debugVal(sumAlternative(5)),
  ?assertEqual(sumAlternative(5), 15).


%exercise 3-1, range sum.
sumNtoM(N, M) -> sumNtoMimpl(N, M, 0).
sumNtoMimpl(N, M, Acc) when N < M -> sumNtoMimpl(N + 1, M, Acc + N);
sumNtoMimpl(N, M, Acc) when N == M -> Acc + M;
%terminate process abnormally
sumNtoMimpl(N, M, _Acc) when N > M -> error("wrongArgs!").

sumNtoM_test() ->
  ?assertEqual(sumNtoM(1, 3), 6),
  ?assertEqual(sumNtoM(6, 6), 6).

%functional way to calculate sum from range:
sumNtoMalternative(N, M) ->
  L = lists:seq(N, M),
  lists:foldl(fun(X, Acc) -> X + Acc end, 0, L).

sumNtoMalternative_test() ->
  ?assertEqual(sumNtoMalternative(1, 3), 6),
  ?assertEqual(sumNtoMalternative(6, 6), 6),
  ?assertEqual(sumNtoMalternative(99, 100), 199).

% ========================== exercise 3-2 =======================
% ========================== Creating lists======================


%trivial solution
create(Int) -> lists:seq(1, Int).

%tail recursive. lists:seq implementation is more complex
%because of speed optimization. But it is similar to one below.
createAlternative(Int) -> createImpl(Int, []).
createImpl(0, Acc) -> Acc;
createImpl(Int, Acc) -> createImpl(Int - 1, [Int | Acc]).

create_test() ->
  ?assertEqual(create(3), [1, 2, 3]).

createAlternative_test() ->
  ?assertEqual(createAlternative(5), [1, 2, 3, 4, 5]).


%trivial solution could be lists:reverse.
%this is worse, non-tail-recursive.
reverseCreate(Int) -> reverseCreateImpl(Int).
reverseCreateImpl(0) -> [];
reverseCreateImpl(Int) -> [Int | reverseCreateImpl(Int - 1)].


reverseCreate_test() ->
  %?debugVal(reverseCreate(5)).
  ?assertEqual(reverseCreate(5), [5, 4, 3, 2, 1]).

% ========================== exercise 3-3 =======================
% ========================== Side effects========================


%code duplication but tail-recursive.
%this could be done better with foreach and lists:seq first.
%but (tail)recursion is cool! :-)
printNints(N) -> printNintsImpl(N, 1).

printNintsImpl(N, Curr) when N == Curr -> io:format("Number: ~p~n", [Curr]);
printNintsImpl(N, Curr) ->
  io:format("Number: ~p~n", [Curr]),
  printNintsImpl(N, Curr + 1).

print_test() ->
  printNints(10).


%foreach wants a lambda. So I give it a redirection to printEven where
%resolution with guard is done.
printEven(X) when (X rem 2 == 0) -> io:format("~p~n", [X]);
printEven(X) -> X. %just don't print

printEvenRange(N) ->
  L = lists:seq(1, N),
  lists:foreach(fun(X) -> printEven(X) end,
    L).


% ========================== exercise 3-4 =======================
% ========================== Database handling usind lists=======

%implemented in module db.erl


% ========================== exercise 3-5 =======================
% ========================== Manipulating lists==================

filter(List, Number) -> lists:filter(fun(X) -> X =< Number end, List).

filter_test() ->
  %?debugVal(filter([1, 2, 3, 4, 5], 3)),
  ?assertEqual(filter([1, 2, 3, 4, 5], 3), [1, 2, 3]).

reverse(List) -> reverseImpl(List, []).

reverseImpl([], Acc) -> Acc;
reverseImpl([H | T], Acc) -> (reverseImpl(T, [H | Acc])).

reverse_test() ->
  ?assertEqual(reverse([1, 2, 3, 4, 5]), [5, 4, 3, 2, 1]).


concatenate(ListOfLists) -> concatenateImpl(ListOfLists, []).

concatenateImpl([H | T], Acc) when is_list(H) -> concatenateImpl(T, concatInternal(H, Acc));
concatenateImpl([_ | T], Acc) -> concatenateImpl(T, Acc);
concatenateImpl([], Acc) -> Acc.

%it is better to reverse after tail-recursion than assemble in non-tail recursion.
%risking stack overflow when sublist is huge.
concatInternal([H | T], Acc) -> concatInternal(T, [H | Acc]);
concatInternal([], Acc) -> lists:reverse(Acc).


concatenate_test() ->
  L = [[1, 2, 3], [], [4, five]],
  %?debugVal(concatenate(L)).
  ?assertEqual(concatenate(L), [1, 2, 3, 4, five]).

%I didnt reuse concatenate.
flatten(L) -> flattenAux(L, []).
%the complex case - head is a list, tail is a list
flattenAux([X | T], Acc) when is_list(X) -> flattenAux(X, flattenAux(T, Acc));
flattenAux([X | T], Acc) -> flattenAux(T, [X | Acc]);
flattenAux([], Acc) -> Acc.


flatten_test() ->
  L = [[1, [2, [3], []]], [[[4]]], [5, 6]],
  R = flatten(L).
%?debugVal(R).

% ========================== exercise 3-6 =======================
% ========================== Sorting lists==================



quicksort([H | T]) ->
  quicksort(lists:filter(fun(X) -> X < H end, T)) ++ [H] ++ quicksort(lists:filter(fun(X) -> X > H end, T));
quicksort([]) -> [].

%Using list comprehensions it is even shorter
%qsort([]) -> [];
%qsort([X|Xs]) ->
%  qsort([Y||Y<-Xs,Y=<X]) ++ [X] ++ qsort([Y||Y<-Xs,Y > X]).


quicksort_test() ->
  R = quicksort([8, 3, 55, 1, 9, 7, 3, 5, 2, 8, 0]),
  ?assertEqual(R, [0, 1, 2, 3, 5, 7, 8, 9, 55]).
%?debugVal(R).

%TODO: find how to EFFICIENTLY split list into two. (is length() expensive?)
mergesort([H | T]) -> []
%lists:split(  [H|T], )
.

mergesort_test() ->
  R = mergesort([8, 3, 55, 1, 9, 7, 3, 5, 2, 8, 0]).
  %?assertEqual( [0, 1, 2, 3, 5, 7, 8, 9, 55]).

%==========================================================================================
%== Other tests and exercises including tasks from Joe Armstrong's =Programming Erlang book==
%==========================================================================================

%drop Odd numbers, leaving even - classic recursion
dropOdd([]) -> [];
dropOdd([H | T]) when H rem 2 == 0 -> [H | dropOdd(T)];
dropOdd([_ | T]) -> dropOdd(T).


%the same as above but tail recursive
dropOddR([], X) -> X;
dropOddR([H | T], X) when H rem 2 == 0 -> dropOddR(T, [H | X]);
dropOddR([_ | T], X) -> dropOddR(T, X).

%find if element is in the list.
elem(_, []) -> false;
elem(E, [E | _]) -> true;
elem(E, [_ | T]) -> elem(E, T).


%split list of numbers into even and odd numbers.
%in the solution Joe Armstrong suggests use of case on head of list (case H rem 2 of...)
%but my solution is equivalent.
splitIntoEvenOdd(List) -> splitIntoEvenOddImpl(List, [], []).
splitIntoEvenOddImpl([H | T], AccEven, AccOdd) when H rem 2 =:= 0 -> splitIntoEvenOddImpl(T, [H | AccEven], AccOdd);
splitIntoEvenOddImpl([H | T], AccEven, AccOdd) -> splitIntoEvenOddImpl(T, AccEven, [H | AccOdd]);
splitIntoEvenOddImpl([], AccEven, AccOdd) -> {lists:reverse(AccEven), lists:reverse(AccOdd)}.

splitIntoEvenOdd_test() ->

  L = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  R = splitIntoEvenOdd(L),
  ?assertEqual(R, {[2,4,6,8,10],[1,3,5,7,9]}).
