% Semaphore - Print "a" before "b"
-module(semaphore ).
-compile( export_all ).

make_semaphore (Permits) ->
        spawn (? MODULE ,semaphore ,[Permits]).

semaphore (0) ->
    receive
        {_From ,_Ref ,release} ->
            semaphore (1)
    end;
semaphore(P) when P>0 ->
    receive
        {From ,Ref ,release} ->
            From!{self(),Ref ,ok},
            semaphore(P+1);
        {From ,Ref ,acquire} ->
            From!{self(),Ref ,ok},
            semaphore(P -1) 
    end.

start () ->
    S = make_semaphore(0),
    spawn (?MODULE, p1, [S]),
    spawn (?MODULE, p2, [S]).

release(S) -> % could be included in semaphore module
    R = make_ref (),
    S!{self(),R,release},
    receive
        {S,R,ok} ->
            done
    end.

p1(S) ->
    io:format(" a" ),
    release(S).

p2(S) -> % acquire is inlined
    R = make_ref (),
    S!{self(),R,acquire},
    receive 
        {S,R,ok} -> 
            io:format(" b" )
    end.