(* StackADS:                                                 SWa, 2020-04-15 *)
(* ---------                                                                 *)
(* Stack abstract data structure.                                            *)
(* ========================================================================= *)
UNIT StackADS;

INTERFACE

  PROCEDURE Push(value: INTEGER);
  FUNCTION Pop: INTEGER;
  FUNCTION Empty: BOOLEAN;

IMPLEMENTATION
  CONST
    MAX = 100;

  VAR
    top: INTEGER;
    data: ARRAY [1..MAX] OF INTEGER;

  PROCEDURE Push(value: INTEGER);
  BEGIN (* Push *)
    IF (top = MAX) THEN BEGIN
      WriteLn('ERROR: stack full');
      HALT;
    END; (* IF *)
    top := top + 1;
    data[top] := value;
  END; (* Push *)

  FUNCTION Pop: INTEGER;
    VAR
      value: INTEGER;
  BEGIN (* Pop *)
    IF (top = 0) THEN BEGIN
      WriteLn('ERROR: stack empty');
      HALT;
    END; (* IF *)
    value := data[top];
    top := top - 1;
    Pop := value;
  END; (* Pop *)

  FUNCTION Empty: BOOLEAN;
  BEGIN (* Empty *)
    Empty := (top = 0);
  END; (* Empty *)

BEGIN (* StackADS *)
  top := 0;
END. (* StackADS *)


