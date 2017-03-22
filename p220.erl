-module(p220).
-export([split/1, splitAll/3, indexing/1]).

%% remove blank elements of the list of splited list (because my solution for spliting texting string remains some [] in the result)
rm([],Rs)->Rs;
rm([H|T],Rs) when H=/=[]->rm(T,[H|Rs]);
rm([_|T],Rs)->rm(T,Rs).

%% split the texting strings into the list of words and uncapitalise them
split(L)->split(L,[[]]).

split([],Rs)->rm(Rs,[]);
split([H|T],[[]])->
        if      H>=$A, H=<$Z->split(T,[[H+32]]);
		H>=$a, H=<$z->split(T,[[H]]);
                true->split(T,[[]])
        end;
split([H|T],[RH|RT])->
	if 	H>=$A, H=<$Z->split(T,[RH++[H+32]|RT]);
		H>=$a, H=<$z->split(T,[RH++[H]|RT]);
		true->split(T,[[]]++[RH|RT])
	end.

%% split all texting string of a file
splitAll([],Rs,_)->Rs;
splitAll([H|T],Rs,I)->splitAll(T,Rs++[{I,split(H)}],I+1).

%% check whether a word in appears in a line or not, if it appears, add the line into the result
checkAppearance(_,{_,[]}, Rs)->Rs;
checkAppearance(W,{Line,[W|_]},{W,L})->{W,L++[Line]};
checkAppearance(W,{Line,[_|Remaining]},Rs)->checkAppearance(W,{Line,Remaining},Rs).

%% check whether a we have checked a word before or not
checkIfChecked(_,[])->false;
checkIfChecked(W,[{W,_}|_])->true;
checkIfChecked(W,[_|Remaining])->checkIfChecked(W,Remaining).

%% check a word in a line whether it appear in other lines
checkWordAllLines(_,[],Rs)->Rs;
checkWordAllLines(W,[H|T],Rs)->checkWordAllLines(W,T,checkAppearance(W,H,Rs)).

%% check each word in a line
checkAllWords({_,[]},_,Rs)->Rs;
checkAllWords({Line,[W|Tail]},ListOfLines,Rs)->
	case checkIfChecked(W,Rs) of 
		false->checkAllWords({Line,Tail},ListOfLines,Rs++[checkWordAllLines(W,ListOfLines,{W,[Line]})]);
		true->checkAllWords({Line,Tail},ListOfLines,Rs)
	end.

%% sort words in lexicographic order
sort([])->[];
sort([{PivotWord,Lines}|Remaining])->
	sort([X||X={Word,_}<-Remaining,Word=<PivotWord])++[{PivotWord,Lines}]++sort([X||X={Word,_}<-Remaining,Word>PivotWord]).


%% check of all lines
checkAllLines([],Rs)->Rs;
checkAllLines([FirstLine|Tail],Rs)->checkAllLines(Tail,Rs++checkAllWords(FirstLine,Tail,[])).

% check mem
mem(_,[])->false;
mem({W,_},[{W,_}|_])->true;
mem(Check,[_|Remaining])->mem(Check,Remaining).

%% remove duplicates
rmdup([],Rs)->Rs;
rmdup([H|T],Rs)->
	case mem(H,T) of 
		true->rmdup(T,Rs);
		false->rmdup(T,Rs++[H])
	end.

%% indexing a file
indexing(FileName)->
	Contents=index:get_file_contents(FileName),
	ListOfLines=splitAll(Contents,[],1),
	rmdup(sort(checkAllLines(ListOfLines,[])),[]).

%indexing(Name)->
%    Contents=get_file_contents(Name),  
