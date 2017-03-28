-module(p35).
-export([doubleAll/1, evens/1, product/1,zip/2, zip_with/3, zip_with2/3, zip2/2]).
%-include"eunit/include/eunit.hrl"

doubleAll(L)->lists:map(fun(X)->2*X end, L).

evens(L)->lists:filter(fun(X)->X rem 2 == 0 end, L).

product(L)->lists:foldr(fun(X,Y)->X*Y end, 1, L).

zip(L1,L2)->zip(L1,L2,[]).

zip([],_,Rs)->Rs;
zip(_,[],Rs)->Rs;
zip([H1|T1],[H2|T2],Rs)->zip(T1,T2,Rs++[{H1,H2}]).

zip_with(F,L1,L2)->zip_with(F,L1,L2,[]).

zip_with(_,[],_,Rs)->Rs;
zip_with(_,_,[],Rs)->Rs;
zip_with(F,[H1|T1],[H2|T2],Rs)->zip_with(F,T1,T2,Rs++[F(H1,H2)]).

zip_with2(F,L1,L2)->lists:map(F,zip(L1,L2)).

zip2(L1,L2)->zip_with(fun(X,Y)->{X,Y} end,L1,L2).
