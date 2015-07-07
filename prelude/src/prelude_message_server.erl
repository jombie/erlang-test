%% @author shubhendu
%% @doc @todo Add description to user_message_server.


-module(prelude_message_server).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1, stop/1, process_message/3]).

start(ProcessName) ->
	gen_server:start_link({local, ProcessName}, ?MODULE, [], []).

stop(ProcessName) ->
	gen_server:call({local, ProcessName}, stop).

process_message(ProcessName, Sender, Msg) ->
	gen_server:call(ProcessName, {process_message, Sender, Msg}).

%% ====================================================================
%% Behavioural functions 
%% ====================================================================
-record(state, {}).

init([]) ->
    {ok, #state{}}.


handle_call({process_message, Sender, Msg}, From, State) ->
	io:format("Received Message: ~s Sender: ~s~n", [Msg, Sender]),
    {reply, "Message was delivered", State};

handle_call(stop, From, State) ->
    {stop, normal, stopped, State}.	

handle_cast(Msg, State) ->
    {noreply, State}.


handle_info(Info, State) ->
    {noreply, State}.


terminate(Reason, State) ->
    ok.

code_change(OldVsn, State, Extra) ->
    {ok, State}.
