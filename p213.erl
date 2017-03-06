-module(p213).
-export([nubFirst/1, nubLast/1]).

mem(N,[])->[N];
mem(N,[N|_])->[];
mem(N,[_|T])->mem(N,T).


nubFirst(L)->nubFirst(L,[]).

nubFirst([],Rs)->Rs;
nubFirst([H|T],Rs)->nubFirst(T,Rs++mem(H,Rs)).


nubLast(L)->nubLast(L,[]).

nubLast([],Rs)->Rs;
nubLast([H|T],Rs)->nubLast(T,Rs++mem(H,T)).
