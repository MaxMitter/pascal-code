PROGRAM FBS;

PROCEDURE BruteSearch(s, p : STRING;
                      VAR pos : INTEGER);
VAR
  sLen, pLen, i, j : INTEGER;
  wrongChar : BOOLEAN;
BEGIN
  sLen := Length(s); pLen := Length(p);
  i := 1; j := 1;
  wrongChar := false;
  REPEAT
    IF s[i] = p[j] THEN BEGIN
      Inc(i);
      Inc(j);
    END ELSE BEGIN
      IF ((wrongChar) OR (j = 1)) THEN BEGIN
        i := i - j + 2;
        j := 1;
      END ELSE BEGIN
        wrongChar := true;
        Inc(i);
        Inc(j);
      END; (* IF *)
    END;
  UNTIL (i > sLen) OR (j > pLen);
  IF j > pLen THEN
    pos := i - pLen
  ELSE
    pos := 0;
END; (* BruteSearch *)

  VAR i : INTEGER;
BEGIN (* FBS *)
  BruteSearch('AABC', 'ABC', i);
  WriteLn(i);
  BruteSearch('ABXZ', 'ABC', i);
  WriteLn(i);
  BruteSearch('XYAXC', 'ABC', i);
  WriteLn(i);
  BruteSearch('BBC', 'ABC', i);
  WriteLn(i);
END. (* FBS *)