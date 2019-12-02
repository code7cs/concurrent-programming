-module(watcher).
-compile(export_all).
-author("Hanfan Wang").

startProcess(List, Processes) ->
    case length(List) == 0 of 
        true ->
            io:fwrite("Initial list of sensors: ~p~n", [Processes]),
            listen(Processes);
        false ->
            [H|T] = List,
            {PID, _} = spawn_monitor(sensor, runSensor, [H, self()]),
            startProcess(T, Processes ++ [{H, PID}])
        end.

listen(Processes) ->
    receive
        {ID, Measurement} ->
            io:fwrite("Reading from sensor [~p], measurement number: ~p~n", [ID, Measurement]),
            listen(Processes);
        {'DOWN', _, process, PID, {ID,Reason}} ->
            io:fwrite("Sensor [~p] died, reason: ~p~n",[ID, Reason]),
            NewProcess = lists:delete({ID, PID}, Processes),
            {NewPID, _} = spawn_monitor(sensor, runSensor, [ID, self()]),
            io:fwrite("Sensor [~p] restarted, new sensor list: ~w~n", [ID, NewProcess ++ [{ID, NewPID}]]),
            listen(NewProcess ++ [{ID, NewPID}])
    end.