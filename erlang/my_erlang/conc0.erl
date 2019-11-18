-module(conc0).

-export([main/1, start/0]).

start() -> spawn(?MODULE, main, [0]).

main(T) ->
    receive
      {Pid, stop} -> 
          Pid ! stopped;
      {Pid, N} -> 
          Next = N + T, 
          Pid ! Next, 
          main(Next)
    end.

% 10> c(conc0).
% {ok,conc0}
% 11> Pid = conc0:start().
% <0.85.0>
% 12> Self = self().
% <0.56.0>
% 13> Pid ! {Self, 5}.
% {<0.56.0>,5}
% 14> receive Res1 -> Res1 end.
% 5
% 15> Pid ! {Self, 17}.
% {<0.56.0>,17}
% 16> receive Res2 -> Res2 end.
% 22
% 17> Pid ! {Self, stop}.
% {<0.56.0>,stop}
% 18> receive Res3 -> Res3 end.
% stopped
% 19> 