-module(main).
-compile(export_all).
-author("Hanfan Wang").

setup_loop(N, _Num_watchers) -> createWatcher(N, 0, []).

createWatcher(N, ID, List) when length(List) == 10 ->
    spawn(watcher, startProcess, [List, []]),
    createWatcher(N, ID, []);
createWatcher(N, ID, List) ->
    case N of
      0 -> spawn(watcher, startProcess, [List, []]);
      _ -> createWatcher(N - 1, ID + 1, List ++ [ID])
    end.

start() ->
    {ok, [N]} = io:fread("enter number of sensors > ", "~d"),
    if N =< 1 ->
	   io:fwrite("setup: range must be at least 2~n", []);
       true ->
	   Num_watchers = 1 + N div 10, setup_loop(N, Num_watchers)
    end.
