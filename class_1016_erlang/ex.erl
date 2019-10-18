-module(ex).

-compile(export_all).

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

mapT(_F, {empty}) ->
    {empty};
mapT(F, {node,D,LT,RT}) ->
    {node, F(D), mapT(F, LT), mapT(F, RT)}.

mapT2(F,T) ->
    foldT( fun(X,ML,MR) -> {node, F(X), ML, MR} end, {empty}, T).


    % > [H1|[H2|T]]=[1, 2, 3].
    % [1,2,3]
    % > H1.
    % 1
    % > T.
    % [3]
    % > rd(student, {name, age}).
    % student
    % > rl().
    % -record(student,{name,age}).
    % ok
    % > P = #student{name="Tom",age=22}.
    % #student{name = "Tom",age = 22}
    % > P.
    % #student{name = "Tom",age = 22}
    % > P#student.name.
    % "Tom"
    % > F = fun(#student{name=N}) -> N end.
    % #Fun<erl_eval.6.118419387>
    % > F(P).
    % "Tom"
    % > q().
    % ok


    % {ok,ex}
    % > ex:mirror(ex:aTree()).
    % {node,7,
    %       {node,9,{empty},{node,8,{empty},{empty}}},
    %       {node,2,{empty},{empty}}}
    % > c(ex).
    % {ok,ex}
    % > ex:mapT2(fun (X) -> X*X end, ex:aTree()).
    % {node,49,
    %       {node,4,{empty},{empty}},
    %       {node,81,{node,64,{empty},{empty}},{empty}}}
    % > ex:mapT2(fun (X) -> [X, X] end, ex:aTree()).
    % {node,[7,7],
    %       {node,[2,2],{empty},{empty}},
    %       {node,"\t\t",{node,"\b\b",{empty},{empty}},{empty}}}


-spec f(number()) -> number().
% -spec f(number()) -> list().

f(0) ->
    7;
f(N) ->
    N + f(N -1).


% 1> c(ex).
% {ok,ex}
% 2> ex:mirror(ex:aTree()).
% {node,7,
%       {node,9,{empty},{node,8,{empty},{empty}}},
%       {node,2,{empty},{empty}}}
% 3> #{1 => a, 2 => b}.
% #{1 => a,2 => b}
% 4> is_map(#{1 => a, 2 => b}).
% true

-record(inh, {name, children}).

theRegistry() ->
    M = maps:new(),
    M1 = maps:put(1, #inh{name="Tom", children=[5, 6]}, M),
    M2 = maps:put(2, #inh{name="Sue", children=[5]}, M1),
    M3 = maps:put(3, #inh{name="Anne", children=[6]}, M2),
    M4 = maps:put(4, #inh{name="Jill", children=[]}, M3),
    M5 = maps:put(5, #inh{name="Robert", children=[]}, M4),
    maps:put(6, #inh{name="Susan", children=[]}, M5).

nameOf(Id, TownR) ->
    impelment.
nameOfChildrenOf(Id, TownR) ->
    impelment.

descendantsOf(Id, TownR) ->
    impelment.

ancestorsOf(Id, TownR) ->
    impelment.