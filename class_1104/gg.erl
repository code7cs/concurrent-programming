- module (gg).
% implement a guessing game
-compile( export_all ).

start () ->
    spawn (fun server /0).

server () ->
    receive
        {From, Ref, start} ->
            S = spawn(?MODULE, servlet, [From, rand:uniform(20)]), % spawn a servlet
            From ! {self(), Ref, S},
            server()
    end.

client(S) -> 
    R = make_ref(),
    S ! {self(), R, start},
    receive
        {S, R, Servlet} ->
            client_loop(Servlet, 0)
    end.

client_loop(Servlet, C) ->
    R = make_ref(),
    Servlet ! {self(), R, guess, rand:uniform(20)},
    receive
        {Servlet, R, gotIt} ->
            io:format("Client ~p guessed in ~w attempts~n", [self(), C]);
        {Servlet, R, tryAgain} ->
            servlet(Servlet, C+1)
    end.

servlet(Cl, Number) ->
    receive
        {Cl, Ref, guess, N} ->
            if 
                N == Number -> Cl ! {self(), Ref, gotIt};
                true -> Cl ! {self(), Ref, tryAgain},
                        servlet(Cl, Number)
            end
    end.


    % > [ spawn(gg,gg:client(S), []) || _ <- lists:seq(1,100) ].


