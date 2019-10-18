-module(ex).
-compile(export_all).



fact(0) ->
    1;
fact(N) when N>0 ->  %% when clause
    N*fact(N-1).

len([]) ->
    0;
len([_H|T]) ->   %%% pattern for non-empty list
    1+len(T).

sum([]) ->
    0;
sum([H|T]) ->
    H+sum(T).

map(_F,[]) ->
    [];
map(F,[H|T]) ->
   [F(H) | map(F,T) ].

foldl(_F,A,[]) ->
    A;
foldl(F,A,[H|T]) ->
     F(H,foldl(F,A,T)).

foldr(_F,A,[]) ->
    A;
 foldr(F,A,[H|T]) ->
    foldr(F,F(A,H),T).

%% mem(X,L)

mem(_X,[]) ->
    false;
mem(X,[H|T]) -> 
    (X==H) or mem(X,T).

%% sublist(L1,L2)



