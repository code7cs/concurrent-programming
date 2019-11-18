-module(conc1).

-export([add/2, main/1, start/0, stop/1]).

start() -> spawn(?MODULE, main, [0]).

main(T) ->
    receive
      {Pid, stop} -> 
          Pid ! stopped;
      {Pid, N} -> 
          Next = N + T,     % 一开始是0，后来是5，后来是22……
          Pid ! Next, 
          main(Next)        % 每把一个信息传给Pid，才会调用main()。第一次这里变为main(5)，然后就停住，回到第23行。
    end.

add(Pid, N) ->
    Self = self(),
    Pid ! {Self, N},        % 这里其实用到了main里的receive，判断是receive哪一种message。
                            % 因为创建线程Pid的时候，传的第二个参数是函数main，
                            % 所以现在把{Self，N}这条message传给Pid，就会调用main方法，
                            % 与main里的{Pid，N}匹配，所以执行{Pid，N}这个情况的语句
    receive
        Res -> Res          % 这里的Res，是main的{Pid，N}里 的Pid ！Next 的Next，
    end.

stop(Pid) ->
    Pid ! {self(), stop},   % 执行顺序： 27 -> 28 -> 7 -> 8 -> 9 -> 10 -> 29 -> 30 -> 31
    receive
        Res -> Res          % Res 就是第10行把stopped传给Pid，这里收到stopped
    end.
    % receive
    %    _ -> ok            % 如果是这样，那么还是收到stopped，只是最后打印出ok
    % end.


% 1> c(conc1).
% {ok,conc1}
% 2> Pid = conc1: start().
% <0.63.0>
% 3> conc1:add(Pid, 5).
% 5
% 4> conc1:add(Pid, 17).        % 执行顺序：第17行 -> 18 -> 19 -> 7 -> 8 -> 11 -> 12 -> 13 -> 14（14行其实不执行，就是放在那里，下次如果还有message传给Pid，再从这里执行） -> 23 -> 24 -> 25
% 22
% 5> conc1:stop(Pid).
% stopped  （ % ok ）
% 6> 