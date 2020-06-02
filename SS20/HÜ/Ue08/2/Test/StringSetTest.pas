PROGRAM UnitTest;
  USES CIStringSetUnit, StringSetListUnit;

  FUNCTION IntToString(x: INTEGER): STRING;
    VAR s: STRING;
    BEGIN (* IntToString *)
      Str(x, s);
      IntToString := s;
  END; (* IntToString *)

  VAR s1, s2, t: CIStringSet;
      i: INTEGER;

BEGIN (* UnitTest *)
  New(s1, Init);

  s1^.Add('EINS');
  s1^.Add('zwei');
  s1^.Add('eIns');
  WriteLn(s1^.Contains('eInS'));

  s1^.Test;



  Dispose(s1, Done);
END. (* UnitTest *)