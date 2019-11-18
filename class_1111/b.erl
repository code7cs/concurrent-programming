-module(b).
-compile(export_all).


barrier(0, N, L) ->
    %% Notify all threads that they can proceed, then restart barrier
    [From!{self(),ok} || From <- L],
    barrier(N,N,[]);
barrier(M, N, L) when M > 0->
    %% Wait for another thread ,then register its pid in L
    receive
        {From, reached} ->
            barrier(M- 1, N, [From|L])
    end.

pass_barrier(B) ->
    B ! {self(), reached},
    receive
        {B, ok} ->
            ok
    end.

client(B, Letter, Number) ->
    io:format("~p ~s~n", [self(), Letter]),
    pass_barrier(B),
    io:format("~p ~w~n", [self(), Number]).

start() ->
    B = spawn(?MODULE, barrier, [3, 3, []]),
    spawn(?MODULE, client,[B, "a", 1]),
    spawn(?MODULE, client,[B, "b", 2]),
    spawn(?MODULE, client,[B, "c", 3]).

