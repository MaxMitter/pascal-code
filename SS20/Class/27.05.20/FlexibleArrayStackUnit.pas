(* FlexibleArrayStackUnit:                                   SWa, 2020-05-27 *)
(* -----------------------                                                   *)
(* A stack which stores its elements in an array and grows automatically.    *)
(* ========================================================================= *)
UNIT FlexibleArrayStackUnit;

INTERFACE

  USES
    ArrayStackUnit;

  TYPE
    FlexibleArrayStack = ^FlexibleArrayStackObj;
    FlexibleArrayStackObj = OBJECT(ArrayStackObj)
      PUBLIC
        CONSTRUCTOR Init;
        DESTRUCTOR Done; VIRTUAL;

        PROCEDURE Push(e: INTEGER); VIRTUAL;
        PROCEDURE Pop(VAR e: INTEGER); VIRTUAL;
        FUNCTION IsFull: BOOLEAN; VIRTUAL;
    END; (* FlexibleArrayStackObj *)

    FUNCTION NewFlexibleArrayStack: FlexibleArrayStack;

IMPLEMENTATION

  CONST
    DEFAULT_SIZE = 10;

  CONSTRUCTOR FlexibleArrayStackObj.Init;
  BEGIN (* FlexibleArrayStackObj.Init *)
    INHERITED Init(DEFAULT_SIZE);
  END; (* FlexibleArrayStackObj.Init*)

  DESTRUCTOR FlexibleArrayStackObj.Done;
  BEGIN (* FlexibleArrayStackObj.Done *)
    INHERITED Done;
  END; (* FlexibleArrayStackObj.Done *)

  PROCEDURE FlexibleArrayStackObj.Push(e: INTEGER);
    VAR
      newdata: ^IntArray;
      i: INTEGER;
  BEGIN (* FlexibleArrayStackObj.Push *)
    IF (INHERITED IsFull) THEN BEGIN
      GetMem(newdata, size * 2 * SizeOf(INTEGER));
      FOR i := 0 TO size - 1 DO BEGIN
        {$R-}newdata^[i] := data^[i];{$R+}
      END; (* FOR *)
      FreeMem(data, size * SizeOf(INTEGER));
      data := newdata;
      size := size * 2;
    END; (* IF *)
    INHERITED Push(e);
  END; (* FlexibleArrayStackObj.Push *)

  PROCEDURE FlexibleArrayStackObj.Pop(VAR e: INTEGER);
  BEGIN (* FlexibleArrayStackObj.Pop *)
    IF (IsEmpty) THEN BEGIN
      WriteLn('ERROR: Stack is empty');
      HALT;
    END; (* IF *)
    INHERITED Pop(e);
  END; (* FlexibleArrayStackObj.Pop *)

  FUNCTION FlexibleArrayStackObj.IsFull: BOOLEAN;
  BEGIN (* FlexibleArrayStackObj.IsFull *)
    IsFull := FALSE;
  END; (* FlexibleArrayStackObj.IsFull *)

  FUNCTION NewFlexibleArrayStack: FlexibleArrayStack;
    VAR
      a: FlexibleArrayStack;
  BEGIN (* NewFlexibleArrayStack *)
    New(a, Init);
    NewFlexibleArrayStack := a;
  END; (* NewFlexibleArrayStack *)

END. (* FlexibleArrayStackUnit *)

