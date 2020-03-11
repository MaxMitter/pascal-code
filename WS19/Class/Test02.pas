PROGRAM Test;

TYPE ListNodePtr = ^ListNode;
     ListNode = RECORD
                val: integer;
                next: ListNodePtr;
                END;
     List = ListNodePtr;

PROCEDURE DeleteAt(var l: List; at: integer);
  var curr, toDel: ListNodePtr;
      count: integer;
BEGIN (* DeleteAt *)
  count := 1;
  curr := l;

  if curr <> NIL then begin
    while (curr^.next <> NIL) AND (count < at -1) do begin
      curr := curr^.next;
      count := count + 1;
    end;

    if(count <> at-1) then begin
      toDel := curr^.next;
      if (curr^.next^.next <> NIL) then
        curr^.next := curr^.next^.next
      else
        curr^.next := NIL;

      Dispose(toDel);
    end;
  end;
END; (* DeleteAt *)

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

PROCEDURE WriteList(l: List);
  BEGIN (* WriteList *)
    while l <> nil do begin
      Write(' -> ');
      Write(l^.val);
      l := l^.next;
    end;
    WriteLn(' -| ');
  END; (* WriteList *)

var l: List;

BEGIN
  l := NIL;
  Prepand(l, NewNode(7));
  Prepand(l, NewNode(6));
  Prepand(l, NewNode(5));
  Prepand(l, NewNode(4));
  Prepand(l, NewNode(3));
  Prepand(l, NewNode(2));
  Prepand(l, NewNode(1));
  WriteList(l);

  DeleteAt(l, 5);
  DeleteAt(l, 1);
  DeleteAt(l, 6);
  //DeleteAt(l, 9);

  WriteList(l);
END.