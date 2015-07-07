-module(counter).
-compile(export_all).

new() -> spawn(fun() -> loop(0) end).

loop(N) -> 
	receive 
	  {click, From} -> 
		From ! N + 1,
		loop(N + 1)
	end.

%API Function to increment counter
click(Pid) -> 
	Pid ! {click, self()},
	receive V -> V end.


