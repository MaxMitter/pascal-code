UNIT SingleLinkedIntListUnit;

INTERFACE

TYPE ListNodePtr = ^ListNode;
     ListNode = RECORD
                val: integer;
                next: ListNodePtr;
                END;
     List = ListNodePtr;

  PROCEDURE Prepand(var l: List; n: ListNodePtr);

  PROCEDURE Append(var l: List; n: ListNodePtr);
  
  PROCEDURE InitList(var l: List);

  FUNCTION NumNodes(l: List): longint;

  FUNCTION NewNode(val: integer): ListNodePtr;

  PROCEDURE WriteList(l: List);
IMPLEMENTATION

  PROCEDURE InitList(var l: List);
  BEGIN (* InitList *)
    l := nil;
  END; (* InitList *)

  PROCEDURE Append(var l: List; n: ListNodePtr);
    var cur: ListNodePtr;
  BEGIN (* Append *)
    if l = nil then begin
      Prepand(l, n);
    end else begin
      cur := l;
      while cur^.next <> nil do
        cur := cur^.next;

      cur^.next := n;
    end;
  END; (* Append *)

  PROCEDURE WriteList(l: List);
  BEGIN (* WriteList *)
    while l <> nil do begin
      Write(' -> ');
      Write(l^.val);
      l := l^.next;
    end;
    Write(' -| ');
  END; (* WriteList *)

  FUNCTION NumNodes(l: List): longint;
    var count: longint;
  BEGIN (* NumNode *)
    count := 0;
    while l <> nil do begin
      Inc(count);
      l := l^.next;
    end;
    NumNodes := count;
  END; (* NumNode *)

  PROCEDURE Prepand(var l: List; n: ListNodePtr);
  BEGIN (* Prepand *)
    n^.next := l;
    l := n;
  END; (* Prepand *)

  FUNCTION NewNode(val: integer): ListNodePtr;
    var node: ListNodePtr;
  BEGIN (* NewNode *)
    New(node);
    node^.val := val;
    node^.next := NIL;

    NewNode := node;
  END; (* NewNode *)

BEGIN

END.