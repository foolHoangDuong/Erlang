-module(p311).
-export([compose/1, twice/1, iterate/1]).

compose(L)->lists:foldr(fun hof:compose/2, fun hof:id/1, L).

twice(F)->compose([F,F]).

iterate(0)-> id;
iterate(N) when N>0 ->
	fun(F)->compose(lists:duplicate(N,F)) end.
