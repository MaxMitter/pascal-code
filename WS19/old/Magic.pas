PROGRAM Magic;

  var g1, g2: integer;

  PROCEDURE UP2(v2: integer;
                var r2: integer);
  BEGIN (* UP2 *)
    v2 := v2 + 1;
    r2 := r2 + 1;
    g1 := g1 + 1;
    g2 := g2 + 1;
  END; (* UP2 *)

  PROCEDURE UP1(v1: integer;
                var r1: integer);
  BEGIN (* UP1 *)
    UP2(v1, r1);
    UP2(r1, v1);
    v1 := v1 + 1;
    r1 := r1 + 1;
  END; (* UP1 *)

BEGIN (* Magic *)
  g1 := 1;
  g2 := 1;

  UP1(g1, g2);
  UP2(g1, g2);

  Writeln(g1);
  Writeln(g2);
END. (* Magic *)