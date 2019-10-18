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