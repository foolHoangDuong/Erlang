-module(p26).
-export([product/1, productT/1, fmax/1, fmaxT/1]).

%product function using direct recursion
product([])->invalid;
product([A])->A;
product([H|T])->H*product(T).

%product function using tail recursion
productT([])->invalid;
productT(L)->productT(L,1).

productT([A],P)->A*P;
productT([H|T],P)->productT(T,H*P).


%maximum function using direct recursion
fmax([])->invalid;
fmax([A])->A;
fmax([H1,H2|T])->fmax([max(H1,H2)|T]).

%maximum function using tail recursion
fmaxT([])->invalid;
fmaxT([H|T])->fmaxT(T,H).

fmaxT([],M)->M;
fmaxT([H|T],M)->fmaxT(T,max(H,M)).
