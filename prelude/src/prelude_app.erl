-module(prelude_app).
-behaviour(application).

-export([start/2, stop/1, start/0, stop/0]).

start() ->
	application:start(?MODULE).

start(_Type, _Args) ->
	prelude_sup:start_link().

stop() ->
	mnesia:stop(),
	application:stop(?MODULE).

stop(_State) ->
	ok.
