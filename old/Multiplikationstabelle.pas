PROGRAM Multiplikationstabelle;
  var n, m, i, j: integer;
BEGIN (* Multiplikationstabelle *)
  n := 0;
  m := 0;

  Read(n);
  Read(m);

  if((n < 1) OR (m < 1)) then begin
    Writeln('Programm wird beendet.');
    Exit;
  end; (* IF *)

  IF ((n > 20) OR (m > 20)) THEN BEGIN
    WriteLn('Ungueltige Eingabe.');
    Exit;
  END; (* IF *)

  FOR i := 1 TO n DO BEGIN
    FOR j := 1 TO m DO BEGIN
      Write(i*j:3, ' ');
    END; (* FOR j *)
    Writeln();
  END; (* FOR i *)
END. (* Multiplikationstabelle *)