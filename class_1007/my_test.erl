-module(my_test).

-export([factorial/1]).

factorial(0) -> 1;
factorial(N) -> N * factorial(N - 1).

% erl
% c(my_test).
% my_test:factorial(3).

