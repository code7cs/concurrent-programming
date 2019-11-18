-module(ex).

-compile(export_all).

%%% Class 1 -- Basic recursion on numbers and lists

fact(0) -> 1;
fact(N)
    when N > 0 ->  %% when clause
    N * fact(N - 1).

len([]) -> 0;
len([_H | T]) ->   %%% pattern for non-empty list
    1 + len(T).

sum([]) -> 0;
sum([H | T]) -> H + sum(T).

map(_F, []) -> [];
map(F, [H | T]) -> [F(H) | map(F, T)].

foldl(_F, A, []) -> A;
foldl(F, A, [H | T]) -> F(H, foldl(F, A, T)).

foldr(_F, A, []) -> A;
foldr(F, A, [H | T]) -> foldr(F, F(A, H), T).

%% mem(X,L)

mem(_X, []) -> false;
mem(X, [H | T]) -> X == H or mem(X, T).

%% sublist(L1,L2)

%%% Class 2 - Records and recursive data structures

-record(person, {name  :: string(), age  :: number()}).

-type person() :: #person{}.

-spec aPerson() -> person().

aPerson() -> #person{name = "Tom", age = 23}.

%%% recursive data structures

%%% {empty}   -- Empty tree
%%% {node,Data, LeftTree, RightTree}  -- Non empty tree

-type btree() :: {empty} |
		 {node, any(), btree(), btree()}.

-spec sizeT(btree()) -> number().

sizeT({empty}) -> 0;
sizeT({node, _D, LT, RT}) -> 1 + sizeT(LT) + sizeT(RT).

-spec sumT(btree()) -> number().

sumT({empty}) -> 0;
sumT({node, D, LT, RT}) -> D + sumT(LT) + sumT(RT).

is_empty({empty}) -> true;
is_empty({node, _, _, _}) -> false.

-spec f(number()) -> number() | string().

f(0) -> 7;
f(_N) -> "hello".

%%%% Copy from here onwards

mkLeaf(N) -> {node, N, {empty}, {empty}}.

aTree() ->
    {node, 7, mkLeaf(2), {node, 9, mkLeaf(8), {empty}}}.

foldT(_F, A, {empty}) -> A;
foldT(F, A, {node, D, LT, RT}) ->
    F(D, foldT(F, A, LT), foldT(F, A, RT)).

test() ->
    foldT(fun (X, AL, AR) -> [X | AL ++ AR] end, [],
	  aTree()).

mirror(T) ->
    foldT(fun (D, ML, MR) -> {node, D, MR, ML} end, {empty},
	  T).

mapT(_F, {empty}) -> {empty};
mapT(F, {node, D, LT, RT}) ->
    {node, F(D), mapT(F, LT), mapT(F, RT)}.

mapT2(F, T) ->
    foldT(fun (X, ML, MR) -> {node, F(X), ML, MR} end,
	  {empty}, T).

%%%% Maps

-record(inh, {name, children}).
% 1> rl().
% ok
% 2> rr(ex).
% [inh,person]
% 3> rl().
% -record(inh,{name,children}).
% -record(person,{name :: string(),age :: number()}).
% ok
% 4> rd(inh).
% ** exception error: undefined shell command rd/1
% 5> rd(inh, {name, children}).
% inh


% 6> is_map(#{1 => a, 2 => b, 3 => c}).
% true
% 7> M = maps:new().
% #{}
% 8> maps:put(1, a, M).
% #{1 => a}
% 9> M1 = maps:put(1, a, M).
% #{1 => a}
% 10> maps:put(2, b, M1).
% #{1 => a,2 => b}
% 11> M2 = maps:put(2, b, M1).
% #{1 => a,2 => b}
% 12> maps:find(2, M2).
% {ok,b}
% 13> maps: find(7, M2).
% error
% 14> I  = maps:iterator(M2).
% ** exception error: undefined function maps:iterator/1
% 15> I = maps:iterator(M2).
% ** exception error: undefined function maps:iterator/1
% 16> I = maps:iterator(#{1 => a,2 => b}).
% ** exception error: undefined function maps:iterator/1
% 17>  Fun = fun(K,V1) when is_list(K) -> V1*2 end,
% 17>   Map = #{"k1" => 1, "k2" => 2, "k3" => 3},
% 17>   maps:map(Fun,Map).
% #{"k1" => 2,"k2" => 4,"k3" => 6}


townRegistry() ->
    M = maps:new(),
    M1 = maps:put(1, #inh{name = "Tom", children = [5, 6]},
		  M),
    M2 = maps:put(2, #inh{name = "Sue", children = [5]},
		  M1),
    M3 = maps:put(3, #inh{name = "Anne", children = [6]},
		  M2),
    M4 = maps:put(4, #inh{name = "John", children = []},
		  M3),
    M5 = maps:put(5, #inh{name = "Jill", children = [7]},
		  M4),
    maps:put(6, #inh{name = "John", children = [8]}, M5).
%   > ex:townRegistry().
% #{1 => #inh{name = "Tom",children = [5,6]},
%   2 => #inh{name = "Sue",children = [5]},
%   3 => #inh{name = "Anne",children = [6]},
%   4 => #inh{name = "John",children = []},
%   5 => #inh{name = "Jill",children = [7]},
%   6 => #inh{name = "John",children = "\b"}}

nameOf(Id, TownR) ->
    case maps:find(Id, TownR) of
      {ok, R} -> R#inh.name;
      error -> error
    end.
% > ex:nameOf(1, ex:townRegistry()).
% "Tom"

nameOfChildren(Id, TownR) ->
    case maps:find(Id, TownR) of
      {ok, R} -> lists:map(fun(Id) -> nameOf(Id, TownR) end, R#inh.children);
      error -> error
    end.
% 48> ex:nameOfChildren(1, ex:townRegistry()).
% ["Jill","John"]
% 49> ex:nameOfChildren(0, ex:townRegistry()).
% error
% 50> ex:nameOfChildren(2, ex:townRegistry()).
% ["Jill"]
% 51> ex:nameOfChildren(3, ex:townRegistry()).
% ["John"]
% 52> ex:nameOfChildren(4, ex:townRegistry()).
% []
% 53> ex:nameOfChildren(5, ex:townRegistry()).
% [error]
% 54> ex:nameOfChildren(6, ex:townRegistry()).
% [error]

descendantsOf(Id, Town) -> implement_me.

ancestorsOf(Id, Town) -> implement_me.
