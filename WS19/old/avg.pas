PROGRAM Avg;

  var x, s, n: integer;

BEGIN (* Avg *)
  s := 0;
  n := 0;
  Read(x);

  WHILE (x <> 0) DO BEGIN
    s := s + x;
    n := n + 1;
    Read(x);
  END; (* WHILE *)

  IF (n>0) THEN BEGIN
    WriteLn('Avg: ', s/n :5:3); //--> 5: Vorkommastellen, 3: nachkommastellen
  END ELSE BEGIN
    WriteLn('No data.');
  END; (* IF *)
  
END. (* Avg *)