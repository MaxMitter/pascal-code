(* Filter:                                                    MM, 2020-04-01 *)
(* ------                                                                    *)
(* Simple filter program for text files                                      *)
(* ========================================================================= *)

PROGRAM Filter;

  VAR
    stdOutput: TEXT;
    inputFileName, outputFileName: STRING;
    line: STRING;

  PROCEDURE CheckIOError(message: STRING);
    VAR error: INTEGER;
    BEGIN (* CheckIOError *)
      error := IOResult;

      IF (error <> 0) THEN BEGIN
        WriteLn('ERROR: ', message, '(Code: ', error, ')');
        HALT;
      END; (* IF *)
  END; (* CheckIOError *)

  PROCEDURE TransformText(VAR s: STRING);
    BEGIN (* TransformText *)
      s := UpCase(s);
  END; (* TransformText *)

BEGIN (* Filter *)
  stdOutput := output;
  IF (ParamCount > 0) THEN BEGIN //counts command line paramaters
    inputFileName := ParamStr(1);
    Assign(input, inputFileName);
    {$I-}
    Reset(input);
    CheckIOError('Cannot open input file.');
    {$I+}
  END; (* IF *)

  IF (ParamCount > 1) THEN BEGIN
    outputFileName := ParamStr(2);
    Assign(output, outputFileName);
    {$I-}
    Rewrite(output);
    CheckIOError('Cannot write to output file.');
    {$I+}
  END; (* IF *)

  REPEAT
    ReadLn(input, line);
    TransformText(line);
    WriteLn(output, line);
  UNTIL (Eof(input)); (* REPEAT *)


  IF (ParamCount > 0) THEN
    Close(input);

  IF (ParamCount > 1) THEN
    Close(output);
  
  output := stdOutput;

  WriteLn('Done!');
END. (* Filter *)