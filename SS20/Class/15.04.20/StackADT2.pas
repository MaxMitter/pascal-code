(* StackADT2:                                                SWa, 2020-04-15 *)
(* ----------                                                                *)
(* Stack abstract data type - version 2.                                     *)
(* ========================================================================= *)
UNIT StackADT2;

INTERFACE
  CONST
    MAX = 100;

  TYPE
    StackPtr = ^Stack;
    Stack = RECORD
      top: INTEGER;
      data: ARRAY [1..MAX] OF INTEGER;
    END; (* Stack *)

  FUNCTION NewStack: StackPtr;
  PROCEDURE DisposeStack(VAR s: StackPtr);
  PROCEDURE Push(s: StackPtr; value: INTEGER);
  FUNCTION Pop(s: StackPtr): INTEGER;
  FUNCTION Empty(s: StackPtr): BOOLEAN;

IMPLEMENTATION
  FUNCTION NewStack: StackPtr;
    VAR
      s: StackPtr;
  BEGIN (* NewStack *)
    New(s);
    s^.top := 0;
    NewStack := s;
  END; (* NewStack *)

  PROCEDURE DisposeStack(VAR s: StackPtr);
  BEGIN (* DisposeStack *)
    Dispose(s);
    s := NIL;
  END; (* DisposeStack *)

  PROCEDURE Push(s: StackPtr; value: INTEGER);
  BEGIN (* Push *)
    IF (s^.top = MAX) THEN BEGIN
      WriteLn('ERROR: stack full');
      HALT;
    END; (* IF *)
    s^.top := s^.top + 1;
    s^.data[s^.top] := value;
  END; (* Push *)

  FUNCTION Pop(s: StackPtr): INTEGER;
    VAR
      value: INTEGER;
  BEGIN (* Pop *)
    IF (s^.top = 0) THEN BEGIN
      WriteLn('ERROR: stack empty');
      HALT;
    END; (* IF *)
    value := s^.data[s^.top];
    s^.top := s^.top - 1;
    Pop := value;
  END; (* Pop *)

  FUNCTION Empty(s: StackPtr): BOOLEAN;
  BEGIN (* Empty *)
    Empty := (s^.top = 0);
  END; (* Empty *)
END. (* StackADT2 *)


