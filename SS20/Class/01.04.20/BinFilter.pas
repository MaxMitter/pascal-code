(* BinFilter:                                                 MM, 2020-04-01 *)
(* ------                                                                    *)
(* Simple filter program for binary files                                    *)
(* ========================================================================= *)

PROGRAM BinFilter;

  CONST
    BUFFER_SIZE = 10240;

  TYPE
    BufferType = ARRAY [1..BUFFER_SIZE] OF CHAR;

  PROCEDURE CheckIOError(message: STRING);
    VAR error: INTEGER;
    BEGIN (* CheckIOError *)
      error := IOResult;

      IF (error <> 0) THEN BEGIN
        WriteLn('ERROR: ', message, '(Code: ', error, ')');
        HALT;
      END; (* IF *)
  END; (* CheckIOError *)

  PROCEDURE Transform(VAR b: BufferType; size: INTEGER);
    VAR i: INTEGER;
    BEGIN (* TransformText *)
      FOR i := 1 TO size DO BEGIN
        b[i] := UpCase(b[i]);
      END; (* FOR *)
  END; (* TransformText *)

  VAR
    inputFileName, outputFileName: STRING;
    inputFile, outputFile: FILE;
    readBytes, writtenBytes: LONGINT;
    blocksRead, blocksWritten: LONGINT;
    buffer: BufferType;

BEGIN (* BinFilter *)
  IF (ParamCount <> 2) THEN BEGIN
    WriteLn('ERROR: Invalid number of arguments.');
    WriteLn('Usage: BinFilter.exe <input.dat> <output.dat>');
    HALT;
  END; (* IF *)

  inputFileName := ParamStr(1);
  Assign(inputFile, inputFileName);
  {$I-}
  Reset(inputFile, 1);
  CheckIOError('Cannot open input file.');
  {$I+}

  outputFileName := ParamStr(2);
  Assign(outputFile, outputFileName);
  {$I-}
  Rewrite(outputFile);
  CheckIOError('Cannot write to output file.');
  {$I+}

  blocksRead := 0;
  blocksWritten := 0;

  BlockRead(inputFile, buffer, BUFFER_SIZE, readBytes);
  Inc(blocksRead);

  WHILE (readBytes > 0) DO BEGIN
    Transform(buffer, readBytes);
    BlockWrite(outputFile, buffer, readBytes, writtenBytes);
    Inc(blocksWritten);
    IF (readBytes <> writtenBytes) THEN BEGIN
      WriteLn('ERROR: Number of written Bytes and read Bytes not equal');
      HALT;
    END; (* IF *)
    BlockRead(inputFile, buffer, BUFFER_SIZE, readBytes);
    Inc(blocksRead);
  END; (* WHILE *)

  Close(inputFile);
  Close(outputFile);

  WriteLn('Status: ', blocksRead, ' block read, ', blocksWritten, ' block written.');
END. (* BinFilter *)