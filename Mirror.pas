PROGRAM MirrorText;

  FUNCTION ShortenString(s: string): string;
    BEGIN (* ShortenString *)
      Delete(s, Length(s), 1);
      ShortenString := s;
    END; (* ShortenString *)

  FUNCTION Mirror(s: string): string;
    BEGIN (* Mirror *)
      if Length(s) > 1 then
        Mirror := s[Length(s)] + Mirror(ShortenString(s))
      else
        Mirror := s;
    END; (* Mirror *)

BEGIN (* Mirror *)
  WriteLn(Mirror('test'));
  WriteLn(Mirror('this is a test sentence'));
END. (* Mirror *)