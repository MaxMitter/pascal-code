(* SynTree:                                           Rittberger, 2020-04-28 *)
(* ------                                                                    *)
(* checks the syntax of the given grammar                                    *)
(* ========================================================================= *)
PROGRAM SynTree;

  USES
    SynTreeUnit;

  VAR
    t1: kanTree;

BEGIN (* SynTree *)

  NewTree(t1);
  line := '2*3+4'; 
  WriteLn(line); 
  WriteLn('----------------');
  S(t1);

  //WriteT(t1);

  WriteTree(t1);
  
  DisposeTree(t1);
END. (* SynTree *)
