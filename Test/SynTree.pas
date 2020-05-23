(* SynTree:                                           Rittberger, 2020-04-28 *)
(* ------                                                                    *)
(* checks the syntax of the given grammar                                    *)
(* ========================================================================= *)
PROGRAM SynTree;

  USES
    SynTreeUnit;

  FUNCTION ToInt(s: STRING): INTEGER;
    VAR i, sum: INTEGER;
    BEGIN (* ToInt *)
      sum := 0;
      FOR i := 1 TO Length(s) DO BEGIN
        sum := sum * 10 + Ord(s[i]) - Ord('0');
      END; (* FOR *)

      ToInt := sum;
  END; (* ToInt *)

  VAR
    t1: kanTree;

BEGIN (* SynTree *)

  Write(Chr(Ord(17) + Ord('0')));
  
END. (* SynTree *)
