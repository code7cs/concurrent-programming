%% Sample module
-module(hello).

-export([hello/0, add/2, add/3]).

hello() -> 
    io:fwrite(" Hello , world!\n").

add(A, B) -> 
    hello(),
    A + B.

add(A, B, C) -> 
    hello(),
    A + B + C.

% 1> c(hello).
% {ok,hello}
% 2> hello:add(1, 2).
%  Hello , world!
% 3
% 3> hello:add(3, 4, 5).
%  Hello , world!
% 12