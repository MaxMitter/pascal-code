(* SafeArrayStackUnit:                                       SWa, 2020-05-27 *)
(* -------------------                                                       *)
(* A stack which stores its elements in an array and prevents stack over-/   *)
(* underflows.                                                               *)
(* ========================================================================= *)
UNIT SafeArrayStackUnit;

INTERFACE

  USES
    ArrayStackUnit;

  TYPE
    SafeArrayStack = ^SafeArrayStackObj;
    SafeArrayStackObj = OBJECT(ArrayStackObj)
      PUBLIC
        CONSTRUCTOR Init(size: INTEGER);
        DESTRUCTOR Done; VIRTUAL;

        PROCEDURE Push(e: INTEGER); VIRTUAL;
        PROCEDURE Pop(VAR e: INTEGER); VIRTUAL;
    END; (* SafeArrayStackObj *)

    FUNCTION NewSafeArrayStack(size: INTEGER): SafeArrayStack;

IMPLEMENTATION

  CONSTRUCTOR SafeArrayStackObj.Init(size: INTEGER);
  BEGIN (* SafeArrayStackObj.Init *)
    INHERITED Init(size);
  END; (* SafeArrayStackObj.Init*)

  DESTRUCTOR SafeArrayStackObj.Done;
  BEGIN (* SafeArrayStackObj.Done *)
    INHERITED Done;
  END; (* SafeArrayStackObj.Done *)

  PROCEDURE SafeArrayStackObj.Push(e: INTEGER);
  BEGIN (* SafeArrayStackObj.Push *)
    IF (IsFull) THEN BEGIN
      WriteLn('ERROR: Stack is full');
      HALT;
    END; (* IF *)
    INHERITED Push(e);
  END; (* SafeArrayStackObj.Push *)

  PROCEDURE SafeArrayStackObj.Pop(VAR e: INTEGER);
  BEGIN (* SafeArrayStackObj.Pop *)
    IF (IsEmpty) THEN BEGIN
      WriteLn('ERROR: Stack is empty');
      HALT;
    END; (* IF *)
    INHERITED Pop(e);
  END; (* SafeArrayStackObj.Pop *)

  FUNCTION NewSafeArrayStack(size: INTEGER): SafeArrayStack;
    VAR
      a: SafeArrayStack;
  BEGIN (* NewSafeArrayStack *)
    New(a, Init(size));
    NewSafeArrayStack := a;
  END; (* NewSafeArrayStack *)

END. (* SafeArrayStackUnit *)

