(* StackADT3:                                                SWa, 2020-04-15 *)
(* ----------                                                                *)
(* Stack abstract data type - version 3.                                     *)
(* ========================================================================= *)
UNIT StackADT3;

INTERFACE
  TYPE
    StackPtr = ^Stack;
    Stack = RECORD
      max: INTEGER;
      top: INTEGER;
      data: ARRAY [1..1] OF INTEGER;
    END; (* Stack *)

  FUNCTION NewStack(max: INTEGER): StackPtr;
  PROCEDURE DisposeStack(VAR s: StackPtr);
  PROCEDURE Push(s: StackPtr; value: INTEGER);
  FUNCTION Pop(s: StackPtr): INTEGER;
  FUNCTION Empty(s: StackPtr): BOOLEAN;

IMPLEMENTATION
  FUNCTION NewStack(max: INTEGER): StackPtr;
    VAR
      s: StackPtr;
  BEGIN (* NewStack *)
    GetMem(s, (2 + max) * SizeOf(INTEGER));
    s^.max := max;
    s^.top := 0;
    NewStack := s;
  END; (* NewStack *)

  PROCEDURE DisposeStack(VAR s: StackPtr);
  BEGIN (* DisposeStack *)
    FreeMem(s, (2 + s^.max) * SizeOf(INTEGER));
    s := NIL;
  END; (* DisposeStack *)

  PROCEDURE Push(s: StackPtr; value: INTEGER);
  BEGIN (* Push *)
    IF (s^.top = s^.max) THEN BEGIN
      WriteLn('ERROR: stack full');
      HALT;
    END; (* IF *)
    s^.top := s^.top + 1;
    {$R-}
    s^.data[s^.top] := value;
    {$R+}
  END; (* Push *)

  FUNCTION Pop(s: StackPtr): INTEGER;
    VAR
      value: INTEGER;
  BEGIN (* Pop *)
    IF (s^.top = 0) THEN BEGIN
      WriteLn('ERROR: stack empty');
      HALT;
    END; (* IF *)
    {$R-}
    value := s^.data[s^.top];
    {$R+}
    s^.top := s^.top - 1;
    Pop := value;
  END; (* Pop *)

  FUNCTION Empty(s: StackPtr): BOOLEAN;
  BEGIN (* Empty *)
    Empty := (s^.top = 0);
  END; (* Empty *)
END. (* StackADT3 *)


