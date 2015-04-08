%%%-------------------------------------------------------------------
%%% @author adrian
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Mar 2015 4:54 PM
%%%-------------------------------------------------------------------
-module(db).
-author("adrian").

%% API
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2, readImpl/2, deleteImpl/3, populateDb/0, matchImpl/3]).

% ========================== exercise 3-4 =======================
% ========================== Database handling usind lists=======

new() -> [].

destroy(_Db) -> ok.

%no check for duplicates!
write(Key, Element, Db) -> [{Key, Element} | Db].

%remove all instances including duplicates
delete(Key, Db) -> deleteImpl(Key, Db, []).

deleteImpl(Key, [{Key, _} | T], Acc) -> deleteImpl(Key, T, Acc);
deleteImpl(_, [], Acc) -> Acc;
deleteImpl(Key, [H | T], Acc) -> deleteImpl(Key, T, [H | Acc]).


read(Key, Db) ->
  case readImpl(Key, Db) of
    {ok, {_, Value}} -> {ok, Value};
    _ -> {error, instance}
  end.

readImpl(Key, [{Key, Value} | _]) -> {ok, {Key, Value}};
readImpl(Key, [{Key, Value}]) -> {ok, {Key, Value}};
readImpl(Key, [_ | T]) -> readImpl(Key, T);
readImpl(_, []) -> noelem.

match(Element, Db) -> matchImpl(Element, Db, []).

matchImpl(Elem, [{Key,Elem}|T], Acc) -> matchImpl(Elem, T, [Key|Acc]);
matchImpl(Elem, [{_,_}|T], Acc) -> matchImpl(Elem, T, Acc);
matchImpl(_, [], Acc) -> Acc.


populateDb() ->
  Db = new(),
  El1 = "first element",
  El2 = [1, 2, 3, 4, 5],
  El3 = {"part1", "part2"},
  El4 = someAtom,
  El5 = {1, 2, 3, 4},
  DbTemp1 = write(e, El5, write(d, El4, write(c, El3, write(b, El2, write(a, El1, Db))))),
  %write duplicate
  write(d, El4, DbTemp1).