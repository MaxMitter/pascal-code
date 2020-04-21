(* StackTest:                                                SWa, 2020-04-15 *)
(* ----------                                                                *)
(* Test programm for Stack ADS and ADT.                                      *)
(* ========================================================================= *)
PROGRAM StackTest;
  USES
    StackADT4;

  VAR
    i: INTEGER;
    s1, s2: Stack;

BEGIN (* StackTest *)
  s1 := NewStack(10);
  FOR i := 1 TO 5 DO BEGIN
    Push(s1, i);
  END; (* FOR *)

  WHILE (NOT Empty(s1)) DO BEGIN
    WriteLn(Pop(s1));
  END; (* WHILE *)
  WriteLn;

  s2 := NewStack(15);
  FOR i := 1 TO 7 DO BEGIN
    Push(s2, i);
  END; (* FOR *)

  WHILE (NOT Empty(s2)) DO BEGIN
    WriteLn(Pop(s2));
  END; (* WHILE *)

  DisposeStack(s1);
  DisposeStack(s2);
END. (* StackTest *)

