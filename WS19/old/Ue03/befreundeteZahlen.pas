PROGRAM befreundeteZahlen;

  var a, b, sum, i, sumA, sumB: integer;

  FUNCTION SummeEchterTeiler(x: integer): integer;
  BEGIN (* SummeEchterTeiler *)
    sum := 0;
    FOR i := x - 1 DOWNTO 1 DO BEGIN
      IF ((x MOD i) = 0) THEN BEGIN
        sum := sum + i;
      END; (* IF *)
    END; (* FOR *)

    SummeEchterTeiler := sum;
  END; (* SummeEchterTeiler *)

BEGIN (* befreundeteZahlen *)
  Write('a: ');
  Readln(a);
  Write('b: ');
  Readln(b);

  sumA := SummeEchterTeiler(a);
  sumB := SummeEchterTeiler(b);

  IF ((sumA = b) AND (sumB = a)) THEN BEGIN
    Write('Zahlen sind befreundet');
  END ELSE BEGIN
    Write('Zahlen sind nicht befreundet');
  END; (* IF *)
END. (* befreundeteZahlen *)