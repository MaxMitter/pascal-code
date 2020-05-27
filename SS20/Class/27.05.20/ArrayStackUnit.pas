(* ArrayStackUnit:                                            MM, 2020-05-27 *)
(* ------                                                                    *)
(* A stack which stores its elemts in an array                               *)
(* ========================================================================= *)

UNIT ArrayStackUnit;

INTERFACE

USES StackUnit;

  TYPE
    IntArray = ARRAY [0..0] OF INTEGER;

    ArrayStack = ^ArrayStackObj;
    ArrayStackObj = OBJECT(StackObj)
      PUBLIC
        CONSTRUCTOR Init(size: INTEGER);
        DESTRUCTOR Done;

        PROCEDURE Push(e: INTEGER); VIRTUAL;
        PROCEDURE Pop(VAR e: INTEGER); VIRTUAL;
        FUNCTION IsEmpty: BOOLEAN; VIRTUAL;
        FUNCTION IsFull: BOOLEAN; VIRTUAL;
        //FUNCTION NewArrayStack(size: INTEGER): ArrayStack;
      PRIVATE
        size: INTEGER;
        top: INTEGER;
        data: ^IntArray;
    END; (* ArrayStackObj *)

    FUNCTION NewArrayStack(size: INTEGER): ArrayStack;
IMPLEMENTATION

  CONSTRUCTOR ArrayStackObj.Init(size: INTEGER);
    BEGIN
      SELF.size := size;
      SELF.top := 0;
      GetMem(SELF.data, size * SizeOf(INTEGER));
  END;

  DESTRUCTOR ArrayStackObj.Done;
    BEGIN
      FreeMem(SELF.data, SELF.size * SizeOf(INTEGER));
      INHERITED Done;
  END;

  PROCEDURE ArrayStackObj.Push(e: INTEGER);
    BEGIN
      {$R-}data^[top] := e;{$R+}
      Inc(top);
  END;

  PROCEDURE ArrayStackObj.Pop(VAR e: INTEGER);
    BEGIN
      Dec(top);
      {$R-} e := data^[top]; {$R+}
  END;

  FUNCTION ArrayStackObj.IsEmpty: BOOLEAN;
    BEGIN (* ArrayStackObj.IsEmpty *)
      IsEmpty := top = 0;
  END; (* ArrayStackObj.IsEmpty *)

  FUNCTION ArrayStackObj.IsFull: BOOLEAN;
    BEGIN (* ArrayStackObj.IsEmpty *)
      IsFull := top = size;
  END; (* ArrayStackObj.IsEmpty *)

  FUNCTION NewArrayStack(size: INTEGER): ArrayStack;
    VAR a: ArrayStack;
    BEGIN (* NewArrayStack *)
      New(a, Init(size));
      NewArrayStack := a;
  END; (* NewArrayStack *)
  
END. (* ArrayStackUnit *)