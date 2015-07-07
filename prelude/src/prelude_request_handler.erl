-module(prelude_request_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("../include/prelude_gen_db.hrl").

-record(state, {
}).

init(_, Req, _Opts) ->
	{ok, Req, #state{}}.

handle(Req, State=#state{}) ->
	{To, Req1} = cowboy_req:qs_val(<<"to">>, Req),
	{Message, Req2} = cowboy_req:qs_val(<<"message">>, Req1),

	%% 	Check if process exists based on userid, if present send the message else send it to offline store.
	ProcessName = binary_to_atom(To, utf8),
	Location = prelude_db_server:get_process_info(ProcessName),
	process_message(ProcessName, To, Message, Location),
	{ok, Req3} = cowboy_req:reply(200, [{<<"content-type">>, <<"text/plain">>}],<<"Reply">>, Req2),
	{ok, Req3, State}.

process_message(ProcessName, To, Message, []) ->
	%% Start a new process since for the user there is no process registered.
	ProcessLocation = node(),
	ProcessName = binary_to_atom(To, utf8),
	ProcessId = prelude_message_server:start(ProcessName),
	io:format("Started process ~p with id ~p on node ~p ~n", [ProcessName, ProcessId, ProcessLocation]),
 	prelude_db_server:add_process_info(#process_info{process_name=ProcessName, process_id=ProcessId, process_location=ProcessLocation}),
	prelude_message_server:process_message(ProcessName, To, Message);

process_message(ProcessName, To, Message, [Location | _]) ->
	io:format("Processing in already regitered process ~p at node ~p ~n", [ProcessName, Location]),
	prelude_message_server:process_message(ProcessName, To, Message).

terminate(_Reason, _Req, _State) ->
	ok.
