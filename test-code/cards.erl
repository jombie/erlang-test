-module(cards).
-compile(export_all).

-type suit()  :: spades | hearts | clubs | diamonds.
-type value() :: 1..10 | j | q | k.
-type card()  :: {suit(), value()}.

-spec kind(card()) -> face | number.

kind({_, A}) when A >= 1, A =< 10 -> number;
kind(_) -> face.

main() ->
	number = kind({spades, 7}),
	face = kind({clubs, q}),
	number = kind({rubies, 4}).
