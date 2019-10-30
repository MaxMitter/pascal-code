PROGRAM ZahlenZaehlen;
  var sumPos, sumNeg, x: integer;
BEGIN (* ZahlenZaehlen *)
  sumNeg := 0;
  sumPos := 0;
  Read(x);

  WHILE (x <> 0) DO BEGIN
    IF (x < 0) THEN BEGIN
      sumNeg := sumNeg + 1;
    END ELSE BEGIN
      sumPos := sumPos + 1;
    END; (* IF *)
    Read(x);
  END; (* WHILE *)

  WriteLn('Pos: ', sumPos);
  WriteLn('Neg: ', sumNeg);
END. (* ZahlenZaehlen *)