%% @author shubhendu
%% @doc @todo Add description to prelude_db.


-module(prelude_mnesia_db).
-behaviour(prelude_gen_db).
-include("../include/prelude_gen_db.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([init_db/0, add_process_info/1, get_process_info/1, remove_process_info/1]).

-include_lib("stdlib/include/qlc.hrl").

init_db() ->
    mnesia:create_schema([node()]),
	mnesia:start(),
	try
		mnesia:table_info(type, process_info)
	catch
		exit: _ ->
		mnesia:create_table(process_info, 
							[{attributes, record_info(fields, process_info)},
							 {type, set}, 
							 {ram_copies, [node()]}])
	end.

add_process_info(ProcessInfo) ->
	F = fun() -> mnesia:write(ProcessInfo) end,
	mnesia:transaction(F).

get_process_info(ProcessName) ->
	F = fun() -> 
		Query = qlc:q([ProcessInfo#process_info.process_location || ProcessInfo <- mnesia:table(process_info),
					   ProcessInfo#process_info.process_name =:= ProcessName]),	
		qlc:e(Query) 
		end,
	{atomic, Val} = mnesia:transaction(F),
	Val.

remove_process_info(ProcessName) ->
	ObjectId = {process_info, ProcessName},
	F = fun() -> mnesia:delete(ObjectId) end,
	mnesia:transaction(F).
