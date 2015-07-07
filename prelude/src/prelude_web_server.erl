%% @author shubhendu
%% @doc @todo Add description to prelude_web_server.


-module(prelude_web_server).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0, start/1]).

start() ->
    start(8080).

start(Port) ->
	io:format("Starting ~p (~p)...~n", [?MODULE, self()]),
	N_acceptors = 100,
    Dispatch = cowboy_router:compile(
		 [
		  %% {URIHost, list({URIPath, Handler, Opts})}
		  {'_', [{"/send_message.html", prelude_request_handler, []}]}
		 ]),
	%% Name, NbAcceptors, TransOpts, ProtoOpts
    cowboy:start_http(?MODULE,
		      N_acceptors,
		      [{port, Port}],
		      [{env, [{dispatch, Dispatch}]}]
		     ).

%% ====================================================================
%% Internal functions
%% ====================================================================


