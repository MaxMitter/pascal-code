UNIT DoubleLinkedListUnit;

INTERFACE

type
    NodePtr = ^Node;
    Node = Record
              prev: NodePtr;
              val: integer;
              next: NodePtr;
              end;
    List = Record
                first, last: NodePtr;
                end;

  PROCEDURE InitList(var l: List);
  PROCEDURE Prepend(var l: List; n: NodePtr);
  PROCEDURE Append(var l: List; n: NodePtr);
  PROCEDURE DeleteAndDisposeNode(var l: List; x: integer);
  FUNCTION NewNode(x: integer): NodePtr;

IMPLEMENTATION

  PROCEDURE InitList(var l: List);
  BEGIN
    l.first := NIL;
    l.last := NIL;
  END;

  FUNCTION IsEmpty(l: List): boolean;
  BEGIN
    IsEmpty := (l.first = NIL) AND (l.last = NIL);
  END;

  PROCEDURE Prepend(var l: List; n: NodePtr);
  BEGIN
    if IsEmpty(l) then begin
      l.first := n;
      l.last := n;
    end else begin
      n^.prev := NIL;
      n^.next := l.first;
      l.first^.prev := n;
      l.first := n;
    end; (* IF *)
  END;

  PROCEDURE Append(var l: List; n: NodePtr);
  BEGIN
    if IsEmpty(l) then begin
      l.first := n;
      l.last := n;
    end else begin
      n^.next := NIL;
      n^.prev := l.last;
      l.last^.next := n;
      l.last := n;
    end;
  END;

  PROCEDURE DeleteAndDisposeNode(var l: List; x: integer);
    var toDel: NodePtr;
  BEGIN
    if IsEmpty(l) then Exit;

    toDel := l.first;
    while (toDel <> NIL) AND (toDel^.val <> x) do
      toDel := toDel^.next;
    
    if toDel <> NIL then begin
      if toDel^.prev <> NIL then
        toDel^.prev^.next := toDel^.next
      else
        l.first := toDel^.next;
      if toDel^.next <> NIL then
        toDel^.next^.prev := toDel^.prev
      else
        l.last := toDel^.prev;
      Dispose(toDel);
    end; (* IF *)
  END;

  FUNCTION NewNode(x: integer): NodePtr;
    var n: NodePtr;
  BEGIN
    New(n);
    n^.prev := NIL;
    n^.val := x;
    n^.next := NIL;

    NewNode := n;
  END;

BEGIN
END.