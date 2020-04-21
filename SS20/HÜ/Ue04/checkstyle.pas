(* CheckStyle:                                                MM, 2020-04-18 *)
(* ------                                                                    *)
(* Program to check consistency of coding style in pascal codes              *)
(* ========================================================================= *)
PROGRAM CheckStyle;

USES
  Multiset;

  VAR
    skipChars: StrMSet;

  PROCEDURE InsertWord(VAR ms: StrMSet; VAR w: STRING);
    VAR
      i: INTEGER;
      toDel: BOOLEAN;
    BEGIN (* InsertWord *)
      toDel := TRUE;

      FOR i := 1 TO Length(w) DO BEGIN
        IF (NOT (w[i] in ['0'..'9'])) THEN BEGIN
          toDel := FALSE;
        END; (* IF *)
      END; (* FOR *)

      IF (NOT toDel) THEN BEGIN
        Insert(ms, w);
      END; (* IF *)

      w := '';
  END; (* InsertWord *)

  PROCEDURE GetWordsFromLine(line: STRING; VAR ms: StrMSet);
    VAR
      i: INTEGER;
      skipLine: BOOLEAN;
      currWord: STRING;
    BEGIN (* GetWordsFromLine *)
      skipLine := FALSE;
      currWord := '';
      FOR i := 1 TO Length(line) DO BEGIN
        IF (NOT skipLine) THEN BEGIN
          IF (line[i] = '/') THEN BEGIN
            IF (line[i + 1] = '/') THEN BEGIN //Checks for Line comments
              skipLine := TRUE; //rest of line can be ignored
            END; (* IF *)
          END ELSE BEGIN
            IF (NOT Contains(skipChars, line[i])) THEN BEGIN
              IF (line[i] = ' ') THEN BEGIN
                IF (currWord <> '') THEN BEGIN
                  InsertWord(ms, currWord);
                END; (* IF *)
              END ELSE BEGIN
                currWord := currWord + line[i];
              END; (* IF *)
            END ELSE BEGIN
              IF (currWord <> '') THEN BEGIN
                InsertWord(ms, currWord); 
              END; (* IF *)
            END; (* IF *)
          END; (* IF *)
        END ELSE BEGIN
          IF (currWord <> '') THEN BEGIN
            InsertWord(ms, currWord); 
          END; (* IF *)
        END; (* IF *)
      END; (* FOR *)
      IF (currWord <> '') THEN BEGIN
        InsertWord(ms, currWord);
      END; (* IF *)
  END; (* GetWordsFromLine *)

  PROCEDURE CheckIOError(message: STRING);
    VAR error: INTEGER;
    BEGIN (* CheckIOError *)
      error := IOResult;

      IF (error <> 0) THEN BEGIN
        WriteLn('ERROR: ', message, '(Code: ', error, ')');
        HALT;
      END; (* IF *)
  END; (* CheckIOError *)

  PROCEDURE InitSkipChars(ms: StrMSet);
    VAR
      skipFile: TEXT;
      line: STRING;
    BEGIN (* GetSkipChars *)
      Assign(skipFile, 'skipChars.txt');
      {$I-}
      Reset(skipFile);
      CheckIOError('Cannot open skipChars.txt File. Does it exist?');
      {$I+}
      NewStrMSet(skipChars);
      REPEAT
        ReadLn(skipFile, line);
        Insert(skipChars, line);
      UNTIL (Eof(skipFile)); (* REPEAT *)
  END; (* GetSkipChars *)

  VAR
    inputFileName: STRING;
    line: STRING;
    asTyped, normalized: StrMSet;
    keys: ARRAY [1..255] OF STRING;
    keysCount: INTEGER;
    isCount, shouldCount, i: INTEGER;

BEGIN (* CheckStyle *)
  InitSkipChars(skipChars);

  IF (ParamCount <> 1) THEN BEGIN
    WriteLn('Error: Unknown number of Parameters.');
    WriteLn('Usage: CheckStyle.exe <input.pas>');
    HALT;
  END ELSE BEGIN
    inputFileName := ParamStr(1);
    Assign(input, inputFileName);
    {$I-}
    Reset(input);
    CheckIOError('Cannot open input file');
    {$I+}
  END; (* IF *)

  NewStrMSet(asTyped);
  NewStrMSet(normalized);

  REPEAT
    ReadLn(input, line);
    GetWordsFromLine(line, asTyped);
    GetWordsFromLine(UpCase(line), normalized);
  UNTIL (Eof(input)); (* REPEAT *)

  WriteLn('Cardinality':25, 'Unique':10);
  WriteLn('AsTyped: ', Cardinality(asTyped):14, CountUnique(asTyped):10);
  WriteLn('Normalized: ', Cardinality(normalized):11, CountUnique(normalized):10);

  keysCount := 1;
  ToArray(asTyped, keys, keysCount);

  FOR i := 1 TO keysCount DO BEGIN
    isCount := Count(asTyped, keys[i]);
    shouldCount := Count(normalized, UpCase(keys[i]));
    IF (isCount <> shouldCount) THEN BEGIN
      WriteLn(keys[i], ' ', isCount, ' ', shouldCount);
    END; (* IF *)
  END; (* FOR *)

END. (* CheckStyle *)