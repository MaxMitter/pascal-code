PROGRAM Balkendiagramm;

  FUNCTION Maximum(ni: ARRAY OF integer): integer;

  var i, max: integer;

  BEGIN (* Maximum *)
    max := 0;
    FOR i := 0 TO Length(ni) - 1 DO BEGIN
      IF (ni[i] > max) THEN BEGIN
        max := ni[i];
      END; (* IF *)
    END; (* FOR *)

    Maximum := max;
  END; (* Maximum *)

  PROCEDURE BarChart(ch: char; ni: ARRAY OF integer);

  var row, col: integer;

  BEGIN (* BarChart *)
    FOR row := Maximum(ni) DOWNTO 1 DO BEGIN
      Write(row:2, '|');
      FOR col := 0 TO Length(ni) - 1 DO BEGIN
        IF (ni[col] >= row) THEN BEGIN
          Write(ch:2);
        END ELSE BEGIN
          Write(' ':2);
        END; (* IF *)
      END; (* FOR col*)

      WriteLn();
    END; (* FOR row*)

    WriteLn('  +-----------');
    WriteLn('    1 2 3 4 5');

  END; (* BarChart *)

  var cha: char;
  var numbers: ARRAY [1..5] OF integer;
  var i: integer;

BEGIN (* Balkendiagramm *)
  Write('ch: ');
  Readln(cha);

  Write('ni: ');
  Read(numbers[1]);
  Read(numbers[2]);
  Read(numbers[3]);
  Read(numbers[4]);
  Readln(numbers[5]);

  FOR i := 1 TO 5 DO BEGIN
    IF ((numbers[i] > 10) OR (numbers[i] < 1)) THEN BEGIN
      Write('Wert ungueltig, Programm wird beendet');
      Exit;
    END; (* IF *)
  END; (* FOR *)
  BarChart(cha, numbers);
END. (* Balkendiagramm *)