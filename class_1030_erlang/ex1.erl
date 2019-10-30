% > S=spawn(fun ex:echo/0).
% S!{echo, self(),"hello"}.
% receive X -> X end.
% [spawn(fun ex:echo/0) || _ <- lists:seq(1, 2000)].


% 4> flush().
% 5> S!{stop}.
% * 1: variable 'S' is unbound
% 6> i().
% 7> f(S).
% ok
% self().