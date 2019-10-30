PROGRAM Balkendiagramm;

  var cha: char;
  var a, b, c, d, e: integer;

  FUNCTION Maximum(a, b, c, d, e: integer): integer;

  var max: integer;

  BEGIN (* Maximum *)
    max := a;
    IF (b > max) THEN BEGIN
      max := b;
    END; (* IF *)
    IF (c > max) THEN BEGIN
      max := c;
    END; (* IF *)
    IF (d > max) THEN BEGIN
      max := d;
    END; (* IF *)
    IF (e > max) THEN BEGIN
      max := e;
    END; (* IF *)

    Maximum := max;
  END; (* Maximum *)

  PROCEDURE BarChart(ch: CHAR; n1, n2, n3, n4, n5: integer);

  var row: integer;

  BEGIN (* BarChart *)

    FOR row := Maximum(n1, n2, n3, n4, n5) DOWNTO 1 DO BEGIN
      Write(row:2, '|');
      IF (n1 >= row) THEN BEGIN
        Write(' ', ch);
      END ELSE BEGIN
        Write('  ');
      END; (* IF *)

      IF (n2 >= row) THEN BEGIN
        Write(' ', ch);
      END ELSE BEGIN
        Write('  ');
      END; (* IF *)

      IF (n3 >= row) THEN BEGIN
        Write(' ', ch);
      END ELSE BEGIN
        Write('  ');
      END; (* IF *)

      IF (n4 >= row) THEN BEGIN
        Write(' ', ch);
      END ELSE BEGIN
        Write('  ');
      END; (* IF *)

      IF (n5 >= row) THEN BEGIN
        Write(' ', ch);
      END ELSE BEGIN
        Write('  ');
      END; (* IF *)

      WriteLn();
    END; (* FOR *)

    WriteLn('  +------------');
    WriteLn('    1 2 3 4 5');
  END; (* BarChart *)

BEGIN (* Balkendiagramm *)
  Write('ch: ');
  Readln(cha);
  Write('ni: ');
  Read(a);
  Read(b);
  Read(c);
  Read(d);
  Readln(e);

  IF ((e > 10) OR (a > 10) OR (b > 10) OR (c > 10) OR (d > 10)) THEN BEGIN
    Write('Wert ungueltig, Programm wird beendet');
    Exit;
  END; (* IF *)

  BarChart(cha, a, b, c, d, e);
END. (* Balkendiagramm *)