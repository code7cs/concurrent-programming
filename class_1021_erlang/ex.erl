-module(ex).
-compile(export_all).



%%% Class 1 -- Basic recursion on numbers and lists

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

%%% Class 2 - Records and recursive data structures

-record(person,{name :: string() ,age :: number()}).

-type person() :: #person{}.

-spec aPerson() -> person().

aPerson() ->
    #person{name=34,age=23}.


%%% recursive data structures


%%% {empty}   -- Empty tree
%%% {node,Data, LeftTree, RightTree}  -- Non empty tree 


-type btree() :: {empty} | {node,any(),btree(),btree()}.

-spec sizeT(btree()) -> number().

sizeT({empty}) ->
    0;
sizeT({node,_D,LT,RT}) ->
    1 + sizeT(LT) + sizeT(RT).

sumT({empty}) ->
    0;
sumT({node,D,LT,RT}) ->
    D+sumT(LT)+sumT(RT).

is_empty({empty}) ->
    true;
is_empty({node,_,_,_}) ->
    false.



%%%% Copy from here onwards


mkLeaf(N) ->
    {node,N,{empty},{empty}}.


aTree() ->
    {node,7,mkLeaf(2),{node,9,mkLeaf(8),{empty}}}.

foldT(_F,A,{empty}) ->
    A;
foldT(F,A,{node,D,LT,RT}) ->
    F(D,foldT(F,A,LT),foldT(F,A,RT)).

test()->
    foldT(fun (X,AL,AR) -> [X|AL++AR] end,[],aTree()).

mirror(T) ->
    foldT(fun (D,ML,MR) -> {node,D,MR,ML} end,{empty},T).

mapT(_F,{empty}) ->
    {empty};
mapT(F,{node,D,LT,RT}) ->
    {node,F(D),mapT(F,LT),mapT(F,RT)}.


mapT2(F,T) ->
    foldT(fun (X,ML,MR) -> {node,F(X),ML,MR} end,{empty},T).


-spec f(number()) -> number().

f(0) ->
    a;
f(N) ->
    7.

%%%% Maps

-record(inh,{name,children}).

theRegistry() ->
    M = maps:new(),
    M1 = maps:put(1,#inh{name="Tom",children=[5,6]},M),
    M2 = maps:put(2,#inh{name="Sue",children=[5]},M1),
    M3 = maps:put(3,#inh{name="Anne",children=[6]},M2),
    M4 = maps:put(4,#inh{name="Jill",children=[]},M3),
    M5 = maps:put(5,#inh{name="Robert",children=[]},M4),
    M6 = maps:put(6,#inh{name="Kim",children=[7]},M5),
    M7 = maps:put(7,#inh{name="Bill",children=[9]},M6),
    M8 = maps:put(8,#inh{name="Alice",children=[9]},M7),
    maps:put(9,#inh{name="Susan",children=[]},M8).
           
nameOf(Id,TownR) ->     
    case maps:find(Id,TownR) of
	{ok,R} -> R#inh.name;
	% {ok,R} -> R;
	error -> error
    end.

nameOfChildrenOf(Id,TownR) ->
    case maps:find(Id,TownR) of
       {ok,R} ->  lists:map(fun (Id) -> nameOf(Id,TownR) end,R#inh.children);
	error -> error
    end.

childrenOf(Id,TownR) ->
    case maps:find(Id,TownR) of
       {ok,R} ->  R#inh.children;
	error -> error
    end.

%% descendants of an id
%% For example,
%% > ex:descendantsOf(1,ex:theRegistry()).
%% [1,5,6,7,9]
%% > ex:descendantsOf(2,ex:theRegistry()).
%% [2,5]
%% > ex:descendantsOf(3,ex:theRegistry()).
%% [3,6,7,9]
%% > ex:descendantsOf(4,ex:theRegistry()).
%% [4]


% > ex:theRegistry().
% #{1 => {inh,"Tom",[5,6]},
%   2 => {inh,"Sue",[5]},
%   3 => {inh,"Anne",[6]},
%   4 => {inh,"Jill",[]},
%   5 => {inh,"Robert",[]},
%   6 => {inh,"Kim",[7]},
%   7 => {inh,"Bill","\t"},
%   8 => {inh,"Alice","\t"},
%   9 => {inh,"Susan",[]}}

descendantsOf(Id,TownR) ->
    descendantsOf(TownR, [], [Id]).

descendantsOf(_TownR, Visited, []) ->
    Visited;
descendantsOf(TownR, Visited, Current) ->
    DD = lists:flatten(lists:map(fun(Id)-> childrenOf(Id, TownR) end, Current)),
    descendantsOf(TownR, Visited++Current, DD).
    % New_Current = lists:filter(fun(Id) -> not(lists:member(Id, Visited)) end, DD),
    % the above line would be required for a standard BFS traversal, but is not necessary for this example
    % descendantsOf(TownR, Visited++Current, New_Current).


ancestorsOf(Id,TownR) ->
    ancestorsOf(TownR, [], [Id]).

ancestorsOf(_TownR, Visited, []) ->
    Visited;
ancestorsOf(TownR, Visited, Current) ->
    % maps:keys()  ====>  a list of keys in the map TownR, here is [1, 2, 3, ... 9]
    % lists:all()  ====>  check if current Id is the sublist of children of the item, return true or false
    % when `lists:all()` is true, put the id into AA
    AA = [N || N <- maps:keys(TownR), lists:all(fun (Elem) -> lists:member(Elem, element(3, maps:get(N, TownR))) end, Current)],
    ancestorsOf(TownR, Visited++AA, AA).




    





