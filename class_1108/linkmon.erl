-module(linkmon).
-compile(export_all).

myproc() ->
    timer:sleep(2000),
    exit(reason).

% 1> c(linkmon).
% {ok,linkmon}
% 2> self().
% <0.56.0>
% 3> spawn(fun linkmon:myproc/0).           % 生成一个新proc，pid为<0.64.0>
% <0.64.0>
% 4> self().                                % self() 没有变，还是<0.56.0>
% <0.56.0>
% 5> link(spawn(fun linkmon:myproc/0)).     % 把self和后面这个生成的proc，link起来
% true
% ** exception error: reason
% 6> self().                                % 因为出现了exceptin error, proc退出了, 导致self也退出, 所以self变了 ===> 为<0.69.0>
% <0.69.0>
% 7> 

chain(0) ->
    receive
        _ -> ok
after 2000 ->
    exit("chain dies here")
end;

chain(N) ->
    Pid = spawn(fun() -> chain(N - 1) end),
    link(Pid),
    receive
        _ -> ok
end.
% 在linkmon:chain(0) ❌ 时, 这个错误会一直传递下去直到 self proc 也 die 了
% 因为links时双向的,所以只要一个die了, 其他也会照做
% 过程示意如下: 
% [shell] == [3] == [2] == [1] == [0]   % shell先和3连,然后3和2连, ... 
% [shell] == [3] == [2] == [1] == *dead*    % chain(0) die了, 然后1也die, 2 ...
% [shell] == [3] == [2] == *dead*
% [shell] == [3] == *dead* 
% [shell] == *dead* 
% *dead , error message shown* 
% [shell] <-- restarted

% 7> c(linkmon).
% {ok,linkmon}
% 8> self().
% <0.69.0>
% 9> link(spawn(linkmon, chain, [3])).
% true
% ** exception error: "chain dies here"
% 10> self().                                   % restarted       
% <0.82.0>
% 11> 


% 11> c(linkmon).
% {ok,linkmon}
% 12> self().
% <0.82.0>
% 13> process_flag(trap_exit, true).
% false
% 14> spawn_link(fun()-> linkmon:chain(3) end).
% <0.91.0>
% 15> receive X -> X end.
% {'EXIT',<0.91.0>,"chain dies here"}