(* RLE:                                                       MM, 2020-04-06 *)
(* ------                                                                    *)
(* Program to encode or decode txt Files                                     *)
(* ========================================================================= *)

PROGRAM RLE;

  CONST ENDLINE_SYMBOL = '$';

  PROCEDURE CheckIOError(message: STRING);
    VAR error: INTEGER;
    BEGIN (* CheckIOError *)
      error := IOResult;

      IF (error <> 0) THEN BEGIN
        WriteLn('ERROR: ', message, '(Code: ', error, ')');
        HALT;
      END; (* IF *)
  END; (* CheckIOError *)

  FUNCTION ToString(i: INTEGER): STRING;
    VAR s: STRING;
    BEGIN (* ToString *)
      Str(i, s);
      ToString := s;
  END; (* ToString *)

  FUNCTION ToInt(s: STRING): INTEGER;
    VAR i: INTEGER;
    BEGIN (* ToInt *)
      Val(s, i);
      ToInt := i;
  END; (* ToInt *)

  PROCEDURE CompressText(VAR s: STRING);
    VAR i, count: INTEGER;
        newS: STRING;
        currChar: CHAR;
    BEGIN (* CompressText *)
      currChar := s[1];
      newS := '';
      count := 1;
      FOR i := 1 TO Length(s) DO BEGIN
        IF (s[i] = currChar) THEN BEGIN
          IF (i <> 1) THEN 
            Inc(count);
        END ELSE BEGIN
          IF (count > 2) THEN BEGIN
            newS := newS + s[i - 1] + ToString(count);
            currChar := s[i];
            count := 1;
          END ELSE IF (count = 2) THEN BEGIN
            newS := newS + s[i - 1] + s[i - 1];
              
            currChar := s[i];
            count := 1;
          END ELSE BEGIN
            newS := newS + s[i - 1];
            currChar := s[i];
            count := 1;
          END; (* IF *)
        END; (* IF *)
      END; (* FOR *)

      s := newS + ENDLINE_SYMBOL;
  END; (* CompressText *)

  PROCEDURE DecompressText(VAR s: STRING);
    VAR i, j: INTEGER;
      newS, count: STRING;
    BEGIN (* DecompressText *)
      newS := '';
      i := 1;
      WHILE (s[i] <> ENDLINE_SYMBOL) DO BEGIN
        IF (s[i + 1] in ['0'..'9']) THEN BEGIN
          IF (s[i + 2] in ['0'..'9']) THEN
            count := Copy(s, i + 1, 2)
          ELSE
            count := Copy(s, i + 1, 1);

          FOR j := 1 TO ToInt(count) DO BEGIN
            newS := newS + s[i];
          END; (* FOR *)
          IF (ToInt(count) > 9) THEN
            i := i + 3
          ELSE
            i := i + 2;
        END ELSE BEGIN
          newS := newS + s[i];
          Inc(i);
        END; (* IF *)
      END; (* WHILE *)

      s := newS + ENDLINE_SYMBOL;
  END; (* DecompressText *)

  PROCEDURE TransformText(VAR s: STRING; compressMode: BOOLEAN);
    BEGIN (* TransformText *)
      IF (compressMode) THEN BEGIN
        CompressText(s);
      END ELSE BEGIN
        DecompressText(s);
      END; (* IF *)
  END; (* TransformText *)


  VAR
    compressMode: BOOLEAN;
    stdOutput: TEXT;
    inputFileName, outputFileName: STRING;
    line: STRING;
    hasOutput: BOOLEAN;

BEGIN (* RLE *)
  stdOutput := output;
  compressMode := TRUE;
  hasOutput := TRUE;
  IF (ParamCount = 0) THEN BEGIN
    WriteLn('ERROR: No input file defined');
    WriteLn('Usage: RLE.exe [-c | -d] <input.txt> [<output.txt>]');
    HALT;
  END ELSE IF (ParamCount = 1) THEN BEGIN
    IF ((ParamStr(1) = '-c') OR (ParamStr(1) = '-d')) THEN BEGIN
      WriteLn('ERROR: No Input File defined');
      WriteLn('Usage: RLE.exe [-c | -d] <input.txt> [<output.txt>]');
      HALT;
    END ELSE BEGIN
      inputFileName := ParamStr(1);
      Assign(input, inputFileName);
      {$I-}
      Reset(input);
      CheckIOError('Cannot open input file');
      {$I+}
    END; (* IF *)
  END ELSE IF (ParamCount = 2) THEN BEGIN
    IF ((ParamStr(1) = '-c') OR (ParamStr(1) = '-d')) THEN BEGIN
      compressMode := (ParamStr(1) = '-c');
      inputFileName := ParamStr(2);
      Assign(input, inputFileName);
      {$I-}
      Reset(input);
      CheckIOError('Cannot open input file');
      {$I+}
    END ELSE BEGIN
      inputFileName := ParamStr(1);
      Assign(input, inputFileName);
      {$I-}
      Reset(input);
      CheckIOError('Cannot open input file');
      {$I+}
      outputFileName := ParamStr(2);
      Assign(output, outputFileName);
      {$I-}
      Rewrite(output);
      CheckIOError('Cannot write to output file.');
      hasOutput := TRUE;
      {$I+}
    END; (* IF *)
  END ELSE IF (ParamCount = 3) THEN BEGIN
    compressMode := (ParamStr(1) = '-c');
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
    hasOutput := TRUE;
    {$I+}
  END ELSE BEGIN
    WriteLn('ERROR: Unknown number of parameters.');
    WriteLn('Usage: RLE.exe [-c | -d] <input.txt> [<output.txt>]');
    HALT;
  END; (* IF *)

  REPEAT
    ReadLn(input, line);
    IF (line[Length(line)] <> ENDLINE_SYMBOL) THEN BEGIN
      WriteLn('Invalid End of Line Symbol. Expected "$"');
      HALT;
    END; (* IF *)
    TransformText(line, compressMode);
    WriteLn(output, line);
  UNTIL (Eof(input)); (* REPEAT *)

  Close(input);

  IF (hasOutput) THEN BEGIN
    Close(output);
  END; (* IF *)

  output := stdOutput;

  WriteLn('Done!');

END. (* RLE *)