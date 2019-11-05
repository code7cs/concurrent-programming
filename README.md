# concurrent-programming

Pid = spwan(Module_name, Function_name, List_of_Arguments)

<!-- 

S= spawn(ex, gen_server, [0, fun(S,I)-> {S + 1, ex: fact(I)} end]).
S!{request, self(), make_ref(), 7}.
flush().
regigter(server, S).
server!{request, self(), make_ref(), 7}.

ex:start(). 

-->
