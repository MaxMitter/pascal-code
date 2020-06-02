PROGRAM UnitTest;
  USES StringSetUnit;

  FUNCTION IntToString(x: INTEGER): STRING;
    VAR s: STRING;
    BEGIN (* IntToString *)
      Str(x, s);
      IntToString := s;
  END; (* IntToString *)

  VAR s1, t: StringSet;
      s2: StringSetObj;
      i: INTEGER;

BEGIN (* UnitTest *)
  New(s1, Init(5));
  s2.Init(5);

  FOR i := 1 TO 5 DO BEGIN
    s1^.Add(IntToString(i));
    s2.Add(IntToString(i+3));
  END; (* FOR *)

  s1^.Test;
  s2.Test;

  WriteLn('Removing 1, 5, 7: ');

  s1^.Remove('1');
  s1^.Remove('5');
  s1^.Remove('7');

  WriteLn('Removed 1, 5, 7: ');
  s1^.Test;

  t := Difference(s1, @s2);
  WriteLn('Difference:');
  t^.Test;

  Dispose(s1, Done);
  s2.Done;
  Dispose(t, Done);
END. (* UnitTest *)