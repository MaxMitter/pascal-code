FUNCTION F(m: MATRIX): REAL;
	Var i, j: integer; s: real;
	BEGIN
		s := 0.0;
		i := 1;
		While i <= rows do begin
			j := 1;
      While j <= cols do begin
        s := s + m[i,j] * m[i,j];
        j := j + 1;
      end;
      i := i + 1;
    end;
    F := Sqrt(s);
  END;

FUNCTION FShort(m: MATRIX): real;
  var i, j: integer;
      s: real;
  BEGIN
    s := 0.0;
    i := 1; j := 1;
    while i <= ROWS do begin
      s := s + m[i, j] * m[i, j];
      j := j + 1;
      if j > COLS then begin
        j := 1;
        i := i + 1;
      end;
    end;
    FShort := Sqrt(s);
  END;