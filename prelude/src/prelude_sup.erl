-module(prelude_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	io:format("Initialising ~p (~p)...~n", [?MODULE, self()]),
	RestartStrategy = one_for_one,
	MaxRestarts = 3,
	MaxSecsBtwnRestarts = 5,
	Strategy = {RestartStrategy, MaxRestarts, MaxSecsBtwnRestarts},
	
	RestartType = permanent,
	ShutdownTimeOut = 10000,
	Type = worker,
	
	WebServerSpec = {webServerId, {prelude_web_server, start, [8080]}, 
					 RestartType, ShutdownTimeOut, Type, [prelude_web_server]},

	DbServerSpec = {dbServerId, {prelude_db_server, start, []}, 
						 RestartType, ShutdownTimeOut, Type, [prelude_db_server]},
	
	{ok, {Strategy, [WebServerSpec, DbServerSpec]}}.
