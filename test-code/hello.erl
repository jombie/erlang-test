-module(hello).
-export([start/0]).

start()     -> io:format("Hello Shubhendu~n").
start(Name) -> io:format("Hello ~s",[Name]).
