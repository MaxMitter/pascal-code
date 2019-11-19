PROGRAM DynamischeDiagonalsummen;

  FUNCTION IndexFor(n, i, j: integer): integer;
  BEGIN (* IndexFor *)
    IndexFor := n * i + j;
  END; (* IndexFor*)

  PROCEDURE CalculateDiagonalSums(m: ARRAY of integer; n: integer; var d: ARRAY of integer);
    var i, j: integer;
  BEGIN (* CalculateDiagonalSums *)
    
    FOR i := Low(d) TO High(d) DO BEGIN
      j := n * i;
      WHILE (j <= High(m)) DO BEGIN
        d[i] := d[i] + m[j];
        j := j + n + 1;
      END; (* WHILE *)
    END; (* FOR *)

  END; (* CalculateDiagonalSums *)

  var size: integer;
      mLength: integer;
      matrix: ARRAY of integer;
      d: ARRAY of integer;
      i: integer;
    
BEGIN (* DynamischeDiagonalsummen *)
  
  Write('Geben Sie die groesse der Matrix ein: ');
  Read(size);
  mLength := size * size;
  SetLength(matrix, mLength);
  SetLength(d, size);

  FOR i := 0 TO mLength - 1 DO BEGIN
    Read(matrix[i]);
  END; (* FOR *)

  CalculateDiagonalSums(matrix, size, d);

  Write('Diagonalsummen: ');
  FOR i := Low(d) TO High(d) DO BEGIN
    IF (i = High(d)) THEN BEGIN
      Write(d[i]);
    END ELSE BEGIN
      Write(d[i], ', ');
    END; (* IF *)
    
  END; (* FOR *)

END. (* DynamischeDiagonalsummen *)