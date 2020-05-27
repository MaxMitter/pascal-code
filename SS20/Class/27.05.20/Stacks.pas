(* Stacks:                                                    MM, 2020-05-27 *)
(* ------                                                                    *)
(* Fun with stacks and OOP                                                   *)
(* ========================================================================= *)

PROGRAM Stacks;

  USES ArrayStackUnit, StackUnit;

  VAR s: Stack;
      i: INTEGER;

BEGIN (* Stacks *)
  s := NewArrayStack(10);

  FOR i := 1 TO 10 DO BEGIN
    s^.Push(i);
  END; (* FOR *)

  WHILE (NOT s^.IsEmpty) DO BEGIN
    s^.Pop(i);
    WriteLn(i);
  END; (* WHILE *)

  Dispose(s, Done);

END. (* Stacks *)