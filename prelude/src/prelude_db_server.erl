%% @author shubhendu
%% @doc @todo Add description to prelude_db_server.


-module(prelude_db_server).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0, stop/0, add_process_info/1, get_process_info/1, remove_process_info/1]).

start() ->
	io:format("Starting ~p (~p)...~n", [?MODULE, self()]),
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).

add_process_info(ProcessInfo) ->
	gen_server:call(?MODULE, {add_process_info, ProcessInfo}).

get_process_info(ProcessName) ->
	gen_server:call(?MODULE, {get_process_info, ProcessName}).

remove_process_info(ProcessName) ->
	gen_server:call(?MODULE, {remove_process_info, ProcessName}).

%% ====================================================================
%% Behavioural functions 
%% ====================================================================
-record(state, {}).

init([]) ->
	process_flag(trap_exit, true),
	prelude_mnesia_db:init_db(),
    {ok, #state{}}.

handle_call({add_process_info, ProcessInfo}, _From, State) ->
	prelude_mnesia_db:add_process_info(ProcessInfo),
    {reply, ok, State};

handle_call({get_process_info, ProcessName}, _From, State) ->
	ProcessLocation = prelude_mnesia_db:get_process_info(ProcessName),
    {reply, ProcessLocation, State};

handle_call({remove_process_info, ProcessName}, _From, State) ->
	prelude_mnesia_db:remove_process_info(ProcessName),
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
