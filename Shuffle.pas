PROGRAM Shuffle;

  const n = 10;

  type ListNodePtr = ^ListNode;
      ListNode = record
                  val: integer;
                  next: ListNodePtr;
                  end;
      List = ListNodePtr;

  PROCEDURE InitList(var l: List);
    BEGIN
      l := NIL;
    END;

  FUNCTION NewNode(x: integer): ListNodePtr;
    var node: ListNodePtr;
    BEGIN
      New(node);
      node^.val := x;
      node^.next := NIL;

      NewNode := node;
    END;

  PROCEDURE WriteList(l: List);
    BEGIN
      while l <> nil do begin
        Write('->');
        Write(l^.val);
        l := l^.next;
      end;
      Write('-|')
    END;

BEGIN

END.