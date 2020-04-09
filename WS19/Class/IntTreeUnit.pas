UNIT IntTreeUnit;

INTERFACE

TYPE NodePtr = ^Node;
     Node = RECORD 
              left, right: NodePtr;
              val: integer;
            END;
     Tree = NodePtr;

FUNCTION NewNode(x: integer): NodePtr;
FUNCTION TreeOf(x: integer; left, right: Tree): Tree;
PROCEDURE WriteTreePreOrder(t: Tree);
PROCEDURE WriteTreeInOrder(t: Tree);
PROCEDURE WriteTreePostOrder(t: Tree);
FUNCTION NumNodes(t: Tree): integer;
PROCEDURE DisposeTree(var t: Tree);

(* FUNCTIONS For Search Trees *)
FUNCTION IsSorted(t: Tree): boolean;
PROCEDURE Insert(var t: Tree; x: integer);
FUNCTION FindNode(t: Tree; x: integer): NodePtr;
PROCEDURE Delete(t: Tree; x: integer);

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

  PROCEDURE Delete(t: Tree; x: integer);
    var toDel, cur, repl, prev, prevR, curR: NodePtr;
    BEGIN
      prev := NIL;
      cur := t;
      prevR := NIL;
      while (cur <> NIL) AND (cur^.val <> x) do begin
        prev := cur;
        if x <= cur^.val then
          cur := cur^.left
        else
          cur := cur^.right;
      end; (* WHILE *)

      if cur <> NIL then begin
        toDel := cur;
        repl := NIL;

        if toDel^.right <> NIL then begin
          repl := toDel^.right;

          if repl^.left <> NIL then begin
            prevR := repl;
            curR := repl^.left;
            while curR <> NIL do begin
              prevR := curR;
              curR := curR^.left;
            end; (* WHILE *)
          end else prevR := NIL;
        end; (* IF *)

        if prevR = NIL then
          repl := toDel^.left
        else begin
          prevR^.left := toDel^.left;
        
        if prev = NIL then
          t := repl
        else begin
          if toDel^.val <= prev^.val then
            prev^.left := repl
          else
            prev^.right := repl;
          Dispose(toDel);
          end; (* IF *)
        end; (* IF *)
      end; (* IF *)
    END;

  FUNCTION FindNode(t: Tree; x: integer): NodePtr;
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
        else if(t^.right <> NIL) AND (t^.right^.val > t^.val) then
          IsSorted := false
        else if IsSorted(t^.left) AND (IsSorted(t^.right)) then
          IsSorted := true
        else
          IsSorted := false;
      end;

      (* IsSorted := IsSorted(t^.left)
                AND IsSorted(t^.right)
                AND ((t^.left = NIL) 
                OR (t^.left^.val <= t^.val)
                OR (t^.right^.val > t^.val))
      *)
    END;

  PROCEDURE InsertIter (var t: Tree; x: integer);
    var cur: NodePtr;
        prev: NodePtr;
    BEGIN
      cur := t;
      prev := NIL;

      while cur <> NIL do begin
        prev := cur;
        if x <= cur^.val then 
          cur := cur^.left
        else 
          cur := cur^.right;
      end;

      if prev = NIL then
        t := NewNode(x)
      else if x <= prev^.val then
        prev^.left := NewNode(x)
      else
        prev^.right := NewNode(x);
    END;

  PROCEDURE Insert(var t: Tree; x: integer);
    var n: NodePtr;
    BEGIN
      if not(IsSorted(t)) then HALT;

      if t = NIL then begin
        n := NewNode(x);
        t := n;
      end else if x <= t^.val then
        Insert(t^.left, x)
      else
        Insert(t^.right, x);

    END;

  FUNCTION NewNode(x: integer): NodePtr;
    var n: NodePtr;
    BEGIN
      New(n);
      n^.val := x;
      n^.left := NIL;
      n^.right := NIL;
      NewNode := n;
    END;

  FUNCTION TreeOf(x: integer; left, right: Tree): Tree;
    var n: NodePtr;
    BEGIN
      if (left<>NIL) AND (right<>NIL) AND (left = right) then HALT;
      New(n);
      n^.val := x;
      n^.left := left;
      n^.right := right;
      TreeOf := n;
    END;

  PROCEDURE WriteTreePreOrder(t: Tree);
    BEGIN
      if t <> NIL then begin
        Write(t^.val, ' ');
        WriteTreePreOrder(t^.left);
        WriteTreePreOrder(t^.right);
      end;
    END;

  PROCEDURE WriteTreeInOrder(t: Tree);
    BEGIN
      if t <> NIL then begin
        WriteTreeInOrder(t^.left);
        Write(t^.val, ' ');
        WriteTreeInOrder(t^.right);
      end;
    END;
  
  PROCEDURE WriteTreePostOrder(t: Tree);
    BEGIN
      WriteTreePostOrder(t^.left);
      WriteTreePostOrder(t^.right);
      Write(t^.val, ' ');
    END;

  FUNCTION NumNodes(t: Tree): integer;
    BEGIN
      if t <> NIL then
        NumNodes := 1 + NumNodes(t^.left) + NumNodes(t^.right)
      else
        NumNodes := 0;
    END;

BEGIN
END.