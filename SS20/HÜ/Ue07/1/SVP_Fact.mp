PROGRAM SVP_Fact;
  VAR
    f, n: INTEGER;
BEGIN
  READ(n);
  f := n;
  n := n - 1;
  WHILE n DO BEGIN
    f := n * f;
    n := n - 1;
  END;
  Write(f);
END.