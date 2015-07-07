%% @author shubhendu
%% @doc @todo Add description to mnesia_test.


-module(mnesia_test).

%% ====================================================================
%% API functions
%% ====================================================================
-export([do_this_once/0, start/0, add_shop_item/3, add_cost_item/2, remove_shop_item/1, remove_cost_item/1, shop_query/1]).

-include_lib("stdlib/include/qlc.hrl").

-record(shop, {item, quantity, cost}).
-record(cost, {name, price}).
-record(design, {id, plan}).

do_this_once() ->
    mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(shop, [{attributes, record_info(fields, shop)}]),
	mnesia:create_table(cost, [{attributes, record_info(fields, cost)}]),
    mnesia:create_table(design, [{attributes, record_info(fields, design)}]),
	mnesia:stop().

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([shop,cost,design], 20000).

add_shop_item(Item, Quantity, Cost) ->
	Row = #shop{item=Item, quantity=Quantity, cost=Cost},
	F = fun() -> mnesia:write(Row) end,
	mnesia:transaction(F).

add_cost_item(Name, Price) ->
	Row = #cost{name=Name, price=Price},
	F = fun() -> mnesia:write(Row) end,
	mnesia:transaction(F).

remove_shop_item(Item) ->
	Oid = {shop, Item},
	F = fun() -> mnesia:delete(Oid) end,
	mnesia:transaction(F).

remove_cost_item(Item) ->
	Oid = {cost, Item},
	F = fun() -> mnesia:delete(Oid) end,
	mnesia:transaction(F).

shop_query(select) ->
	do(qlc:q([X || X <- mnesia:table(shop)]));

shop_query(where) ->
	do(qlc:q([X#shop.item || X <- mnesia:table(shop), 
							 #shop.quantity < 250]));

shop_query(join) ->
	do(qlc:q([X#shop.item || X <- mnesia:table(shop), 
							 #shop.quantity < 250,
							 Y <- mnesia:table(cost),
							 X#shop.item =:= Y#cost.name,
							 Y#cost.price < 2 ])).

%% ====================================================================
%% Internal functions
%% ====================================================================

do(Q) ->
	F = fun() -> qlc:e(Q) end,
	{atomic, Val} = mnesia:transaction(F),
	Val.

