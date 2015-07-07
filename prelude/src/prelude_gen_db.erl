%% @author shubhendu
%% @doc @todo Add description to prelude_gen_db.


-module(prelude_gen_db).

-include("../include/prelude_gen_db.hrl").
-type process_info() :: #process_info{}.

-callback init_db() -> 'ok'|tuple('error', Reason :: string()).
 
-callback add_process_info(ProcessInfo :: process_info()) -> 'ok'|tuple('error', Reason :: string()).
 
-callback get_process_info(ProcessName :: string()) -> 'ok'|tuple('error', Reason :: string()).

-callback remove_process_info(ProcessName :: string()) -> 'ok'|tuple('error', Reason :: string()).

