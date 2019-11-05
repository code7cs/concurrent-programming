-module(echo3).

-export([start/0]).

echo() ->
    receive
        {From, Ref, Msg} ->
            timer:sleep(rand:uniform(100)), 
            From ! {self(), Ref, Msg},
            echo();
        stop -> true
    end.

start() ->
    PidB = spawn(fun echo/0),
    % sending tokens
    Token = 42,
    Ref = make_ref(),
    PidB ! {self(), Ref, Token},
    io:format("Sent ~w~n", [Token]),
    Token2 = 41,
    Ref2 = make_ref(),
    PidB ! {self(), Ref2, [Token2]},
    % receive message
    receive
        {PidB, Ref2, Msg} ->
            io:format("Received 41? ~w~n", [Msg]);
        {PidB, Ref, Msg} ->
            io:format("Received 42? ~w~n", [Msg])
    end,

    % stop echo-servers
    PidB ! stop.