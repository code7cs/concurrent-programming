-module(sensor).
-compile(export_all).
-author("Hanfan Wang").

runSensor(ID, WatcherPID) ->
    Sleep_time = rand:uniform(10000),
    timer:sleep(Sleep_time),
    Measurement = rand:uniform(11),
    case Measurement < 11 of
        true ->
            WatcherPID ! {ID, Measurement},
            runSensor(ID, WatcherPID);
        _ ->
            exit({ID, anomalous_reading})
    end.