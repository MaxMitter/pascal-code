PROGRAM UnitTest;
  USES CIStringSetUnit, StringSetUnit;

  FUNCTION IntToString(x: INTEGER): STRING;
    VAR s: STRING;
    BEGIN (* IntToString *)
      Str(x, s);
      IntToString := s;
  END; (* IntToString *)

  VAR s1, t: CIStringSet;
      s2: CIStringSetObj;
      i: INTEGER;

BEGIN (* UnitTest *)
  New(s1, Init(5));
  s2.Init(5);
  s1^.Add('EINS');
  s1^.Add('zwei');
  s1^.Add('drEi');

  s2.Add('einS');
  s2.Add('ZwEi');
  s2.Add('zwei');
  s2.Add('EinS');

  s1^.Test;
  s2.Test;

  Union(s1, @s2, t);
  WriteLn('Union:');
  t^.Test;
  t^.Add('einS');
  WriteLn('Versuch, einS hinzuzufuegen:');
  t^.Test;
  Dispose(t, Done);

  Intersect(s1, @s2, t);
  WriteLn('Intersect:');
  t^.Test;
  t^.Remove('einS');
  WriteLn('Versuch, einS zu entfernen:');
  t^.Test;
  Dispose(t, Done);

  Difference(s1, @s2, t);
  WriteLn('Difference:');
  t^.Test;
  Write('Contains "einS"? ');
  WriteLn(t^.Contains('einS'));
  Write('Contains "dRei"? ');
  WriteLn(t^.Contains('dRei'));

  Dispose(s1, Done);
  s2.Done;
  Dispose(t, Done);
END. (* UnitTest *)