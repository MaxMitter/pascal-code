UNIT TreeUnit;
INTERFACE

TYPE NodePtr = ^Node;
     Node = RECORD 
              left, right: NodePtr;
              val: string;
              count: integer;
            END;
     Tree = NodePtr;

FUNCTION NewNode(x: string): NodePtr;
PROCEDURE DisposeTree(var t: Tree);
FUNCTION GetHighestCount(t: Tree): NodePtr;

(* FUNCTIONS For Search Trees *)
FUNCTION IsSorted(t: Tree): boolean;
PROCEDURE Insert(var t: Tree; x: string);
FUNCTION FindNode(t: Tree; x: string): NodePtr;

IMPLEMENTATION

  PROCEDURE DisposeTree(var t: Tree);
    BEGIN
      if t <> NIL then begin
        DisposeTree(t^.left);
        DisposeTree(t^.right);
        Dispose(t);
        t := NIL;
      end;
    END; (* DisposeTree *)

  FUNCTION FindNode(t: Tree; x: string): NodePtr;
    BEGIN
      if t = NIL then
        FindNode := NIL
      else if x = t^.val then
        FindNode := t
      else if x < t^.val then
        FindNode := FindNode(t^.left, x)
      else
        FindNode := FindNode(t^.right, x);
    END;

  FUNCTION IsSorted(t: Tree): boolean;
    BEGIN
      if t = NIL then
        IsSorted := true
      else begin
        if (t^.left <> NIL) AND (t^.left^.val > t^.val) then
          IsSorted := false
        else if(t^.right <> NIL) AND (t^.right^.val < t^.val) then
          IsSorted := false
        else if IsSorted(t^.left) AND (IsSorted(t^.right)) then
          IsSorted := true
        else
          IsSorted := false;
      end;
    END;

  PROCEDURE Insert(var t: Tree; x: string);
    var n: NodePtr;
    BEGIN
      //if not(IsSorted(t)) then HALT;
      if t = NIL then begin
        n := NewNode(x);
        t := n;
      end else if t^.val = x then
        Inc(t^.count)
      else if x <= t^.val then
        Insert(t^.left, x)
      else
        Insert(t^.right, x);
    END;

  FUNCTION NewNode(x: string): NodePtr;
    var n: NodePtr;
    BEGIN
      New(n);
      n^.val := x;
      n^.count := 1;
      n^.left := NIL;
      n^.right := NIL;
      NewNode := n;
    END;

  FUNCTION GetHighestCount(t: Tree): NodePtr;
    var l, r: NodePtr;
    BEGIN
      if (t^.left = NIL) AND (t^.right = NIL) then begin
        GetHighestCount := t;
      end else if (t^.left <> NIL) AND (t^.right <> NIL) then begin
        l := GetHighestCount(t^.left);
        r := GetHighestCount(t^.right);
        if l^.count > r^.count then begin
          if l^.count > t^.count then GetHighestCount := l
          else GetHighestCount := t;
        end else begin
          if r^.count > t^.count then GetHighestCount := r
          else GetHighestCount := t;
        end; (* IF *)
      end else if (t^.left <> NIL) then begin
        l := GetHighestCount(t^.left);
        if t^.count > l^.count then GetHighestCount := t
        else GetHighestCount := l;
      end else if (t^.right <> NIL) then begin
        r := GetHighestCount(t^.right);
        if t^.count > r^.count then GetHighestCount := t
        else GetHighestCount := r;
      end; (* IF *)
    END;
BEGIN
END.