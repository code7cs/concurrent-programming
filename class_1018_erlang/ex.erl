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

nameOf(Id, TownR) ->
    case maps:find(Id, TownR) of
      {ok, R} -> R#inh.name;
      error -> error
    end.

nameOfChildren(Id, TownR) ->
    case maps:find(Id, TownR) of
      {ok, R} -> lists:map(fun(Id) -> nameOf(Id, TownR) end, R#inh.children);
      error -> error
    end.

descendantsOf(Id, Town) -> implement_me.

ancestorsOf(Id, Town) -> implement_me.
