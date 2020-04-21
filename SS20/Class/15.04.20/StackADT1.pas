(* StackADT1:                                                SWa, 2020-04-15 *)
(* ----------                                                                *)
(* Stack abstract data type - version 1.                                     *)
(* ========================================================================= *)
UNIT StackADT1;

INTERFACE
  CONST
    MAX = 100;

  TYPE
    Stack = RECORD
      top: INTEGER;
      data: ARRAY [1..MAX] OF INTEGER;
    END; (* Stack *)

  FUNCTION NewStack: Stack;
  PROCEDURE Push(VAR s: Stack; value: INTEGER);
  FUNCTION Pop(VAR s: Stack): INTEGER;
  FUNCTION Empty(s: Stack): BOOLEAN;

IMPLEMENTATION
  FUNCTION NewStack: Stack;
    VAR
      s: Stack;
  BEGIN (* NewStack *)
    s.top := 0;
    NewStack := s;
  END; (* NewStack *)

  PROCEDURE Push(VAR s: Stack; value: INTEGER);
  BEGIN (* Push *)
    IF (s.top = MAX) THEN BEGIN
      WriteLn('ERROR: stack full');
      HALT;
    END; (* IF *)
    s.top := s.top + 1;
    s.data[s.top] := value;
  END; (* Push *)

  FUNCTION Pop(VAR s: Stack): INTEGER;
    VAR
      value: INTEGER;
  BEGIN (* Pop *)
    IF (s.top = 0) THEN BEGIN
      WriteLn('ERROR: stack empty');
      HALT;
    END; (* IF *)
    value := s.data[s.top];
    s.top := s.top - 1;
    Pop := value;
  END; (* Pop *)

  FUNCTION Empty(s: Stack): BOOLEAN;
  BEGIN (* Empty *)
    Empty := (s.top = 0);
  END; (* Empty *)
END. (* StackADT1 *)


