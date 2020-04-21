(* StackADT4:                                                SWa, 2020-04-15 *)
(* ----------                                                                *)
(* Stack abstract data type - version 4.                                     *)
(* ========================================================================= *)
UNIT StackADT4;

INTERFACE
  TYPE
    Stack = POINTER;

  FUNCTION NewStack(max: INTEGER): Stack;
  PROCEDURE DisposeStack(VAR s: Stack);
  PROCEDURE Push(s: Stack; value: INTEGER);
  FUNCTION Pop(s: Stack): INTEGER;
  FUNCTION Empty(s: Stack): BOOLEAN;

IMPLEMENTATION
  TYPE
    StackPtr = ^StackRec;
    StackRec = RECORD
      max: INTEGER;
      top: INTEGER;
      data: ARRAY [1..1] OF INTEGER;
    END; (* StackRec *)

  FUNCTION NewStack(max: INTEGER): Stack;
    VAR
      s: StackPtr;
  BEGIN (* NewStack *)
    GetMem(s, (2 + max) * SizeOf(INTEGER));
    s^.max := max;
    s^.top := 0;
    NewStack := s;
  END; (* NewStack *)

  PROCEDURE DisposeStack(VAR s: Stack);
  BEGIN (* DisposeStack *)
    FreeMem(s, (2 + StackPtr(s)^.max) * SizeOf(INTEGER));
    s := NIL;
  END; (* DisposeStack *)

  PROCEDURE Push(s: Stack; value: INTEGER);
  BEGIN (* Push *)
    IF (StackPtr(s)^.top = StackPtr(s)^.max) THEN BEGIN
      WriteLn('ERROR: stack full');
      HALT;
    END; (* IF *)
    StackPtr(s)^.top := StackPtr(s)^.top + 1;
    {$R-}
    StackPtr(s)^.data[StackPtr(s)^.top] := value;
    {$R+}
  END; (* Push *)

  FUNCTION Pop(s: Stack): INTEGER;
    VAR
      value: INTEGER;
  BEGIN (* Pop *)
    IF (StackPtr(s)^.top = 0) THEN BEGIN
      WriteLn('ERROR: stack empty');
      HALT;
    END; (* IF *)
    {$R-}
    value := StackPtr(s)^.data[StackPtr(s)^.top];
    {$R+}
    StackPtr(s)^.top := StackPtr(s)^.top - 1;
    Pop := value;
  END; (* Pop *)

  FUNCTION Empty(s: Stack): BOOLEAN;
  BEGIN (* Empty *)
    Empty := (StackPtr(s)^.top = 0);
  END; (* Empty *)
END. (* StackADT4 *)


