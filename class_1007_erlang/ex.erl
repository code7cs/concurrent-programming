-module(ex).

-compile(export_all).

fact(0) -> 1;
fact(N)
    when N > 0 ->  %% when clause
    N * fact(N - 1).

len([]) -> 0;
len([_H | T]) ->   %%% pattern for non-empty list
    1 + len(T).

% > ex:len([1 ,2, 3, 4, 5]).
% 5

sum([]) -> 0;
sum([H | T]) -> H + sum(T).

map(_F, []) -> [];
map(F, [H | T]) -> [F(H) | map(F, T)].

% > ex:map(fun(X) -> X + 1 end, [1, 2, 3, 4, 5]).
% [2,3,4,5,6]

foldl(_F, A, []) -> A;
foldl(F, A, [H | T]) -> F(H, foldl(F, A, T)).

% > ex:foldl(fun(X, Sum) -> X + Sum end, 1, [1,2,3,4,5]).
% 16

foldr(_F, A, []) -> A;
foldr(F, A, [H | T]) ->
    foldr(F, F(A, H),T).
% > ex:foldr(fun(X, Sum) -> X + Sum end, 10, [1,2,3,4,5]).
% 25
% > ex:foldr(fun(X, Prod) -> X * Prod end, 10, [1,2,3]).
% 60

% > P = fun(A, AccIn) -> io:format("~p ", [A]), AccIn end.
% #Fun<erl_eval.12.118419387>
% > lists:foldl(P, void, [1,2,3]).
% 1 2 3 void
% > lists:foldr(P, void, [1,2,3]).
% 3 2 1 void

%% mem(X,L)

mem(_X, []) -> false;
mem(X, [H | T]) -> (X == H) or mem(X, T).

%% sublist(L1,L2)
