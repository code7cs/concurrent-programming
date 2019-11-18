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

% ================================ 11.01.2019 class ====================================
% 1> c(echo).
% {ok,echo}
% 2> S = spawn(fun ex:echo/0).
% <0.63.0>
% 3> R1 = make_ref().
% #Ref<0.0.3.168>
% 4> S! {echo, self(), R1, 2}.
% {echo,<0.56.0>,#Ref<0.0.3.168>,2}
% 5> R2 = make_ref().
% #Ref<0.0.3.177>
% 6> S ! {echo, self(), R2, 2}.
% {echo,<0.56.0>,#Ref<0.0.3.177>,2}
% 7> flush().
% Shell got {<0.63.0>,#Ref<0.0.3.168>,2}
% Shell got {<0.63.0>,#Ref<0.0.3.177>,2}
% ok
% 8> 