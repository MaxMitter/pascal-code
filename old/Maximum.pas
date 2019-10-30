PROGRAM Maximum;

var x, y, z, out: integer;

FUNCTION Max2(x, y: integer): integer;
BEGIN (* Max2 *)
  IF (x < y) THEN BEGIN
    Max2 := y;
  END ELSE BEGIN
    Max2 := x;
  END; (* IF *)
END; (* Max2 *)

FUNCTION Max3(x, y, z: integer): integer;
BEGIN (* Max3 *)
  Max3 := Max2(Max2(x, y), z);
END; (* Max3 *)

BEGIN (* Maximum *)
  Read(x);
  Read(y);
  Read(z);

  IF (z = 0) THEN BEGIN
    out := Max2(x, y);
  END ELSE BEGIN
    out := Max3(x, y, z);
  END; (* IF *)

  Writeln('Maximum: ', out);
END. (* Maximum *)