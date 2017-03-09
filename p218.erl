-module(p218).
-export([join/2, concat/1, member/2, split/1, qSort/1, mSort/1, iSort/1, insert/3, perms/1]).

%% Reverse lists and add it in the head of the given Rs, store into Rs
reverse([],Rs)->Rs;
reverse([H|T],Rs)->reverse(T,[H|Rs]).

%% join/2: reverse the first list, reverse the second list, add into the previuos result and then reverse result list
join(L1,L2)->reverse(reverse(L2,reverse(L1,[])),[]).

%% Concat function
concat(L)->concat(L,[]).

concat([],Rs)->Rs;
concat([H|T], Rs)->concat(T, join(Rs,H)).

%% Testing membership
member(_,[])->false;
member(N,[N|_])->true;
member(N,[_|T])->member(N,T).

%% Merge sort
split([])->[];
split([A])->[A];
split(L)->split(L,[],1,length(L) div 2).

split([H|T],First,I,Len)->
	if
		I==Len-> [[H|First],T];
		true->split(T,[H|First],I+1,Len)
	end.

mSort([])->[];
mSort([A])->[A];
mSort(L)->
	[L1,L2]=split(L),
	merge(mSort(L1),mSort(L2),[]).

merge([],[],Rs)->Rs;
merge([],L2,Rs)->Rs++L2;
merge(L1,[],Rs)->Rs++L1;
merge([H1|T1],[H2|T2],Rs)->
	if	(H1<H2)->merge(T1,[H2|T2],join(Rs,[H1]));
		(H1==H2)->merge(T1,T2,concat([Rs,[H1],[H2]]));
		true->merge([H1|T1],T2,join(Rs,[H2]))
	end.

%% Quick sort
qSort([])->[];
qSort([Pivot|T])->concat([qSort([Smaller||Smaller<-T,Smaller=<Pivot]),[Pivot],qSort([Larger||Larger<-T,Larger>Pivot])]).

%% Insertion sort
insert(N,[],Rs)->join(Rs,[N]);
insert(N,[H|T],Rs)->
	case N>H of
		true -> insert(N,T,join(Rs,[H]));
		false -> concat([Rs,[N],[H],T])
	end.

iSort([])->[];
iSort([A])->[A];
iSort([H|T])->insert(H,iSort(T),[]).


%% Permutation

% My own solution
%perms([])->[[]];
%perms([A])->[[A]];
%perms([A,B|[]])->[[A,B],[B,A]];
%perms(L)->perms(L,L,[]).
%
%put2Head(_,[],Rs)->Rs;
%put2Head(N,[H|T],Rs)->put2Head(N,T,Rs++[[N]++H]).
%
%perms([],_,Rs)->Rs;
%perms([H|T],L,Rs)->perms(T,L,Rs++put2Head(H,perms(L--[H]),[])).


% The wonderful solution!
perms([]) -> [[]]; 
perms(L) -> 
[ [H|T] || H <- L, T <- perms(L -- [H]) ].
