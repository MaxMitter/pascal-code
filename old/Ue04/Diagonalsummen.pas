PROGRAM Diagonalsummen;

  const size = 4;
  type Matrix = ARRAY [1..size, 1..size] OF INTEGER;
  type DiagonalSums = ARRAY [1..size] OF INTEGER;

  PROCEDURE CalculateDiagonalSums(m: Matrix; VAR d: DiagonalSums);

    var i, j: integer;

  BEGIN (* CalculateDiagonalSums *)

    FOR i := 1 TO size DO BEGIN
      d[i] := 0;
    END; (* FOR *)

    FOR i := 1 TO size DO BEGIN
      FOR j := 1 TO (size + 1 - i) DO BEGIN
        d[i] := d[i] + m[i + j - 1, j];
      END; (* FOR *)
    END; (* FOR *)

  END; (* CalculateDiagonalSums *)


  var input: Matrix;
  var i, j: INTEGER;
  var d: DiagonalSums;

BEGIN (* Diagonalsummen *)
  WriteLn('Bitte Matrix eingeben: ');

  FOR i := 1 TO size DO BEGIN
    FOR j := 1 TO size DO BEGIN
      Read(input[i, j]);
    END; (* FOR *)
  END; (* FOR *)

  CalculateDiagonalSums(input, d);

  Write('Diagonalsummen: ');
  FOR i := 1 TO size DO BEGIN
    IF (i = size) THEN BEGIN
      Write(d[i]);
    END ELSE BEGIN
      Write(d[i], ', ');
    END; (* IF *)
  END; (* FOR *)

END. (* Diagonalsummen *)