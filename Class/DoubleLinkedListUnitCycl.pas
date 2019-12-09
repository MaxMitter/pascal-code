UNIT DoubleLinkedListUnitCycl;

INTERFACE

  Type NodePtr = ^Node;
      Node = Record
                prev: NodePtr;
                val: integer;
                next: NodePtr;
                End;
      List = NodePtr;

  PROCEDURE Append(var l: List; n: NodePtr);
  PROCEDURE Prepend(var l: List; n: NodePtr);
  FUNCTION FindNode(l: List; x: integer): NodePtr;
  PROCEDURE InsertSorted(var l: List; n: NodePtr);

IMPLEMENTATION

  PROCEDURE Append(var l: List; n: NodePtr);
  BEGIN
    n^.prev := l^.prev;
    n^.next := l;
    l^.prev^.next := n;
    l^.prev := n;
  END;

  PROCEDURE Prepend(var l: List; n: NodePtr);
  BEGIN
    n^.next := l^.next;
    n^.prev := l;
    l^.next^.prev := n;
    l^.next := n;
  END;

  FUNCTION FindNode(l: List; x: integer): NodePtr;
    var cur: NodePtr;
  BEGIN
    cur := l^.next; (* l^.val := x *)
    while (cur <> l) AND (cur^.val <> x) do (* Sentinel spart den ersten Teil der while *)
      cur := cur^.next;
    if cur = l then
      FindNode := NIL
    else
      FindNode := cur;
  END;
  (* Verbesserung: Wächter-Knoten (Sentinel)
     l^.val := x *)

  PROCEDURE InsertSorted(var l: List; n: NodePtr);
    var succ: NodePtr;
  BEGIN
    succ := l^.next;
    l^.val := n^.val;

    while succ^.val < n^.val do
      succ := succ^.next;

    n^.next := succ;
    n^.prev := succ^.prev;
    succ^.prev := n;
    n^.prev^.next := n;
  END;

BEGIN
END.