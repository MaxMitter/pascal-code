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

  PROCEDURE ReadString;
    var ch: char;
    BEGIN (* ReadString *)
      Read(ch);
      if ch <> Chr(13) then
        ReadString();
      Write(ch);
    END; (* ReadString *)

BEGIN (* Mirror *)
  { WriteLn(Mirror('test'));
  WriteLn(Mirror('this is a test sentence'));
  WriteLn(Mirror('Maximilian')); }
  Write('Please enter a word to Mirror: ');
  ReadString();
END. (* Mirror *)