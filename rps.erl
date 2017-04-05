-module(rps).
-export([play/1,echo/1,play_two/3,play_two_new/3,rock/1,no_repeat/1,beats/1,enum/1,cycle/1,rand/1,least_freq/1,most_freq/1,rand_combine/1,val/1,tournament/2]).


%
% play one strategy against another, for N moves.
%

play_two(StrategyL,StrategyR,N) ->
    play_two(StrategyL,StrategyR,[],[],N).

play_two_new(StrategyL,StrategyR,M)->
    play_two_new(StrategyL,StrategyR,[],[],M).

% tail recursive loop for play_two/4
% 0 case computes the result of the tournament

% FOR YOU TO DEFINE
% REPLACE THE dummy DEFINITIONS

play_two(_,_,PlaysL,PlaysR,0) ->
   io:format("The total score(s) of Player 1 over Player 2 is: ~p~n",[tournament(PlaysL,PlaysR)]);

play_two(StrategyL,StrategyR,PlaysL,PlaysR,N) ->
    io:format("Player 1: ~p    Player 2: ~p~n",[L=StrategyL(PlaysR),R=StrategyR(PlaysL)]),
    io:format("Result of Player 1 versus Player 2: ~p~n",[result(L,R)]),
    play_two(StrategyL,StrategyR,[L|PlaysL],[R|PlaysR],N-1).

play_two_new(StrategyL,StrategyR,PlaysL,PlaysR,M) when M>0->
    Score=tournament(PlaysL,PlaysR),
    case Score < M andalso Score > -M of
	true->
	    io:format("Player 1: ~p    Player 2: ~p~n",[L=StrategyL(PlaysR),R=StrategyR(PlaysL)]),
	    io:format("Result of Player 1 versus Player 2: ~p~n",[result(L,R)]),
	    play_two_new(StrategyL,StrategyR,[L|PlaysL],[R|PlaysR],M);
	false->
	    case Score==M of 
		true->io:format("Player 1 win~n");
		false->io:format("Player 2 win~n")
	    end
    end.

%
% interactively play against a strategy, provided as argument.
%

play(Strategy) ->
    io:format("Rock - paper - scissors~n"),
    io:format("Play one of rock, paper, scissors, ...~n"),
    io:format("... r, p, s, stop, followed by '.'~n"),
    play(Strategy,[]).

% tail recursive loop for play/1

play(Strategy,Moves) ->
    {ok,P} = io:read("Play: "),
    Play = expand(P),
    case Play of
	stop ->
	    io:format("Stopped~n");
	_    ->
	    Result = result(Play,Strategy(Moves)),
	    io:format("Result: ~p~n",[Result]),
	    play(Strategy,[Play|Moves])
    end.

%
% auxiliary functions
%

% transform shorthand atoms to expanded form
    
expand(r) -> rock;
expand(p) -> paper;		    
expand(s) -> scissors;
expand(X) -> X.

% result of one set of plays

result(rock,rock) -> draw;
result(rock,paper) -> lose;
result(rock,scissors) -> win;
result(paper,rock) -> win;
result(paper,paper) -> draw;
result(paper,scissors) -> lose;
result(scissors,rock) -> lose;
result(scissors,paper) -> win;
result(scissors,scissors) -> draw.

% result of a tournament

tournament(PlaysL,PlaysR) ->
    lists:sum(
      lists:map(fun outcome/1,
		lists:zipwith(fun result/2,PlaysL,PlaysR))).

outcome(win)  ->  1;
outcome(lose) -> -1;
outcome(draw) ->  0.

% transform 0, 1, 2 to rock, paper, scissors and vice versa.

enum(0) ->
    rock;
enum(1) ->
    paper;
enum(2) ->
    scissors.

val(rock) ->
    0;
val(paper) ->
    1;
val(scissors) ->
    2.

% give the play which the argument beats.

beats(rock) ->
    scissors;
beats(paper) ->
    rock;
beats(scissors) ->
    paper.

%
% strategies.
%
echo([]) ->
     paper;
echo([Last|_]) ->
    Last.

rock(_) ->
    rock.



% FOR YOU TO DEFINE
% REPLACE THE dummy DEFINITIONS

no_repeat([]) ->
    paper;
no_repeat([X|_]) ->
    N=random:uniform(2),
    [H,T]=[paper,rock,scissors]--[X],
    case N of
	1 -> H;
        _ -> T
    end.

cycle([]) ->
    rock;
cycle([X|_])->
   case X of
	rock->paper;
	paper->scissors;
	scissors->rock
    end.

rand(_) ->
    enum(random:uniform(3)-1).

count([],Rs)->Rs;
count([H|T],[R,P,S])->
    case H of
	rock->count(T,[R+1,P,S]);
	paper->count(T,[R,P+1,S]);
	scissors->count(T,[R,P,S+1])
    end.

most([R,P,S]=L)->
    case lists:max(L) of
	R->rock;
	P->paper;
	S->scissors
    end.

least([R,P,S]=L)->
    case lists:min(L) of
	R->rock;
	P->paper;
	S->scissors
    end.

least_freq([])->
    rock;
least_freq(L)->
    least(count(L,[0,0,0])).

most_freq([])->
    rock;
most_freq(L)->
    most(count(L,[0,0,0])).

rand_combine([])->fun rock/1;
rand_combine(L)->
    N=random:uniform(length(L)),
    element(N,list_to_tuple(L)).

%selected_combine([])->fun echo/1;
%selected_combine(L)->selected_combine(L)
