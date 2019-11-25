PROGRAM SplitProg;

  const splitChar = '/';

FUNCTION WithoutLastChar(s: string): string;
  var str: string;
      i: integer;
BEGIN (* WithoutLastChar *)
  if Length(s) > 0 then
    SetLength(s, Length(s) - 1);

  WithoutLastChar := s;
END; (* WithoutLastChar *)

FUNCTION EqualsIgnoreCase(a, b: string): boolean;
BEGIN (* EqualsIgnoreCase *)
  if Upcase(a) = Upcase(b) then begin
    EqualsIgnoreCase := true;
  end else begin
    EqualsIgnoreCase := false;
  end; (* IF *) 
END; (* EqualsIgnoreCase *)

PROCEDURE ClearArray(var words: array of string);
  var i: integer;
BEGIN (* ClearArray *)
  for i := Low(words) to High(words) do BEGIN
    words[i] := '';
  END; (* FOR *)
END; (* ClearArray *)

PROCEDURE Split(s: string; var words: array of string; var nrOfWords: integer);

  var i, wordsPos: integer;
BEGIN (* Split *)
  nrOfWords := 0;
  wordsPos := Low(words);

  for i := 1 to Length(s) do BEGIN
    if s[i] <> splitChar then BEGIN
      words[wordsPos] := words[wordsPos] + s[i];
    end else if s[i] = splitChar then BEGIN
      if s[i - 1] <> splitChar then
        Inc(wordsPos);
    END; (* IF *)
  END; (* FOR *)
  nrOfWords := wordsPos + 1;
END; (* Split *)


  var words: array[1..100] of string;
      nrWords, i: integer;
      s: string;
BEGIN

  WriteLn(EqualsIgnoreCase('Pascal', 'paScAL'));
  WriteLn(EqualsIgnoreCase('tESt', 'test'));
  WriteLn(EqualsIgnoreCase('test', 'teSt2'));
  Write(WithoutLastChar('Hello World'));

  REPEAT
    ClearArray(words);
    Write('Text: '); ReadLn(s);
    Split(s, words, nrWords);

    for i := 1 to nrWords do BEGIN
      if (Pos(splitChar, words[i]) = 0) AND (Length(words[i]) > 0) then
        WriteLn(i, ': ', words[i]);
    END; (* FOR *)
  UNTIL s = '';
  (* SplitProg.exe < test.txt *)

END.