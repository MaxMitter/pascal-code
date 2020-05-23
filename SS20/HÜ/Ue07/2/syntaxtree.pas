(* Syntaxtree Abstract:                                       MM, 2020-05-20 *)
(* ------                                                                    *)
(* A unit to display syntax trees in abstract form                           *)
(* ========================================================================= *)

UNIT syntaxtree;

INTERFACE

  USES CodeGen, CodeDef, SymTab;

  TYPE SynTree = POINTER;

  PROCEDURE NewTree(VAR t: SynTree);
  PROCEDURE DisposeTree(VAR t: SynTree);
  PROCEDURE WriteTree(t: SynTree);
  PROCEDURE WriteTreePreOrder(t: SynTree);
  PROCEDURE WriteTreeInOrder(t: SynTree);
  PROCEDURE WriteTreePostOrder(t: SynTree);
  FUNCTION TreeOf(s: STRING; t1, t2: SynTree): SynTree;
  FUNCTION ValueOf(t: Syntree): INTEGER;
  PROCEDURE EmitCodeForExprTree(t: SynTree);

IMPLEMENTATION

  TYPE
    NodePtr = ^Node;
    Node = RECORD
      left, right: NodePtr;
      val: STRING;
    END;
    TreePtr = NodePtr;

  (*-- Functions for Tree --*)
  PROCEDURE NewTree(VAR t: SynTree);
    BEGIN (* NewTree *)
      TreePtr(t) := NIL;
  END; (* NewTree *)

  PROCEDURE DisposeTree(VAR t: SynTree);
    BEGIN (* DisposeTree *)
      IF (TreePtr(t) <> NIL) THEN BEGIN
        DisposeTree(TreePtr(t)^.left);
        DisposeTree(TreePtr(t)^.right);
        Dispose(TreePtr(t));
      END; (* IF *)
  END; (* DisposeTree *)

  FUNCTION NewNode(x: STRING): NodePtr;
    VAR n: NodePtr;
    BEGIN (* NewNode *)
      New(n);
      n^.val := x;
      n^.left := NIL;
      n^.right := NIL;
      NewNode := n;
  END; (* NewNode *)

  PROCEDURE WriteTreeRec(t: SynTree; space: INTEGER);
    VAR i: INTEGER;
    BEGIN (* WriteTree *)
      IF (t <> NIL) THEN BEGIN
        space := space + 10;

        WriteTreeRec(TreePtr(t)^.right, space);
        WriteLn;
        FOR i := 10 TO space DO BEGIN
          Write(' ');
        END; (* FOR *)
        WriteLn(TreePtr(t)^.val);
        WriteTreeRec(TreePtr(t)^.left, space);
      END; (* IF *)
  END; (* WriteTree *)

  PROCEDURE WriteTree(t: Syntree);
    BEGIN (* WriteTree *)
      WriteTreeRec(t, 0);
  END; (* WriteTree *)

  FUNCTION TreeOfPtr(s: STRING; t1, t2: TreePtr): TreePtr;
    VAR n: NodePtr;
    BEGIN (* TreeOf *)
      n := NewNode(s);
      n^.left := t1;
      n^.right := t2;
      TreeOfPtr := n;
  END; (* TreeOf *)

  FUNCTION TreeOf(s: STRING; t1, t2: SynTree): SynTree;
    BEGIN (* TreeOf *)
      TreeOf := TreeOfPtr(s, TreePtr(t1), TreePtr(t2));
  END; (* TreeOf *)

  PROCEDURE WriteTreePreOrder(t: SynTree);
    BEGIN (* WriteTreePreOrder *)
      IF (TreePtr(t) <> NIL) THEN BEGIN
        WriteLn(TreePtr(t)^.val);
        WriteTreePreOrder(TreePtr(t)^.left);
        WriteTreePreOrder(TreePtr(t)^.right);
      END; (* IF *)
  END; (* WriteTreePreOrder *)

  PROCEDURE WriteTreeInOrder(t: SynTree);
    BEGIN (* WriteTreeInOrder *)
      IF (t <> NIL) THEN BEGIN
        WriteTreeInOrder(TreePtr(t)^.left);
        WriteLn(TreePtr(t)^.val);
        WriteTreeInOrder(TreePtr(t)^.right);
      END; (* IF *)
  END; (* WriteTreeInOrder *)

  PROCEDURE WriteTreePostOrder(t: SynTree);
    BEGIN (* WriteTreePostOrder *)
      IF (t <> NIL) THEN BEGIN
        WriteTreePostOrder(TreePtr(t)^.left);
        WriteTreePostOrder(TreePtr(t)^.right);
        WriteLn(TreePtr(t)^.val);
      END; (* IF *)
  END; (* WriteTreePostOrder *)

  FUNCTION ToInt(s: STRING): INTEGER;
    VAR i, sum: INTEGER;
    BEGIN (* ToInt *)
      sum := 0;
      FOR i := 1 TO Length(s) DO BEGIN
        sum := sum * 10 + Ord(s[i]) - Ord('0');
      END; (* FOR *)

      ToInt := sum;
  END; (* ToInt *)

  FUNCTION IsConstant(s: STRING): BOOLEAN;
    BEGIN (* IsConstant *)
      IsConstant := s[1] IN ['0'..'9'];
  END; (* IsConstant *)

  PROCEDURE FoldConstants(VAR t: SynTree);
    VAR i: INTEGER;
        s: STRING;
    BEGIN (* FoldConstants *)
      IF (TreePtr(t)^.left <> NIL) AND (TreePtr(t)^.right <> NIL) THEN BEGIN
        IF (IsConstant(TreePtr(t)^.left^.val) AND IsConstant(TreePtr(t)^.right^.val)) THEN BEGIN
          CASE TreePtr(t)^.val[1] OF
            '+': BEGIN i := ToInt(TreePtr(t)^.left^.val) + ToInt(TreePtr(t)^.right^.val); END;
            '-': BEGIN i := ToInt(TreePtr(t)^.left^.val) - ToInt(TreePtr(t)^.right^.val); END;
            '*': BEGIN i := ToInt(TreePtr(t)^.left^.val) * ToInt(TreePtr(t)^.right^.val); END;
            '/': BEGIN i := ToInt(TreePtr(t)^.left^.val) DIV ToInt(TreePtr(t)^.right^.val); END;
          END; (* CASE *)

          Dispose(TreePtr(t)^.left);
          Dispose(TreePtr(t)^.right);
          TreePtr(t)^.left := NIL;
          TreePtr(t)^.right := NIL;

          Str(i, s);
          TreePtr(t)^.val := s;
        END; (* IF *)
      END; (* IF *)
  END; (* FoldConstants *)

  PROCEDURE Optimize(VAR t: SynTree);
    BEGIN (* Optimize *)
      IF (TreePtr(t)^.left <> NIL) THEN
        Optimize(TreePtr(t)^.left);
      IF (TreePtr(t)^.right <> NIL) THEN
        Optimize(TreePtr(t)^.right);

      FoldConstants(TreePtr(t));

      IF (TreePtr(t)^.val = '+') THEN BEGIN
        IF (TreePtr(t)^.left^.val = '0') THEN BEGIN
          Dispose(TreePtr(t)^.left);
          TreePtr(t) := TreePtr(t)^.right;
        END ELSE IF (TreePtr(t)^.right^.val = '0') THEN BEGIN
          Dispose(TreePtr(t)^.right);
          TreePtr(t) := TreePtr(t)^.left;
        END; (* IF *)
      END ELSE IF (TreePtr(t)^.val = '-') THEN BEGIN
        IF (TreePtr(t)^.right^.val = '0') THEN BEGIN
          Dispose(TreePtr(t)^.right);
          TreePtr(t) := TreePtr(t)^.left;
        END; (* IF *)
      END ELSE IF (TreePtr(t)^.val = '*') THEN BEGIN
        IF (TreePtr(t)^.left^.val = '1') THEN BEGIN
          Dispose(TreePtr(t)^.left);
          TreePtr(t) := TreePtr(t)^.right;
        END ELSE IF (TreePtr(t)^.right^.val = '1') THEN BEGIN
          Dispose(TreePtr(t)^.right);
          TreePtr(t) := TreePtr(t)^.left;
        END; (* IF *)
      END ELSE IF (TreePtr(t)^.val = '/') THEN BEGIN
        IF (TreePtr(t)^.right^.val = '1') THEN BEGIN
          Dispose(TreePtr(t)^.right);
          TreePtr(t) := TreePtr(t)^.left;
        END; (* IF *)
      END; (* IF *)
  END; (* Optimize *)

  PROCEDURE EmitOpCode(t: SynTree);
    VAR s: STRING;
    BEGIN (* EmitOpCode *)
      IF t <> NIL THEN BEGIN
          EmitCodeForExprTree(TreePtr(t)^.left);
          EmitCodeForExprTree(TreePtr(t)^.right);
          s := TreePtr(t)^.val;

          CASE s[1] OF
            '+':      BEGIN Emit1(AddOpc); END;
            '-':      BEGIN Emit1(SubOpc); END;
            '*':      BEGIN Emit1(MulOpc); END;
            '/':      BEGIN Emit1(DivOpc); END;
            '0'..'9': BEGIN Emit2(LoadConstOpc, ToInt(s)); END;
            ELSE      BEGIN Emit2(LoadValOpc, AddrOf(s)); END;
          END;
        END;
  END; (* EmitOpCode *)

  PROCEDURE EmitCodeForExprTree(t: SynTree);
    BEGIN (* EmitCodeForExprTree *)
      IF (t <> NIL) THEN BEGIN
        WriteTree(t);
        Optimize(t);
        WriteLn('----------Optimized----------');
        WriteTree(t);
        WriteLn('#############################');
        EmitOpCode(t);
      END; (* IF *)
  END; (* EmitCodeForExprTree *)

  FUNCTION ValueOfTreePtr(t: TreePtr): INTEGER;
    BEGIN (* ValueOfTreePtr *)
      IF (t <> NIL) THEN BEGIN
        CASE t^.val[1] OF
          '+': BEGIN ValueOfTreePtr := ValueOfTreePtr(t^.left) + ValueOfTreePtr(t^.right); END;
          '-': BEGIN ValueOfTreePtr := ValueOfTreePtr(t^.left) - ValueOfTreePtr(t^.right); END;
          '*': BEGIN ValueOfTreePtr := ValueOfTreePtr(t^.left) * ValueOfTreePtr(t^.right); END;
          '/': BEGIN ValueOfTreePtr := ValueOfTreePtr(t^.left) DIV ValueOfTreePtr(t^.right); END;
        ELSE BEGIN
          ValueOfTreePtr := ToInt(t^.val);
          END; (* ELSE *)
        END; (* CASE *)
      END; (* IF *)
  END; (* ValueOfTreePtr *)

  FUNCTION ValueOf(t: SynTree): INTEGER;
    BEGIN (* ValueOf *)
      ValueOf := ValueOfTreePtr(TreePtr(t));
  END; (* ValueOf *)

  (*-- END Functions for Tree --*)
END. (* syntaxtree_canon *)