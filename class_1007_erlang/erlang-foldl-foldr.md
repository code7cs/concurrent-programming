
# foldr vs. foldl

---

The recursion for `foldr(f,x, ys)` where `ys = [y1,y2,...,yk]` looks like

`f y1 (f y2 (... (f yk x) ...))`

whereas the recursion for `foldl(f, x, ys)` looks like

`f (... (f (f x y1) y2) ...) yk`

An important difference here is that if the result of f x y can be computed using only the value of x, then foldr doesn't' need to examine the entire list.
**For example:**
`foldr (&&) False (repeat False)`
returns False

whereas
`foldl (&&) False (repeat False)`
never terminates. (Note: repeat False creates an infinite list where every element is False.)

On the other hand, foldl' is tail recursive and strict. **If you know that you'll have to traverse the whole list no matter what (e.g., summing the numbers in a list), then foldl' is more space- (and probably time-) efficient than foldr.**

```
> P = fun(A, AccIn) -> io:format("~p ", [A]), AccIn end.
#Fun<erl_eval.12.118419387>
> lists:foldl(P, void, [1,2,3]).
1 2 3 void
> lists:foldr(P, void, [1,2,3]).
3 2 1 void
```
