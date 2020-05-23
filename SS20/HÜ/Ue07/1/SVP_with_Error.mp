PROGRAM SVP;
  VAR
    a, b, x: INTEGER;
BEGIN
  Read(a);
  Read(b)
  x := a - b;
  IF x THEN BEGIN
    WRITE(a);
    Write(b);
  END ELSE BEGIN
    Write(0);
  END;
END. 

