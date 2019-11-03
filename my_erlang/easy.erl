-module(easy).
-compile(export_all).



say_something(_, 0) ->
    io:format("Done ~n");
say_something(Value, Times) ->
    io:format("~s ~n", [Value]),
    say_something(Value, Times - 1).


start_concurrency(Value1, Value2) ->
    spawn(easy, say_something, [Value1, 3]),
    spawn(easy, say_something, [Value2, 3]).

% 1> c(easy).
% {ok,easy}
% 2> easy:say_something("Hello World", 3).
% Hello World 
% Hello World 
% Hello World 
% Done 
% ok
% 3> easy:start_concurrency("Hello World", "Really").
% Hello World 
% Really 
% Hello World 
% Really 
% <0.65.0>
% Hello World 
% Really 
% Done 
% Done 
% 4> easy:start_concurrency("Hello World", "Really").
% Hello World 
% Really 
% <0.68.0>
% Hello World 
% Really 
% Hello World 
% Really 
% Done 
% Done 
% 5> easy:start_concurrency("Hello World", "Really").
% Hello World 
% Really 
% <0.71.0>
% Hello World 
% Really 
% Hello World 
% Really 
% Done 
% Done 


fact(Int, Acc) when Int > 0 ->
    fact(Int - 1, Acc * Int);
fact(0, Acc) ->
    Acc.

factRecorder(Int, Acc, IoDevice) when Int > 0 ->
    io:format(IoDevice, "Current Factorial Log: ~p~n", [Acc]),
    factRecorder(Int - 1, Acc * Int, IoDevice);
factRecorder(0, Acc, IoDevice) ->
    io:format(IoDevice, "Factorial Results: ~p~n", [Acc]).