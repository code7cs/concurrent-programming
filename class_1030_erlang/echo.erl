% a simple echo server
-module(echo).
-compile(export_all).
-export([start/0]).

echo() ->
    receive
      {From, Msg} -> 
          From ! {Msg}, 
          echo();
      stop -> true
    end.

% Processes are created using spawn/1 and spawn/3
start() ->
    Pid = spawn(fun echo/0), % Returns pid of a new process
    % started by the application of echo /0 to []
    Token = " Hello Server!", % Sending tokens to the server
    Pid ! {self(), Token},      % 这里是第8行的情况
    io:format(" Sent ~s~n", [Token]),
    receive 
        {Msg} ->
        io:format(" Received ~s~n", [Msg])
    end,
    Pid ! stop. % Stop server   % 这里是第11行的情况

% 2> c(echo).
% {ok,echo}
% 3> echo:start().
%  Sent  Hello Server!
%  Received  Hello Server!
% stop

% 6> c(echo).
% {ok,echo}
% 7> X = spawn(fun echo:echo/0).
% <0.75.0>
% 8> X!{self(), "hello"}.
% {<0.58.0>,"hello"}        % <0.58.0>是传信息给X的process，即 <0.58.0>把“hello”传给<0.75.0>
% 9> X.
% <0.75.0>
% 10> 