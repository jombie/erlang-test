-module(rpc_area).
-export([start/0, loop/0, area/2]).

start() -> spawn(rpc_area, loop, []).

area(Pid, Request) ->
	rpc(Pid, Request).

rpc(Pid, Request) -> 
	Pid ! {self(), Request},
	receive
	  {Pid, Response} -> Response
	end.

loop() ->
	receive
	  {From, {rectangle,W,H}} -> 
		From ! {self(), W * H}, 
		loop();
	  {From, {circle, R}} ->
		From ! {self(), 3.14159 * R * R},
		loop();
	  {From, Other} ->
		From ! {self(), {error, Other}},
		loop()
	end.
