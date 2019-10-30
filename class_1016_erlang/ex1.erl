-module(ex1).

-compile(export_all).

%%% Class 1 -- Basic recursion on numbers and lists
% notes for this part are in the "class_1007_erlang" folder
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
mem(X, [H | T]) -> (X == H) or mem(X, T).

%% sublist(L1,L2)

%%% Class 2 - Records and recursive data structures

-record(person, {name, age}).

aPerson() ->
    #person{name = "Tom", age = 23}.
% > ex1:aPerson().
% {person,"Tom",23}

%%% recursive data structures

%%% {empty}   -- Empty tree
%%% {node,Data, LeftTree, RightTree}  -- Non empty tree

sizeT({empty}) -> 0;
sizeT({node, _D, LT, RT}) -> 1 + sizeT(LT) + sizeT(RT).
% > ex1:sizeT(ex1:aTree()).
% 4


sumT({empty}) -> 0;
sumT({node, D, LT, RT}) -> D + sumT(LT) + sumT(RT).
% > ex1:sumT(ex1:aTree()).
% 26

% is_valid({empty}) -> false;
% is_valid({node, _D, empty, empty}) -> true;
% is_valid({node, _D, LT, RT}) ->
%     is_valid(LT) or is_valid(RT).


% has_cycle({empty}) -> false;
% has_cycle({node, D, LT, RT}) ->
%     RN = element(2, RT),
%     case ((element(2, LT) == D) or (element(2, RT) == D)) of
%         true ->
%             true;
%         _false ->
%             has_cycle(LT) or has_cycle(RT)
%     end.

%%%% Copy from here onwards

mkLeaf(N) -> {node, N, {empty}, {empty}}.

aTree() ->
    {node, 7, mkLeaf(2), {node, 9, mkLeaf(8), {empty}}}.

    %         n,7
    %         /\
    %        /  \
    %     n,2   n,9
    %     /\     /\
    %    /  \   /  \   
    %   e   e  n,8  e
    %          /\
    %         /  \
    %        e    e


foldT(_F, A, {empty}) -> A;
foldT(F, A, {node, D, LT, RT}) ->
    F(D, foldT(F, A, LT), foldT(F, A, RT)).
% > ex1:foldT(fun(X, AL, AR) -> X + AL + AR end, 0, ex1:aTree()).
% 26
% 有五个empty，所以每个empty加上A（这里是1），就是加上5
% > ex1:foldT(fun(X, AL, AR) -> X + AL + AR end, 1, ex1:aTree()).
% 31
% > ex1:foldT(fun(X, AL, AR) -> X + AL + AR end, 2, ex1:aTree()).
% 36

% > ex1:foldT(fun (X, AL, AR) -> [X | AL ++ AR] end, [], ex1:aTree()).
% [7,2,9,8]
% > ex1:foldT(fun (X, AL, AR) -> [X | AL ++ AR] end, [5], ex1:aTree()).
% [7,2,5,5,9,8,5,5,5]
test() ->
    foldT(fun (X, AL, AR) -> [X | AL ++ AR] end, [], aTree()).
% > ex1:test().
% [7,2,9,8]


mirror(T) ->
    foldT(fun (D, ML, MR) -> {node, D, MR, ML} end, {empty},
	  T).
% > ex1:mirror(ex1:aTree()).
% {node,7,
% {node,9,{empty},{node,8,{empty},{empty}}},
% {node,2,{empty},{empty}}}


mapT(_F, {empty}) -> {empty};
mapT(F, {node, D, LT, RT}) ->
    {node, F(D), mapT(F, LT), mapT(F, RT)}.
% > ex1:mapT(fun(X) -> X + 1 end, ex1:aTree()).
% {node,8,
% {node,3,{empty},{empty}},
% {node,10,{node,9,{empty},{empty}},{empty}}}

mapT2(F, T) ->
    foldT(fun (X, ML, MR) -> {node, F(X), ML, MR} end,
	  {empty}, T).
% > ex1:mapT2(fun (X) -> X*X end, ex1:aTree()).
% {node,49,
%       {node,4,{empty},{empty}},
%       {node,81,{node,64,{empty},{empty}},{empty}}}
% > ex1:mapT2(fun (X) -> [X, X] end, ex1:aTree()).
% {node,[7,7],
%       {node,[2,2],{empty},{empty}},
%       {node,"\t\t",{node,"\b\b",{empty},{empty}},{empty}}}
%  数值 8、9、10 和 13 可以分别转换为退格符、制表符、换行符和回车符。
%  这些字符都没有图形表示，但是对于不同的应用程序，这些字符可能会影响文本的显示效果。


%%% review the slides - 07-erlang-1
arith(X, Y) ->
    io:format(" Arguments: ~p ~p~n", [X, Y]), % similar to printf
    Sum = X + Y,    % expressions separated by comma
    Diff = X - Y,
    Prod = X * Y,
    Quo = X div Y,
    io:fwrite(" ~p ~p ~p ~p~n", [Sum, Diff, Prod, Quo]),
    {Sum, Diff, Prod, Quo}. % Final expression is function’s return value
%     > ex1:arith(4, 6).
%     Arguments: 4 6
%     10 -2 24 0
%    {10,-2,24,0}
%    >