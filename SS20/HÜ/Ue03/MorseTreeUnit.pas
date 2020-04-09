UNIT MorseTreeUnit;

INTERFACE

  TYPE
    NodePtr = ^Node;
    Node = RECORD
      left, right: NodePtr;
      letter: CHAR;
      fullCode: STRING;
    END;
    Tree = NodePtr;

  PROCEDURE DisposeTree(var t: Tree);
  FUNCTION FindNode(t: Tree; x: CHAR): NodePtr;
  FUNCTION FindNodeByCode(t: Tree; x: STRING; count: INTEGER): NodePtr;
  PROCEDURE Insert(VAR t: Tree; n: NodePtr);
  FUNCTION NewNode(x: CHAR; c: STRING): NodePtr;
  PROCEDURE WriteTreePreOrder(t: Tree);

IMPLEMENTATION

  PROCEDURE DisposeTree(var t: Tree);
    BEGIN
      IF t <> NIL THEN begin
        DisposeTree(t^.left);
        DisposeTree(t^.right);
        Dispose(t);
        t := NIL;
      END; (* IF *)
  END; (* DisposeTree *)

  FUNCTION FindNode(t: Tree; x: CHAR): NodePtr;
    VAR n: NodePtr;
    BEGIN
      IF t = NIL THEN
        FindNode := NIL
      ELSE IF x = t^.letter THEN
        FindNode := t
      ELSE BEGIN
        n := FindNode(t^.left, x);
        IF (n = NIL) THEN BEGIN
          n := FindNode(t^.right, x);
        END; (* IF *)

        FindNode := n;
      END; (* IF *)
  END; (* FindNode *)

  FUNCTION FindNodeByCode(t: Tree; x: STRING; count: INTEGER): NodePtr;
    BEGIN (* FindNodeByCode *)
      IF t = NIL THEN
        FindNodeByCode := NIL
      ELSE IF x = t^.fullCode THEN
        FindNodeByCode := t
      ELSE IF x[count] = '.' THEN
        FindNodeByCode := FindNodeByCode(t^.left, x, count + 1)
      ELSE
        FindNodeByCode := FindNodeByCode(t^.right, x, count + 1);
  END; (* FindNodeByCode *)

  PROCEDURE Insert(VAR t: Tree; n: NodePtr);
    VAR count: INTEGER;
        curr: NodePtr;
    BEGIN (* Insert *)
      count := 1;
      curr := t;
      WHILE ((count < Length(n^.fullCode))) DO BEGIN
        IF (n^.fullCode[count] = '.') THEN BEGIN
          curr := curr^.left;
        END ELSE BEGIN
          curr := curr^.right;
        END; (* IF *)
        Inc(count);
      END; (* WHILE *)

      IF (n^.fullCode[count] = '.') THEN BEGIN
        curr^.left := n;
      END ELSE BEGIN
        curr^.right := n;
      END; (* IF *)
  END; (* Insert *)

  FUNCTION NewNode(x: CHAR; c: STRING): NodePtr;
    VAR n: NodePtr;
    BEGIN (* NewNode *)
      New(n);
      n^.letter := x;
      n^.fullCode := c;
      n^.left := NIL;
      n^.right := NIL;
      NewNode := n;
  END; (* NewNode *)

  PROCEDURE WriteTreePreOrder(t: Tree);
    BEGIN
      if t <> NIL then begin
        Write(t^.letter, '=', t^.fullCode, ' | ');
        WriteTreePreOrder(t^.left);
        WriteTreePreOrder(t^.right);
      end;
  END; (* WriteTreePreOrder *)

BEGIN (* MorseTreeUnit *)
END. (* MorseTreeUnit *)