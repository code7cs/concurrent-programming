-module(basic).

-compile(export_all).

mult(X, Y) -> X * Y.

double(X) -> X * 2.

distance({X1, Y1}, {X2, Y2}) ->
    math:sqrt((X1 - X2) * (X1 - X2) +
		(Y1 - Y2) * (Y1 - Y2)).

is_greater_than ( X , Y ) ->
    if
        X > Y ->
            true;
        true ->  % works as an ’else ’ branch
            false
    end.

fibonacci(0) -> 0;
fibonacci(1) -> 1;
fibonacci(X) ->
    fibonacci(X - 1) + fibonacci(X - 2).


fibonacciTR(N) -> fibonacciTR(N, 0, 0, 0).      % fibonacciTR(5) -> fibonacciTR(5, 0, 0, 0) 
fibonacciTR(N, N, _, F) -> F;                                                                                  % fTR(5, 5, _, 5) -> 5.
fibonacciTR(N, 0, _, _) -> fibonacciTR(N, 1, 0, 1);    % fibonacciTR(5, 1, 0, 1)
fibonacciTR(N, 1, _, _) -> fibonacciTR(N, 2, 1, 1);                     % fibonacciTR(5, 2, 1, 1)
fibonacciTR(N, Current, X, Y) -> fibonacciTR(N, Current+1, Y, Y + X).               % fTR(5, 3 ,1, 1+1) -> fTR(5, 4, 2, 2 + 1) -> fTR(5, 5, 3, 3 + 2)

zip1([], []) ->
    [];
zip1([H1|T1], [H2|T2]) ->
    [{H1, H2}]++zip1(T1, T2).

zip(A, B) ->
    zip(A, B, []).
zip(_, [], Result) ->
    Result;
zip([], _, Result) ->
    Result;
zip([A|ARest], [B|BRest], Result) ->
    zip(ARest, BRest, [{A, B}|Result]).

has_cycle()