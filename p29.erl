-module(p29).
-export([double/1, evens/1, med/1, mode/1]).

%%%% Some additional functions (in case of not use built-in functions) %%%%
%% reverse lists
reverse(L)->reverse(L,[]).

reverse([],Rs)->Rs;
reverse([H|T], Rs)->reverse(T,[H|Rs]).

%% Find 2 lists that contains numbers in a list which is less and greater than a specific number
sortNum(N,L)->sortNum(N,L,[],[]).

sortNum(_,[],LessL,GreaterL)-> [reverse(LessL),reverse(GreaterL)];
sortNum(N,[H|T],LessL,GreaterL)->
	case H<N of 
		true -> sortNum(N,T,[H|LessL],GreaterL);
		false -> sortNum(N,T,LessL,[H|GreaterL])
	end.

%% Sorting lists
sort([])->[];
sort([H|T])->
	[LL,GL]=sortNum(H,T),
	sort(LL)++[H]++sort(GL).

%% Checking how many times a value occurs in a list:
times(N,L)->times(N,L,[{N,0}]).

times(_,[],Rs)->Rs;
times(N,[N|T],[{N,Times}])->times(N,T,[{N,Times+1}]);
times(N,[_|T],Rs)->times(N,T,Rs).

%% Checking the occurrence of all elements in a lists
timesL(L)->timesL(L,L,[]).

timesL([],_,Rs)->Rs;
timesL([H|T],L,Rs)->timesL(T,L,Rs++times(H,L)).

%% Check if a number is a member of s list  or not, if not, the result is a list containing that number
notMem(N,[])->[N];
notMem(N,[N|_])->[];
notMem(N,[_|T])->notMem(N,T).

%% Removing duplicates in lists
rmDup(L)->rmDup(L,[]).

rmDup([],Rs)->Rs;
rmDup([H|T],Rs)->rmDup(T,Rs++notMem(H,Rs)).


%%%% Required functions %%%%
%% Transforming list elements
double(L)-> double(L,[]).

double([],Rs)->reverse(Rs);
double([H|T], Rs)->double(T, [H*2|Rs]).

%% Filtering lists
evens(L)-> evens(L,[]).

evens([],Rs)->reverse(Rs);
evens([H|T],Rs)->
	case H rem 2 of
		0 -> evens(T, [H|Rs]);
		_ -> evens(T, Rs)
	end.

%% Median of the list of numbers:
med([])->0;
med([N])->N;
med(L)->
	SL=sort(L),
	med(SL,length(SL),(length(SL) div 2),1).

med([H1,H2|_],Len,IMid,IMid)->
	case Len rem 2 of
		1-> H2;
		0-> (H1 + H2)/2
	end;
med([_|T],Len,IMid, I)->med(T,Len,IMid,I+1).

%% Modes of a lists of numbers:
mode([])->[];
mode([A])->[A];
mode(L)->
	CheckedList=timesL(L),
	[{N,Times}|T]=rmDup(CheckedList),
	mode(T,Times,[N]).

mode([],_,Rs)-> Rs;
mode([{N,Times}|T],MaxTimes,Rs)->
	if
		Times<MaxTimes->mode(T,MaxTimes,Rs);
		Times==MaxTimes->mode(T,MaxTimes,Rs++[N]);
		true -> mode(T,Times,[N])
	end.
