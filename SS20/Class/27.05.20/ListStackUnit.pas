(* ListStackUnit:                                             MM, 2020-05-27 *)
(* ------                                                                    *)
(* A stack which stores elements in a single linked list                     *)
(* ========================================================================= *)

UNIT ListStackUnit;

INTERFACE

USES StackUnit;

  TYPE

    List = ^Node;
    NodePtr = ^Node;
    Node = RECORD
      value: INTEGER;
      next: NodePtr;
    END;

    ListStack = ^ListStackObj;
    ListStackObj = OBJECT(StackObj)
      PUBLIC
        CONSTRUCTOR Init;
        DESTRUCTOR Done;

        PROCEDURE Push(e: INTEGER); VIRTUAL;
        PROCEDURE Pop(VAR e: INTEGER); VIRTUAL;
        FUNCTION IsEmpty: BOOLEAN; VIRTUAL;
      PRIVATE
        data: List;
    END; (* ListStackObj *)

    FUNCTION NewListStack(size: INTEGER): ListStack;
IMPLEMENTATION

  FUNCTION NewNode(value: INTEGER): NodePtr;
    VAR n: NodePtr;
    BEGIN (* NewNode *)
      New(n);
      n^.next := NIL;
      n^.value := value;
      NewNode := n;
  END; (* NewNode *)

  CONSTRUCTOR ListStackObj.Init;
    BEGIN
      SELF.data := NIL;
  END;

  DESTRUCTOR ListStackObj.Done;
    VAR n: NodePtr;
    BEGIN
      WHILE (data <> NIL) DO BEGIN
        n := data;
        data := data^.next;
        Dispose(n);
      END; (* WHILE *)

      INHERITED Done;
  END;

  PROCEDURE ListStackObj.Push(e: INTEGER);
    VAR n: NodePtr;
    BEGIN
      n := NewNode(e);
      n^.next := data;
      data := n;
  END;

  PROCEDURE ListStackObj.Pop(VAR e: INTEGER);
    VAR n: NodePtr;
    BEGIN
      n := data;
      data := data^.next;
      e := n^.value;
      Dispose(n);
  END;

  FUNCTION ListStackObj.IsEmpty: BOOLEAN;
    BEGIN (* ArrayStackObj.IsEmpty *)
      IsEmpty := data = NIL;
  END; (* ArrayStackObj.IsEmpty *)

  FUNCTION NewListStack(size: INTEGER): ListStack;
    BEGIN (* NewListStack *)
      
  END; (* NewListStack *)
  
END. (* ListStackUnit *)