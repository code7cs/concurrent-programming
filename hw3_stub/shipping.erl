-module(shipping).
-compile(export_all).
-include_lib("./shipping.hrl").

get_ship(Shipping_State, Ship_ID) ->
    Ship = lists:keyfind(Ship_ID, 2, Shipping_State#shipping_state.ships),
    io:format('#ship{id = ~w,name = "~s",container_cap = ~w}~n', [Ship#ship.id, Ship#ship.name, Ship#ship.container_cap]).

get_container(Shipping_State, Container_ID) ->
    Container = lists:keyfind(Container_ID, 2, Shipping_State#shipping_state.containers),
    io:format('#container{id = ~w,weight = ~w}~n', [Container#container.id, Container#container.weight]).

get_port(Shipping_State, Port_ID) ->
    Port = lists:keyfind(Port_ID, 2, Shipping_State#shipping_state.ports),
    io:format('#port{id = ~w,name = "~s",~n docks = ~w,~n container_cap = ~w}~n',[Port#port.id, Port#port.name, Port#port.docks, Port#port.container_cap]).

get_occupied_docks(Shipping_State, Port_ID) ->
    [element(2, N) || N <- Shipping_State#shipping_state.ship_locations, element(1, N) == Port_ID].

get_ship_location(Shipping_State, Ship_ID) ->
    ShipLocation = lists:keyfind(Ship_ID, 3, Shipping_State#shipping_state.ship_locations),
    io:format("{~w,'~s'}~n",[element(1, ShipLocation), element(2, ShipLocation)]).

get_container_weight(Shipping_State, Container_IDs) ->
    WeightList = [ M#container.weight || M <- Shipping_State#shipping_state.containers, lists:member(M#container.id, Container_IDs)],
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, WeightList).

get_ship_weight(Shipping_State, Ship_ID) ->
    Container_IDs = maps:get(Ship_ID, Shipping_State#shipping_state.ship_inventory),
    get_container_weight(Shipping_State, Container_IDs).
    
load_ship(Shipping_State, Ship_ID, Container_IDs) ->                                        % 1, [16,18,20]
    SS = Shipping_State,
    PortId = element(1, lists:keyfind(Ship_ID, 3, SS#shipping_state.ship_locations)),   % 1
    PortList = maps:get(PortId, SS#shipping_state.port_inventory),               % [16,17,18,19,20]
    ShipList = maps:get(Ship_ID, SS#shipping_state.ship_inventory),              % [14,15,9,2,6]
    ShipCap = element(4, lists:keyfind(Ship_ID, 2, SS#shipping_state.ships)),
    case [N || N <- Container_IDs, lists:member(N, PortList)] of    % make sure containers are at the same port as the ship
        Container_IDs ->
            NewShipList = lists:append(ShipList, Container_IDs),
            case length(NewShipList) =< ShipCap of
                true ->
                    NewPortList = lists:filter(fun(N) -> not(lists:member(N, Container_IDs)) end, PortList),
                    % [lists:delete(N, PortList) || N <- Container_IDs],
                    M1 = maps:update(Ship_ID, NewShipList, SS#shipping_state.ship_inventory),
                    M2 = maps:update(PortId, NewPortList, SS#shipping_state.port_inventory),
                    SS#shipping_state{ship_inventory=M1, port_inventory=M2};        % updating records
                false -> list_to_atom("error")
            end;
        error -> error  % todo "containers are not at the same port as ship"
    end.

unload_ship_all(Shipping_State, Ship_ID) ->                 % 2
    SS = Shipping_State,
    PortId = element(1, lists:keyfind(Ship_ID, 3, SS#shipping_state.ship_locations)),    % find the location, port 3
    PortCap = element(5, lists:keyfind(PortId, 2, SS#shipping_state.ports)),   % 200
    ShipList = maps:get(Ship_ID, SS#shipping_state.ship_inventory),                     % [1,3,4,13]
    NewPortList = lists:append(maps:get(PortId, SS#shipping_state.port_inventory), ShipList),   % [26,27,28,29,30,1,3,4,13]
    case length(NewPortList) =< PortCap of
        true ->
            M1 = maps:update(Ship_ID, [], SS#shipping_state.ship_inventory),
            M2 = maps:update(PortId, NewPortList, SS#shipping_state.port_inventory),
            SS#shipping_state{ship_inventory=M1, port_inventory=M2};
        false -> list_to_atom("error")
    end.

unload_ship(Shipping_State, Ship_ID, Container_IDs) ->                                  % 1, [14,2]
    SS = Shipping_State,
    PortId = element(1, lists:keyfind(Ship_ID, 3, SS#shipping_state.ship_locations)),   % 1
    PortList = maps:get(PortId, SS#shipping_state.port_inventory),               % [16,17,18,19,20]
    ShipList = maps:get(Ship_ID, SS#shipping_state.ship_inventory),              % [14,15,9,2,6]
    PortCap = element(5, lists:keyfind(PortId, 2, SS#shipping_state.ports)),   % 200
    case [N || N <- Container_IDs, lists:member(N, ShipList)] of
        Container_IDs ->
            NewPortList = lists:append(PortList, Container_IDs),
            case length(NewPortList) =< PortCap of
                true ->
                    NewShipList = lists:filter(fun(N) -> not(lists:member(N, Container_IDs)) end, ShipList),
                    M1 = maps:update(Ship_ID, NewShipList, SS#shipping_state.ship_inventory),
                    M2 = maps:update(PortId, NewPortList, SS#shipping_state.port_inventory),
                    SS#shipping_state{ship_inventory=M1, port_inventory=M2};        % updating records
                false -> list_to_atom("error")
            end;
        _error -> io:format("~s~n~s~n", ["The given conatiners are not all on the same ship...", list_to_atom("error")])
    end.

set_sail(Shipping_State, Ship_ID, {Port_ID, Dock}) ->
    Locations = Shipping_State#shipping_state.ship_locations,
    PortDocksList = element(4, lists:keyfind(Port_ID, 2, Shipping_State#shipping_state.ports)), % ['A','B','C','D']
    case lists:member(Dock, PortDocksList) of     % check if the Dock is in PortDocksList,(A,B,C or D)
        true ->
            case lists:member(Dock, get_occupied_docks(Shipping_State, Port_ID)) of
                false ->
                    NewLocations = lists:keyreplace(Ship_ID, 3, Locations, {Port_ID, Dock, Ship_ID}),
                    Shipping_State#shipping_state{ship_locations=NewLocations};
                true -> list_to_atom("error");
                error -> error
            end;
        false -> list_to_atom("error")    
    end.    



%% Determines whether all of the elements of Sub_List are also elements of Target_List
%% @returns true is all elements of Sub_List are members of Target_List; false otherwise
is_sublist(Target_List, Sub_List) ->
    lists:all(fun (Elem) -> lists:member(Elem, Target_List) end, Sub_List).




%% Prints out the current shipping state in a more friendly format
print_state(Shipping_State) ->
    io:format("--Ships--~n"),
    _ = print_ships(Shipping_State#shipping_state.ships, Shipping_State#shipping_state.ship_locations, Shipping_State#shipping_state.ship_inventory, Shipping_State#shipping_state.ports),
    io:format("--Ports--~n"),
    _ = print_ports(Shipping_State#shipping_state.ports, Shipping_State#shipping_state.port_inventory).


%% helper function for print_ships
get_port_helper([], _Port_ID) -> error;
get_port_helper([ Port = #port{id = Port_ID} | _ ], Port_ID) -> Port;
get_port_helper( [_ | Other_Ports ], Port_ID) -> get_port_helper(Other_Ports, Port_ID).


print_ships(Ships, Locations, Inventory, Ports) ->
    case Ships of
        [] ->
            ok;
        [Ship | Other_Ships] ->
            {Port_ID, Dock_ID, _} = lists:keyfind(Ship#ship.id, 3, Locations),
            Port = get_port_helper(Ports, Port_ID),
            {ok, Ship_Inventory} = maps:find(Ship#ship.id, Inventory),
            io:format("Name: ~s(#~w)    Location: Port ~s, Dock ~s    Inventory: ~w~n", [Ship#ship.name, Ship#ship.id, Port#port.name, Dock_ID, Ship_Inventory]),
            print_ships(Other_Ships, Locations, Inventory, Ports)
    end.

print_containers(Containers) ->
    io:format("~w~n", [Containers]).

print_ports(Ports, Inventory) ->
    case Ports of
        [] ->
            ok;
        [Port | Other_Ports] ->
            {ok, Port_Inventory} = maps:find(Port#port.id, Inventory),
            io:format("Name: ~s(#~w)    Docks: ~w    Inventory: ~w~n", [Port#port.name, Port#port.id, Port#port.docks, Port_Inventory]),
            print_ports(Other_Ports, Inventory)
    end.
%% This functions sets up an initial state for this shipping simulation. You can add, remove, or modidfy any of this content. This is provided to you to save some time.
%% @returns {ok, shipping_state} where shipping_state is a shipping_state record with all the initial content.
shipco() ->
    Ships = [#ship{id=1,name="Santa Maria",container_cap=20},
              #ship{id=2,name="Nina",container_cap=20},
              #ship{id=3,name="Pinta",container_cap=20},
              #ship{id=4,name="SS Minnow",container_cap=20},
              #ship{id=5,name="Sir Leaks-A-Lot",container_cap=20}
             ],
    Containers = [
                  #container{id=1,weight=200},
                  #container{id=2,weight=215},
                  #container{id=3,weight=131},
                  #container{id=4,weight=62},
                  #container{id=5,weight=112},
                  #container{id=6,weight=217},
                  #container{id=7,weight=61},
                  #container{id=8,weight=99},
                  #container{id=9,weight=82},
                  #container{id=10,weight=185},
                  #container{id=11,weight=282},
                  #container{id=12,weight=312},
                  #container{id=13,weight=283},
                  #container{id=14,weight=331},
                  #container{id=15,weight=136},
                  #container{id=16,weight=200},
                  #container{id=17,weight=215},
                  #container{id=18,weight=131},
                  #container{id=19,weight=62},
                  #container{id=20,weight=112},
                  #container{id=21,weight=217},
                  #container{id=22,weight=61},
                  #container{id=23,weight=99},
                  #container{id=24,weight=82},
                  #container{id=25,weight=185},
                  #container{id=26,weight=282},
                  #container{id=27,weight=312},
                  #container{id=28,weight=283},
                  #container{id=29,weight=331},
                  #container{id=30,weight=136}
                 ],
    Ports = [
             #port{
                id=1,
                name="New York",
                docks=['A','B','C','D'],
                container_cap=200
               },
             #port{
                id=2,
                name="San Francisco",
                docks=['A','B','C','D'],
                container_cap=200
               },
             #port{
                id=3,
                name="Miami",
                docks=['A','B','C','D'],
                container_cap=200
               }
            ],
    %% {port, dock, ship}
    %% ship_locations: a tuple containing a port id, dock id, and ship id (i.e. (1,’A’,3)) if port 1, dock ’A’ contains ship 3
    Locations = [
                 {1,'B',1},
                 {1, 'A', 3},
                 {3, 'C', 2},
                 {2, 'D', 4},
                 {2, 'B', 5}
                ],
    %% ship_inventory: a map that takes a ship id and maps it to the list of containers ids on that ship.
    Ship_Inventory = #{
      1=>[14,15,9,2,6],
      2=>[1,3,4,13],
      3=>[],
      4=>[2,8,11,7],
      5=>[5,10,12]},
    %% port inventory: a map that takes a port id and maps it to the list of containers ids at that port.
    Port_Inventory = #{
      1=>[16,17,18,19,20],
      2=>[21,22,23,24,25],
      3=>[26,27,28,29,30]
     },
    #shipping_state{ships = Ships, containers = Containers, ports = Ports, ship_locations = Locations, ship_inventory = Ship_Inventory, port_inventory = Port_Inventory}.
