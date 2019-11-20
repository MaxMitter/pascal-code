PROGRAM SplitProg;

PROCEDURE Split(s: string; var words: array of string; var nrOfWords: integer);

  var i, wordsPos: integer;
BEGIN (* Split *)
  nrOfWords := 0;
  wordsPos := Low(words);

  for i := 1 to Length(s) do BEGIN
    if s[i] <> ' ' then BEGIN
      words[wordsPos] := words[wordsPos] + s[i];
    END; (* if *)
  END; (* FOR *)
END; (* Split *)


  var words: array[1..100] of string;
      nrWords, i: integer;
      s: string;
BEGIN
  REPEAT
    Write('Text: '); ReadLn(s);
    Split(s, words, nrWords);

    for i := 1 to nrWords do
      WriteLn(words[i]);
  UNTIL s = '';
  (* SplitProg.exe < test.txt *)

END.