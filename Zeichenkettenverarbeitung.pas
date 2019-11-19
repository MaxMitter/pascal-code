PROGRAM Zeichenkettenverarbeitung;

FUNCTION DeleteSubString(str, subStr: string): string;

BEGIN
  WHILE Pos(subStr, str) <> 0 DO BEGIN
    Delete(str, Pos(subStr, str), Length(subStr));
  END; (* WHILE *)

  DeleteSubString := str;
END; (* DeleteSubString *)

FUNCTION Trim(s: string): string;

BEGIN
  Trim := DeleteSubString(s, ' ');
END; (* Trim *)

  var str: string;
BEGIN (* Main *)
  Write('Please Enter string to trim: ');
  ReadLn(str);

  Write(Trim('asdf adsfasdf  asdfs fsa'));

  Write(DeleteSubString('Test string mucho gay', 'gay'));
END.