(* Morse:                                                     MM, 2020-04-09 *)
(* ------                                                                    *)
(* A Program do encode and decode morse messages                             *)
(* ========================================================================= *)

PROGRAM Morse;
USES
  MorseTreeUnit;

  CONST
    WORD_SEPARATOR = ';';
    SENTENCE_SEPATATOR = '$';

  PROCEDURE CheckIOError(message: STRING);
    VAR error: INTEGER;
    BEGIN (* CheckIOError *)
      error := IOResult;

      IF (error <> 0) THEN BEGIN
        WriteLn('ERROR: ', message, '(Code: ', error, ')');
        HALT;
      END; (* IF *)
  END; (* CheckIOError *)

  PROCEDURE Replace(VAR s: STRING; toReplace, replaceBy: CHAR);
    VAR i: INTEGER;
    BEGIN (* Replace *)
      FOR i := 1 TO Length(s) DO BEGIN
        IF (s[i] = toReplace) THEN
          s[i] := replaceBy;
      END; (* FOR *)
  END; (* Replace *)

  PROCEDURE Transform(t: Tree; VAR line: STRING; toMorse: BOOLEAN);
    VAR s, code: STRING;
        i, j: INTEGER;
        n: NodePtr;
    BEGIN (* Transform *)
      IF (toMorse) THEN BEGIN
        line := Upcase(line);
        s := '';
        FOR i := 1 TO Length(line) DO BEGIN
          IF (line[i] = ' ') THEN BEGIN
            s := Copy(s, 1, Length(s) - 1) + WORD_SEPARATOR;
          END ELSE IF (line[i] = '.') THEN BEGIN
            s := Copy(s, 1, Length(s) - 1) + SENTENCE_SEPATATOR;
          END ELSE BEGIN
            n := FindNode(t, line[i]);
            s := s + n^.fullCode + ' ';
          END; (* IF *)
        END; (* FOR *)
      END ELSE BEGIN
        s := '';
        i := 1;
        REPEAT
          j := 0;
          WHILE ((line[i + j] <> ' ') AND (line[i + j] <> WORD_SEPARATOR) AND (line[i + j] <> SENTENCE_SEPATATOR)) DO BEGIN
            Inc(j);
          END; (* WHILE *)
          code := Copy(line, i, j);
          n := FindNodeByCode(t, code, 1);
          s := s + n^.letter;
          IF (line[i + j] <> ' ') THEN
            s := s + line[i + j];
          i := i + j + 1;
        UNTIL (i >= Length(line)); (* REPEAT *)

        Replace(s, WORD_SEPARATOR, ' ');
        Replace(s, SENTENCE_SEPATATOR, '.');
      END; (* IF *)

      line := s;
  END; (* Transform *)

  VAR stdOutput: TEXT;
    morseFile: TEXT;
    inputFileName, outputFileName: STRING;
    line, code: STRING;
    t: Tree;

BEGIN (* Morse *)
  t := NewNode('$', 'Placeholder');
  stdOutput := output;

  Assign(morseFile, 'morsecode.txt');
  {$I-}
  Reset(morseFile);
  CheckIOError('Cannot open morsecode file. Does it exist?');
  {$I+}

  REPEAT
    ReadLn(morseFile, line);
    code := Copy(line, 3, Length(line) - 2);
    Insert(t, NewNode(line[1], code));
  UNTIL (Eof(morseFile)); (* REPEAT *)

  //WriteTreePreOrder(t);

  inputFileName := ParamStr(2);
  Assign(input, inputFileName);
  {$I-}
  Reset(input);
  CheckIOError('Cannot open input file');
  {$I+}

  outputFileName := ParamStr(3);
  Assign(output, outputFileName);
  {$I-}
  Rewrite(output);
  CheckIOError('Cannot write to output file.');
  {$I+}

  IF (ParamStr(1) = '-m') THEN BEGIN
    REPEAT
      ReadLn(input, line);
      Transform(t, line, TRUE);
      WriteLn(output, line);
    UNTIL (Eof(input)); (* REPEAT *)
  END ELSE IF (ParamStr(1) = '-t') THEN BEGIN
    REPEAT
      ReadLn(input, line);
      Transform(t, line, FALSE);
      WriteLn(output, line);
    UNTIL (Eof(input)); (* REPEAT *)
  END; (* IF *)


  Close(input);
  Close(output);
  Close(morseFile);
  output := stdOutput;
  WriteLn('Done!');
END. (* Morse *)