-module(echo3).

-export([start/0]).

echo() ->
    receive
        {From, Ref, Msg} ->
            timer:sleep(rand:uniform(1000)), 
            From ! {self(), Ref, Msg},
            echo();
        stop -> true
    end.

start() ->
    PidB = spawn(fun echo/0),

    % sending tokens
    Token2 = 41,
    Ref2 = make_ref(),
    PidB ! {self(), Ref2, Token2},
    io:format("Ref2: ~w, Sent ~w~n", [Ref2, Token2]),

    Token = 42,
    Ref = make_ref(),
    PidB ! {self(), Ref, Token},
    io:format("Ref: ~w, Sent ~w~n", [Ref, Token]),
    % receive message
    receive
        {PidB, Ref2, Msg} ->
            io:format("Received 41? ~w~n", [Msg]);
        {PidB, Ref, Msg} ->
            io:format("Received 42? ~w~n", [Msg])
    end,

    % stop echo-servers
    PidB ! stop.

% 结果是固定的, 因为, msg从同一个process传来的, 可以保证mailbox的存储顺序!!!

% 在ehco2中, 顺序就不一定了, 因为是从不同process传来的.