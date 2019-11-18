-module(server).

-export([start_server/0]).

-include_lib("./defs.hrl").

-spec start_server() -> _.
-spec loop(_State) -> _.
-spec do_join(_ChatName, _ClientPID, _Ref, _State) -> _.
-spec do_leave(_ChatName, _ClientPID, _Ref, _State) -> _.
-spec do_new_nick(_State, _Ref, _ClientPID, _NewNick) -> _.
-spec do_client_quit(_State, _Ref, _ClientPID) -> _NewState.

start_server() ->
    catch(unregister(server)),
    register(server, self()),
    case whereis(testsuite) of
	undefined -> ok;
	TestSuitePID -> TestSuitePID!{server_up, self()}
    end,
    loop(
      #serv_st{
	 nicks = maps:new(), %% nickname map. client_pid => "nickname"
	 registrations = maps:new(), %% registration map. "chat_name" => [client_pids]
	 chatrooms = maps:new() %% chatroom map. "chat_name" => chat_pid
	}
     ).

loop(State) ->
    receive 
	%% initial connection
	{ClientPID, connect, ClientNick} ->
	    NewState =
		#serv_st{
		   nicks = maps:put(ClientPID, ClientNick, State#serv_st.nicks),
		   registrations = State#serv_st.registrations,
		   chatrooms = State#serv_st.chatrooms
		  },
	    loop(NewState);
	%% client requests to join a chat
	{ClientPID, Ref, join, ChatName} ->
	    NewState = do_join(ChatName, ClientPID, Ref, State),
	    loop(NewState);
	%% client requests to join a chat
	{ClientPID, Ref, leave, ChatName} ->
	    NewState = do_leave(ChatName, ClientPID, Ref, State),
	    loop(NewState);
	%% client requests to register a new nickname
	{ClientPID, Ref, nick, NewNick} ->
	    NewState = do_new_nick(State, Ref, ClientPID, NewNick),
	    loop(NewState);
	%% client requests to quit
	{ClientPID, Ref, quit} ->
	    NewState = do_client_quit(State, Ref, ClientPID),
	    loop(NewState);
	{TEST_PID, get_state} ->
	    TEST_PID!{get_state, State},
	    loop(State)
    end.

%% executes join protocol from server perspective
do_join(ChatName, ClientPID, Ref, State) ->
	Nicks = State#serv_st.nicks,
	Chatrooms = State#serv_st.chatrooms,
	Registrations = State#serv_st.registrations,
	case maps:is_key(ChatName, Chatrooms) of	% check if chatroom exists
		false ->
			ChatroomPID = spawn(chatroom, start_chatroom, [ChatName]),
			NewState = State#serv_st{
				chatrooms = maps:put(ChatName, ChatroomPID, Chatrooms),
				registrations = maps:put(ChatName, [ClientPID], Registrations)
			},
			do_join(ChatName, ClientPID, Ref, NewState);
		true ->
			ChatroomPID = maps:get(ChatName, Chatrooms),
			Nickname = maps:get(ClientPID, Nicks),
			ChatroomPID ! {self(), Ref, register, ClientPID, Nickname},
			Clients = lists:append([ClientPID], maps:get(ChatName, Registrations)),
			State#serv_st{
				registrations = maps:update(ChatName, Clients, Registrations)
			}
	end.

%% executes leave protocol from server perspective
do_leave(ChatName, ClientPID, Ref, State) ->
	Registrations = State#serv_st.registrations,
	ChatroomPID = maps:get(ChatName, State#serv_st.chatrooms),
	% remove client
	NewState = State#serv_st{
		registrations = maps:update(
			ChatName, 
			lists:delete(ClientPID, maps:get(ChatName, Registrations)),
			Registrations)
	},
	ChatroomPID ! {self(), Ref, unregister, ClientPID},
	ClientPID ! {self(), Ref,  ack_leave},
	NewState.

%% executes new nickname protocol from server perspective
do_new_nick(State, Ref, ClientPID, NewNick) ->
    case lists:member(NewNick, maps:values(State#serv_st.nicks)) of
		true ->
			ClientPID ! {self(), Ref, err_nick_used},
			NewState = State;
		false ->
			NewState = State#serv_st{
				nicks = maps:update(ClientPID, NewNick, State#serv_st.nicks)
			},
			RegistrationsCli = maps:values(State#serv_st.registrations),
			ChatroomNamesList = lists:filter(fun(X) -> not lists:member(ClientPID, X) end, RegistrationsCli),
			ChatroomPIDs = maps:values(maps:filter(fun(Name, _Pid) -> not lists:member(Name, ChatroomNamesList) end, State#serv_st.chatrooms)),
			lists:map(fun(Pid) -> Pid ! {self(), Ref, update_nick, ClientPID, NewNick} end, ChatroomPIDs),
			ClientPID ! {self(), Ref, ok_nick}
	end,
	NewState.

%% executes client quit protocol from server perspective
do_client_quit(State, Ref, ClientPID) ->
	RegistrationsCli = maps:values(State#serv_st.registrations),
	ChatroomNamesList = lists:filter(fun(X) -> not lists:member(ClientPID, X) end, RegistrationsCli),
	ChatroomPIDs = maps:values(maps:filter(fun(Name, _Pid) -> not lists:member(Name, ChatroomNamesList) end, State#serv_st.chatrooms)),
	lists:map(fun(Pid) -> Pid ! {self(), Ref, unregister, ClientPID} end, ChatroomPIDs),
	ClientPID!{self(), Ref, ack_quit},
	State#serv_st{
		nicks = maps:remove(ClientPID, State#serv_st.nicks),
		registrations = maps:map(fun(_Name, Pids) -> lists:delete(ClientPID, Pids) end, State#serv_st.registrations)
	}.