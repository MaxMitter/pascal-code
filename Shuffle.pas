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
      end; (* WHILE *)
      WriteLn('-|')
    END; (* WRITELIST *)

  PROCEDURE Prepend(var l: List; n: ListNodePtr);
    BEGIN
      n^.next := l;
      l := n;
    END;

  PROCEDURE Append(var l: List; n: ListNodePtr);
    var cur: ListNodePtr;
    BEGIN
      if l = nil then
        Prepend(l, n)
      else begin
        cur := l;
        while cur^.next <> NIL do
          cur := cur^.next;
        cur^.next := n;
      end; (* WHILE *)
    END; (* APPEND *)

  FUNCTION CopyNode(n: ListNodePtr): ListNodePtr;
    var node: ListNodePtr;
    BEGIN
      node := NewNode(n^.val);
      node^.next := NIL;
      CopyNode := node;
    END;

  PROCEDURE ShuffleList(var l: List);
    var l1, l2: List;
        cur: ListNodePtr;
        i: integer;
    BEGIN
      i := 1;
      InitList(l1);
      InitList(l2);
      cur := l;
      l1 := cur;

      while (i < (n/2)) AND (cur^.next <> NIL) do begin
        cur := cur^.next;
        Inc(i);
      end; (* WHILE *)

      l2 := cur^.next;
      cur^.next := NIL;

      l := NIL;
      
      for i := 1 to n do begin
        if i = 1 then begin
          l := l2;
          cur := l;
          l2 := l2^.next;
        end else if i mod 2 = 0 then begin
          cur^.next := l1;
          cur := l1;
          l1 := l1^.next;
        end else if i mod 2 <> 0 then begin
          cur^.next := l2;
          cur := l2;
          if l2^.next <> NIL then
            l2 := l2^.next;
        end; (* IF *)
      end; (* FOR *)
    END; (* SHUFFLELIST *)

var i: integer;
    l: List;
BEGIN
  InitList(l);
  FOR i := 1 to n do begin
    Append(l, NewNode(i));
  end; (* FOR *)

  WriteList(l);
  ShuffleList(l);
  WriteList(l);
  ShuffleList(l);
  WriteList(l);
END.