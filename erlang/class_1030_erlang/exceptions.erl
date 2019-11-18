-module(exceptions).

-compile(export_all).

throws(F) ->
    try F() of
      _ -> ok
    catch
      Throw -> {throw, caught, Throw}
    end.

% 1> c(exceptions).
% {ok,exceptions}
% 2> exceptions :throws(fun ()-> throw(thrown) end).
% {throw,caught,thrown}
% 3> exceptions :throws(fun ()-> erlang:error(pang) end).
% ** exception error: pang
%      in function  shell:apply_fun/3 (shell.erl, line 899)
%      in call from exceptions:throws/1 (exceptions.erl, line 6)

talk() -> " blah blah".
sword (1) -> throw(slice);
sword (2) -> erlang:error(cut_arm);
sword (3) -> exit(cut_leg);
sword (4) -> throw(punch);
sword (5) -> exit( cross_bridge ).

black_knight (Attack) when is_function (Attack , 0) ->
    try Attack () of
        _ -> " None shall pass."
    catch
        throw:slice -> " It is but a scratch." ;
        error:cut_arm -> " I’ve had worse." ;
        exit:cut_leg -> " Come on you pansy!" ;
        _:_ -> " Just a flesh wound."
end.

% 5> c(exceptions).                                                                                                                                              {ok,exceptions}
% 6> exceptions:talk().
% " blah blah"
% 7> exceptions : black_knight (fun exceptions:talk /0).
% " None shall pass."
% 8> exceptions : black_knight (fun () -> exceptions:sword (1) end).
% " It is but a scratch."
% 9> exceptions : black_knight (fun () -> exceptions:sword (2) end).
% [32,73,8217,118,101,32,104,97,100,32,119,111,114,115,101,46]
% 11> exceptions : black_knight (fun () -> exceptions:sword (3) end).
% " Come on you pansy!"
% 12> exceptions : black_knight (fun () -> exceptions:sword (4) end).
% " Just a flesh wound."
% 13> exceptions : black_knight (fun () -> exceptions:sword (5) end).
% " Just a flesh wound."
% 14> exceptions : black_knight (fun () -> exceptions:sword (6) end).
% " Just a flesh wound."


% 1> catch throw(whoa).
% whoa
% 2> catch exit(die).
% {'EXIT',die}
% 3> catch 1/0.
% {'EXIT',{badarith,[{erlang,'/',[1,0],[]},
%                    {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,674}]},
%                    {erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
%                    {shell,exprs,7,[{file,"shell.erl"},{line,686}]},
%                    {shell,eval_exprs,7,[{file,"shell.erl"},{line,641}]},
%                    {shell,eval_loop,3,[{file,"shell.erl"},{line,626}]}]}}
% 4> catch 2+2.
% 4
% 5>