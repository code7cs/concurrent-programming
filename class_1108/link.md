<!--
 * @Author: Hanfan Wang
 * @Date: 2019-11-08 13:12:05
 * @LastEditTime: 2019-11-09 13:25:31
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /concurrent-programming/class_1108/link.md
 -->
Eshell V8.3  (abort with ^G)
1> spawn_link(fun()->exit(normal) end).
<0.58.0>
2> self().
<0.56.0>
3> spawn_link(fun()->exit(normal) end).
<0.61.0>
4> self().                             
<0.56.0>
5> spawn_link(fun()->exit(oops) end).  
** exception exit: oops
6> self().                           
<0.65.0>
7> process_flag(trap_exit, true).
false
8> spawn_link(fun()->exit(oops) end).
<0.69.0>
9> self().                           
<0.65.0>
10> flush().
Shell got {'EXIT',<0.69.0>,oops}
ok
11> 