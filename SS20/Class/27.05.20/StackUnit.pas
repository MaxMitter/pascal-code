(* StackUnit:                                                 MM, 2020-05-27 *)
(* ------                                                                    *)
(* A simple stack.                                                           *)
(* ========================================================================= *)

UNIT StackUnit;

INTERFACE

  TYPE
    Stack = ^StackObj;
    StackObj = OBJECT
      DESTRUCTOR Done; VIRTUAL;

      PROCEDURE Push(e: INTEGER); VIRTUAL;
      PROCEDURE Pop(VAR e: INTEGER); VIRTUAL;
      FUNCTION IsEmpty: BOOLEAN; VIRTUAL;
    END; (* StackObj *)

IMPLEMENTATION

  DESTRUCTOR StackObj.Done;
    BEGIN
  END;

  PROCEDURE StackObj.Push(e: INTEGER);
    BEGIN
      WriteLn('ERROR: StackObj.Push not implemented to simulate abstract base class.');
      HALT;
  END;

  PROCEDURE StackObj.Pop(VAR e: INTEGER);
    BEGIN
      WriteLn('ERROR: StackObj.Pop not implemented to simulate abstract base class.');
      HALT;
  END;

  FUNCTION StackObj.IsEmpty: BOOLEAN;
    BEGIN (* StackObj.IsEmpty *)
      WriteLn('ERROR: StackObj.IsEmpty not implemented to simulate abstract base class.');
      HALT;
  END; (* StackObj.IsEmpty *)

BEGIN (* StackUnit *)
  
END. (* StackUnit *)