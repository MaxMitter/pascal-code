(* AbsTreeTest:                                               MM, 2020-05-01 *)
(* ------                                                                    *)
(* Program to test the Abstract Syntax Tree                                  *)
(* ========================================================================= *)
PROGRAM AbsTreeTest;

USES syntaxtree_abstract;

  VAR t: SynTree;

  PROCEDURE TestTree(l: STRING);
    BEGIN (* TestTree *)
      NewTree(t);
      line := l;
      WriteLn(line);
      WriteLn('**************');
      S(t);
      IF (t = NIL) THEN BEGIN
        WriteLn('Could not create Tree, calculation is invalid');
      END ELSE BEGIN
        WriteTree(t);
        WriteLn('---------- Pre-Order ----------');
        WriteTreePreOrder(t);
        WriteLn('---------- In-Order ----------');
        WriteTreeInOrder(t);
        WriteLn('---------- Post-Order ----------');
        WriteTreePostOrder(t);
        WriteLn('---------- Value-Of ----------');
        WriteLn('Value: ', ValueOf(t));
        DisposeTree(t);
      END; (* IF *)
      
  END; (* TestTree *)
  
  VAR s: STRING;

BEGIN (* AbsTreeTest *)
  REPEAT
    Write('Enter Calculation > ');
    ReadLn(s);
    TestTree(s);
  UNTIL (s = ''); (* REPEAT *)
END. (* AbsTreeTest *)