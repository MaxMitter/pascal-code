PROGRAM Gleitkommazahlen;
  var x, sum: real;
BEGIN (* Gleitkommazahlen *)
  x := 0;
  sum := 0;
  Read(x);

  IF ((x > 1) OR (x < 0)) THEN
  BEGIN
    WriteLn('Ungueltige Eingabe.');
    Exit;
  END;
    
  WHILE (sum < 1) DO BEGIN
    sum := sum + x;
    WriteLn(sum);
  END; (* WHILE *)
END. (* Gleitkommazahlen *) 