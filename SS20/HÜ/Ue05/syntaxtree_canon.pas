(* Syntaxtree Canon:                                          MM, 2020-05-01 *)
(* ------                                                                    *)
(* A unit to display syntax trees in canonical form                          *)
(* ========================================================================= *)

UNIT syntaxtree_canon;

INTERFACE

  TYPE SynTree = POINTER;

  PROCEDURE NewTree(VAR t: SynTree);
  PROCEDURE DisposeTree(VAR t: SynTree);
  PROCEDURE WriteTree(t: SynTree);

  PROCEDURE S(VAR t: SynTree);

  VAR line: STRING;

IMPLEMENTATION

  TYPE
    NodePtr = ^Node;
    Node = RECORD
      firstChild, sibling: NodePtr;
      val: STRING;
    END;
    TreePtr = NodePtr;

  (* Functions for Tree *)
  PROCEDURE NewTree(VAR t: SynTree);
    BEGIN (* NewTree *)
      TreePtr(t) := NIL;
  END; (* NewTree *)

  PROCEDURE DisposeTree(VAR t: SynTree);
    BEGIN (* DisposeTree *)
      IF (TreePtr(t) <> NIL) THEN BEGIN
        DisposeTree(TreePtr(t)^.firstChild);
        DisposeTree(TreePtr(t)^.sibling);
        Dispose(TreePtr(t));
      END; (* IF *)
  END; (* DisposeTree *)

  FUNCTION NewNode(x: STRING): NodePtr;
    VAR n: NodePtr;
    BEGIN (* NewNode *)
      New(n);
      n^.val := x;
      n^.firstChild := NIL;
      n^.sibling := NIL;
      NewNode := n;
  END; (* NewNode *)

  PROCEDURE WriteTreeRec(t: SynTree; space: INTEGER);
    VAR i: INTEGER;
    BEGIN (* WriteTree *)
      IF (t <> NIL) THEN BEGIN
        space := space + 10;

        WriteTreeRec(TreePtr(t)^.sibling, space);
        WriteLn;
        FOR i := 10 TO space DO BEGIN
          Write(' ');
        END; (* FOR *)
        WriteLn(TreePtr(t)^.val);
        WriteTreeRec(TreePtr(t)^.firstChild, space);
      END; (* IF *)
  END; (* WriteTree *)

  PROCEDURE WriteTree(t: Syntree);
    BEGIN (* WriteTree *)
      WriteTreeRec(t, 0);
  END; (* WriteTree *)

  (* END Functions for Tree *)

  (* Functions for Data Analysis *)
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
      Expr(TreePtr(t));
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
    VAR t, t2: TreePtr;
    BEGIN (* Expr *)
      e := NewNode('Expr');
      Term(t); IF (NOT success) THEN Exit;
      (* SEM *) e^.firstChild := t;
      WHILE ((sy = plusSy) OR (sy = minusSy)) DO BEGIN
        CASE sy OF
          plusSy: BEGIN
                    NewSy;
                    t2 := NewNode('+');
                    Term(t2^.sibling); IF (NOT success) THEN Exit;
                    t^.sibling := t2;
                  END;
          minusSy:  BEGIN
                      NewSy;
                      t2 := NewNode('-');
                      Term(t2^.sibling); IF (NOT success) THEN Exit;
                      t^.sibling := t2;
                    END;
        END; (* CASE *)
      END; (* WHILE *)
  END; (* Expr *)

  PROCEDURE Term(VAR t: TreePtr);
    VAR f: TreePtr;
    BEGIN (* Term *)
      t := NewNode('Term');
      Fact(f); IF (NOT success) THEN Exit;
      (* SEM *) t^.firstChild := f;
      WHILE ((sy = timesSy) OR (sy = divSy)) DO BEGIN
        CASE sy OF
          timesSy: BEGIN 
                    NewSy;
                    f := NewNode('*');
                    Fact(f^.sibling); IF (NOT success) THEN Exit;
                    t^.sibling := f;
                  END;
          divSy: BEGIN 
                    NewSy;
                    f := NewNode('/');
                    Fact(f^.sibling); IF (NOT success) THEN Exit;
                    t^.sibling := f;
                  END;
        END; (* CASE *)
      END; (* WHILE *)
  END; (* Term *)

  PROCEDURE Fact(VAR f: TreePtr);
    VAR e: TreePtr;
    BEGIN (* Fact *)
      f := NewNode('Fact');
      CASE sy OF
        number:     BEGIN
                      f^.firstChild := NewNode(Chr(Ord(numberVal) + Ord('0')));
                      NewSy;
                    END;
        leftParSy:  BEGIN
                      NewSy;
                      e := NewNode('(');
                      Expr(e^.sibling); IF (NOT success) THEN Exit;
                      IF (sy <> rightParSy) THEN BEGIN
                        success := FALSE;
                        Exit;
                      END; (* IF *)
                      f^.sibling := e;
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