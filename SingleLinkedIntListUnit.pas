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

  PROCEDURE DisposeList(var l: List);

  FUNCTION FindNode(l: List; x: integer): ListNodePtr;

  PROCEDURE InsertSorted(var l: List; n: ListNodePtr);

  FUNCTION IsSorted(l: List): boolean;
IMPLEMENTATION

  PROCEDURE InitList(var l: List);
  BEGIN (* InitList *)
    l := nil;
  END; (* InitList *)

  FUNCTION IsSorted(l: List): boolean;
  var prev: ListNodePtr;
  BEGIN
  
    IsSorted := true;
    if (l <> NIL) AND (l^.next <> NIL) then begin
      prev := l^.next;
      while prev^.next <> NIL do begin
        if l^.val > prev^.val then
          IsSorted := false;
        l := prev;
        prev := l^.next;
      end; (* WHILE *)
    end; (* IF *)


    { Ideal Lösung }

    while (l <> NIL) AND (l^.next <> NIL) AND (l^.val <= l^.next^.val) do begin
      l := l^.next;
    end; (* WHILE *)
    IsSorted := (l = NIL) OR (l^.next = NIL);
  END;

  PROCEDURE InsertSorted(var l: List; n: ListNodePtr);
  var prev: ListNodePtr;
  BEGIN
    if NOT(IsSorted(l)) OR (n = NIL) then begin
      WriteLn('List not sorted');
      HALT;
    end else begin
      if (l = NIL) OR (l^.val >= n^.val) then begin
        Prepand(l, n);
      end else begin
        prev := l;
        while (prev^.next <> NIL) AND (prev^.next^.val < n^.val) do begin
          prev := prev^.next;
        end; (* WHILE *)
        n^.next := prev^.next;
        prev^.next := n;
      end; (* IF *)
    end; (* IF *)
  END; (* InsertSorted *)

  FUNCTION FindNode(l: List; x: integer): ListNodePtr;
  BEGIN
    while (l <> NIL) AND (l^.val <> x) do
      l := l^.next;
    FindNode := l;
  END; 

  PROCEDURE DisposeList(var l: List);
  var next: ListNodePtr;
  BEGIN
    while l <> NIL do begin
      next := l^.next;
      Dispose(l);
      l := next;
    end; (* while *)
  END;

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