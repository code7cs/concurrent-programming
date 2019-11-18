-module(tut).

-export([main/0]).

main() ->
    % do_math(5, 4).
    % compare(4, 4.0),
    list_stuff(),
    find_factorial(3),  % 6
    sum([1, 2, 3, 4]),  % 10
    for(3, 1).
% compare(A, B) -> A =:= B.

for(0, _) ->
    ok;
for(Max, Min) when Max > 0 ->
    io:fwrite("Num: ~p \n", [Max]),
    for(Max - 1, Min).


sum([]) -> 0;
sum([H|T]) ->
    H + sum(T).


list_stuff() ->
    List1 = [1, 2, 3],
    List2 = [2*N || N <- List1],
    List2,  % [2, 4, 6]
    List3 = [1, 2, 3, 4],
    List4 = [N || N <- List3, N rem 2 == 0],
    List4,  % [2, 4]

    is_tuple({height, 6.24}).


factorial(N) when N == 0 -> 1;
factorial(N) when N > 0 -> N * factorial(N - 1).

find_factorial(X) ->
    Y = factorial(X),
    io:fwrite("Factorial: ~p \n", [Y]).




    % List1 = [1, 2, 3],
    % List2 = [4, 5, 6],
    % List3 = List1 ++ List2,
    % List3,
    % List4 = List3 -- List1,
    % List4,
    % hd(List4),
    % tl(List4),
    % List5 = [3 | List4],
    % List5,
    % [Head | Tail] = List5,
    % Head,
    % Tail.

    % do_math(A, B) ->

    % A + B,
    % A / B,
    % A div B,
    % A rem B,
    % math:exp(1).
    % math:log10(1000).
    % math:pow(10, 2).
    % math:sqrt(100),
    % rand:uniform(10).

