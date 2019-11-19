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

  const stringToTrim = 'Lorem';
        subString = 'Lorem';

BEGIN (* Main *)
  WriteLn('To Trim: ', stringToTrim);
  WriteLn('Output: ', Trim(stringToTrim));
  WriteLn('Delete ', subString, ' from ', stringToTrim);
  Write('Output: ', DeleteSubString(stringToTrim, subString));
END.