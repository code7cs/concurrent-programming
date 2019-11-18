-module(ch).
-compile(export_all).

chain(S, 0) ->
    S!self(),
    receive
        ok ->
            exit(oops)
    end;
chain(S, N) when N > 0 ->
    spawn_link(?MODULE, chain,[S, N -1]),
    receive
        ok ->
           exit(oopsie) 
    end.

start() ->
    spawn_link(?MODULE, chain, [self(), 5]).

% 1> c(ch).
% {ok,ch}
% 2> ch:start().
% <0.63.0>
% 3> c(ch).     
% {ok,ch}
% 4> f(X).      
% ok
% 5> process_flag(trap_exit, true).
% false
% 11> receive X -> X end.
% 9> self().
% > i().
% 21> flush().
% 22> receive X -> X after 1000 -> ok end.
% ok