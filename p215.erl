-module(p215).
-export([palindrome/1]).

rmNlc([],Rs)->Rs;
rmNlc([H|T],Rs)->
	if
 		H>64,H<91->rmNlc(T,[H+32|Rs]);
		H>96,H<123->rmNlc(T,[H|Rs]);
		true->rmNlc(T,Rs)
	end.

palindrome(L)->
	Backward=rmNlc(L,[]),
	Forward=lists:reverse(Backward),
	Backward==Forward.
