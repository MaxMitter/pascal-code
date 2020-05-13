(* Syntaxtree Abstract:                                       MM, 2020-05-01 *)
(* ------                                                                    *)
(* A unit to display syntax trees in abstract form                           *)
(* ========================================================================= *)

UNIT syntaxtree_abstract;

INTERFACE

  TYPE SynTree = POINTER;

  PROCEDURE NewTree(VAR t: SynTree);
  PROCEDURE DisposeTree(VAR t: SynTree);
  PROCEDURE WriteTree(t: SynTree);
  PROCEDURE WriteTreePreOrder(t: SynTree);
  PROCEDURE WriteTreeInOrder(t: SynTree);
  PROCEDURE WriteTreePostOrder(t: SynTree);
  FUNCTION ValueOf(t: Syntree): INTEGER;

  PROCEDURE S(VAR t: SynTree);

  VAR line: STRING;

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

  FUNCTION TreeOf(s: STRING; t1, t2: TreePtr): TreePtr;
    VAR n: NodePtr;
    BEGIN (* TreeOf *)
      n := NewNode(s);
      n^.left := t1;
      n^.right := t2;
      TreeOf := n;
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

  (*-- Functions for Data Analysis --*)
  CONST
    EOS_CH = Chr(0);

  TYPE
    SymbolCode =  (noSy, (* error symbol *)
                  eosSy, (* end of string symbol*)
                  plusSy, minusSy, timesSy, divSy,
                  leftParSy, rightParSy,
                  number);

  VAR
    ch: CHAR;
    cnr: INTEGER;
    sy: SymbolCode;
    numberVal: INTEGER;
    success: BOOLEAN;

  PROCEDURE Expr(VAR e: TreePtr) FORWARD;
  PROCEDURE Term(VAR t: TreePtr) FORWARD;
  PROCEDURE Fact(VAR f: TreePtr) FORWARD;

  (* SCANNER *)

  PROCEDURE NewCh;
    BEGIN (* NewCh *)
      IF (cnr < Length(line)) THEN BEGIN
        Inc(cnr);
        ch := line[cnr];
      END ELSE BEGIN
        ch := EOS_CH;
      END; (* IF *)
  END; (* NewCh *)

  PROCEDURE NewSy;
    BEGIN (* NewSy *)
      WHILE (ch = ' ') DO BEGIN
        NewCh;
      END; (* WHILE *)

      CASE ch OF
        EOS_CH:   BEGIN sy := eosSy; END;
        '+':      BEGIN sy := plusSy; NewCh; END;
        '-':      BEGIN sy := minusSy; NewCh; END;
        '*':      BEGIN sy := timesSy; NewCh; END;
        '/':      BEGIN sy := divSy; NewCh; END;
        '(':      BEGIN sy := leftParSy; NewCh; END;
        ')':      BEGIN sy := rightParSy; NewCh; END;
        '0'..'9': BEGIN
                    sy := number;
                    numberVal := 0;
                    WHILE ((ch >= '0') AND (ch <= '9')) DO BEGIN
                      numberVal := numberVal * 10 + Ord(ch) - Ord('0');
                      NewCh;
                    END; (* WHILE *)
                  END;
        ELSE BEGIN
          sy := noSy;
        END;
      END; (* CASE *)
  END; (* NewSy *)

  (* END SCANNER *)

  (* PARSER *)

  PROCEDURE InitParser;
    BEGIN (* InitParser *)
      success := TRUE;
      cnr := 0;
  END; (* InitParser *)

  PROCEDURE S(VAR t: SynTree);
    BEGIN (* S *)
      InitParser;
      NewCh;
      NewSy;
      Expr(TreePtr(t)); IF (NOT success) THEN Exit;
      IF (NOT success) THEN BEGIN
        DisposeTree(t);
        t := NIL;
        Exit;
      END; (* IF *)
      IF (sy <> eosSy) THEN BEGIN
        success := FALSE;
        EXIT;
      END; (* IF *)
  END; (* S *)

  PROCEDURE Expr(VAR e: TreePtr);
    VAR t: TreePtr;
    BEGIN (* Expr *)
      Term(e); IF (NOT success) THEN Exit;
      WHILE ((sy = plusSy) OR (sy = minusSy)) DO BEGIN
        CASE sy OF
          plusSy: BEGIN
                    NewSy;
                    Term(t); IF (NOT success) THEN Exit;
                    e := TreeOf('+', e, t);
                  END;
          minusSy:  BEGIN
                      NewSy;
                      Term(t); IF (NOT success) THEN Exit;
                      e := TreeOf('-', e, t);
                    END;
        END; (* CASE *)
      END; (* WHILE *)
  END; (* Expr *)

  PROCEDURE Term(VAR t: TreePtr);
    VAR f: TreePtr;
    BEGIN (* Term *)
      Fact(t); IF (NOT success) THEN Exit;
      WHILE ((sy = timesSy) OR (sy = divSy)) DO BEGIN
        CASE sy OF
          timesSy: BEGIN 
                    NewSy;
                    Fact(f); IF (NOT success) THEN Exit;
                    t := TreeOf('*', t, f);
                  END;
          divSy: BEGIN 
                    NewSy;
                    Fact(f); IF (NOT success) THEN Exit;
                    t := TreeOf('/', t, f);
                  END;
        END; (* CASE *)
      END; (* WHILE *)
  END; (* Term *)

  PROCEDURE Fact(VAR f: TreePtr);
    VAR n: STRING;
    BEGIN (* Fact *)
      CASE sy OF
        number:     BEGIN
                      n := Chr(Ord(numberVal) + Ord('0'));
                      f := TreeOf(n, NIL, NIL);
                      NewSy;
                    END;
        leftParSy:  BEGIN
                      NewSy;
                      Expr(f); IF (NOT success) THEN Exit;
                      IF (sy <> rightParSy) THEN BEGIN
                        success := FALSE;
                        Exit;
                      END; (* IF *)
                      NewSy;
                    END;
        ELSE BEGIN
          success := FALSE;
          Exit;
        END;
      END; (* CASE *)
  END; (* Fact *)

  (* END PARSER *)
BEGIN (* syntaxtree_canon *)
END. (* syntaxtree_canon *)