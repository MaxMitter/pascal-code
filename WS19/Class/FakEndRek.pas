PROGRAM FakultaetEndRekursiv;

  FUNCTION FakRec(n: integer; f: longint): longint;
    BEGIN
      if n <= 1 then
        FakRec := f
      else
        FakRec := FakRec(n-1, f*n);
    END;

  FUNCTION Fak(n: integer): longint;
    BEGIN
      if n <= 1 then
        Fak := 1
      else
        Fak := FakRec(n, 1);
    END;

BEGIN (* FakultaetEndRekursiv *)
  WriteLn(FAk(1));
  WriteLn(FAk(2));
  WriteLn(FAk(3));
  WriteLn(FAk(4));
  WriteLn(FAk(5));
  WriteLn(FAk(6));
  WriteLn(FAk(7));
  WriteLn(FAk(8));
  WriteLn(FAk(9));
  WriteLn(FAk(10));
  WriteLn('----------------------------------');
  WriteLn(FAk(11));
  WriteLn(FAk(12));
  WriteLn(FAk(13));
END. (* FakultaetEndRekursiv *)