-module(p38).
-export([result/2, tournament/2]).

beat(Type)->
	case Type of
		rock->paper;
		paper->scissors;
		scissors->rock;
		_->invalid
	end.

%lose(Type)->
%	case Type of
%		rock->scissors;
%		scissors->paper;
%		paper->rock;
%		_->invalid
%	end.

result(First,Second)->
	case beat(First) of 
		invalid->invalid;
		Second->-1;
		_->
			case beat(Second) of 
				invalid->invalid;
				First->1;
				_->0
			end
	end.

tournament(P1,P2)->lists:foldr(fun(X,Y)->X+Y end,0,p35:zip_with(fun result/2, P1,P2)).
