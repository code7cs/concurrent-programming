-module(ex).

-compile(export_all).

fact(0) -> 1;
fact(N)
    when N > 0 -> %% when clause
    N * fact(N - 1).

len([]) -> 0;
len([_H | T]) -> 1 + len(T).

%% mem(X, L)

mem(X, []) -> false;
mem(H, [H | T]) -> true;
mem(X, [H | T]) -> mem(X, T).

%% sublist(L1, L2)

