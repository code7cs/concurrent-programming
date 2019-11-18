-module(echo2).
-export([start/0]).

% Sources of Multiple Messages

echo() ->
    receive
      {From, Msg} ->
            timer:sleep(rand:uniform(100)), 
            % From ! { Msg}, 
            From ! {self(), Msg}, 
            echo();
      stop -> true
    end.

start ( ) -> 
    PidB = spawn ( fun echo / 0 ) , 
    PidC = spawn ( fun echo / 0 ) , 
    % sending tokens 
    Token = 42, 
    PidB ! {self(), Token}, 
    io:format(" Sent~w~n" ,[Token]), 
    Token2 = 41, 
    PidC ! {self(), Token2}, 
    io:format(" Sent~w~n" ,[Token2]),

    % receive message
    receive 
        % {Msg} ->
        %     io : format ( " Received ~w~n" , [ Msg ] )
        {PidB ,Msg} -> 
            io:format(" Received from B: ~w~n" , [Msg]) ;
        {PidC , Msg} -> 
            io:format(" Received from C: ~w~n" , [Msg])
    end,

    % stop echo-servers
    PidB ! stop,
    PidC ! stop.

% 1> c(echo2).
% {ok,echo2}
% 2> echo2:start().
%  Sent42
%  Sent41
%  Received from C: 41
% stop
% 3> echo2:start().
%  Sent42
%  Sent41
%  Received from B: 42
% stop
% 4> echo2:start().
%  Sent42
%  Sent41
%  Received from C: 41
% stop
% 5> echo2:start().
%  Sent42
%  Sent41
%  Received from C: 41
% stop
% 6> echo2:start().
%  Sent42
%  Sent41
%  Received from B: 42
% stop
% 7> echo2:start().
%  Sent42
%  Sent41
%  Received from B: 42
% stop




