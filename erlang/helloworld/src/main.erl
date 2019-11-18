-module(main).
-author("fanoh").

%% API
-export([print_helloworld/0]).

print_helloworld() ->
  io:format("Hello World ~n").