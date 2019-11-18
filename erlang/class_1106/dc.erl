%% Quiz 6 - Hanfan Wang - 11/06/2019
-module(dc).
-compile(export_all).

dryCleaner(Clean ,Dirty) -> %% Clean , Dirty are counters
    receive
        {dropoffOverall} ->
            dryCleaner(Clean, Dirty + 1);
        {From, Ref, dryCleanItem} when Dirty > 0 ->
            From! {self(), Ref, ok},
            dryCleaner(Clean + 1, Dirty - 1);
        {From, Ref, pickUpOverall} when Clean > 0 ->
            From ! {self(), Ref, ok},
            dryCleaner(Clean - 1, Dirty)
    end.

employee(DC) -> 
    DC ! {dropoffOverall},
    Ref = make_ref(),
    DC ! {self(),Ref, pickUpOverall}, % pick up a clean one
    receive
        {DC, Ref, ok} -> ok
    end.

dryCleanMachine (DC) -> 
    Ref = make_ref(),
    DC ! {self(), Ref, dryCleanItem}, % dry clean item
    receive
        {DC, Ref, ok} ->
            timer:sleep(1000),
            dryCleanMachine(DC)
    end.

start(E,M) -> 
    DC= spawn (? MODULE ,dryCleaner , [ 0,0 ] ), 
    [ spawn (? MODULE ,employee , [ DC ] ) || _ <- lists:seq(1,E) ] , 
    [ spawn (? MODULE ,dryCleanMachine , [ DC ] ) || _ <- lists:seq(1,M) ] .

%1> c(dc).
% {ok,dc}
% 2> dc:start(5, 10).
% [<0.69.0>,<0.70.0>,<0.71.0>,<0.72.0>,<0.73.0>,<0.74.0>,
% <0.75.0>,<0.76.0>,<0.77.0>,<0.78.0>]
% 3> i().
