UNIT ModMovAvg;

INTERFACE
  FUNCTION MovAvg(x: REAL): REAL;

IMPLEMENTATION

  var s: REAL;
      n: integer;

  FUNCTION MovAvg(x: REAL): REAL;
  BEGIN (* MovAvg *)
    s := s + x;
    n := n + 1;

    MovAvg := s/n;
  END; (* MovAvg *)

  BEGIN
    s := 0;
    n := 0;
  END.