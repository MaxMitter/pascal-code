(* CanTreeTest:                                               MM, 2020-05-01 *)
(* ------                                                                    *)
(* Program to test the Canonical Syntax Tree                                 *)
(* ========================================================================= *)
PROGRAM CanTreeTest;

USES syntaxtree_canon;

  PROCEDURE TestTree(l: STRING);
    VAR t: SynTree;
    BEGIN (* TestTree *)
      NewTree(t);
      line := l;
      WriteLn(line);
      WriteLn('--------------------------');
      S(t);
      IF (t = NIL) THEN BEGIN
        WriteLn('Could not create Tree, calculation is invalid');
      END; (* IF *)
      WriteTree(t);
      DisposeTree(t);
  END; (* TestTree *)

  VAR s: STRING;

BEGIN (* SynTreeTest *)
  REPEAT
    Write('Enter Calculation > ');
    ReadLn(s);
    TestTree(s);
  UNTIL (s = ''); (* REPEAT *)
END. (* SynTreeTest *)