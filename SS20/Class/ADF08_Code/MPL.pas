(* MPL:                                                      SWa, 2020-04-29 *)
(* ------                                                                    *)
(* MiniPascal scanner.                                                       *)
(* ========================================================================= *)
UNIT MPL;

INTERFACE
  TYPE
    Symbol = (errSy, eofSy,
              programSy, varSy, beginSy, endSy,
              readSy, writeSy, integerSy,
              semicolonSy, colonSy, commaSy, dotSy,
              assignSy,
              plusSy, minusSy, timesSy, divSy,
              leftParSy, rightParSy,
              ident, number);

  VAR
    sy: Symbol;                  (* current symbol *)
    syLineNr, syColNr: INTEGER;  (* line/column number of current symbol *)
    numberVal: INTEGER;          (* value if sy = number *)
    identStr: STRING;            (* name if sy = ident *)

  PROCEDURE InitLex(inputFilePath: STRING);
  PROCEDURE NewSy;

IMPLEMENTATION
  CONST
    EOF_CH = Chr(26);
    TAB_CH = Chr(9);

  VAR
    inputFile: TEXT;
    line: STRING;
    lineNr, linePos: INTEGER;
    ch: CHAR;

  PROCEDURE NewCh; FORWARD;

  PROCEDURE InitLex(inputFilePath: STRING);
  BEGIN (* InitLex *)
    Assign(inputFile, inputFilePath);
    Reset(inputFile);
    line := '';
    lineNr := 0;
    linePos := 0;
    NewCh;
    NewSy;
  END; (* InitLex *)

  PROCEDURE NewSy;
  BEGIN (* NewSy *)
    WHILE ((ch = ' ') OR (ch = TAB_CH)) DO BEGIN  (* skip whitespaces *)
      NewCh;
    END; (* WHILE *)
    syLineNr := lineNr;
    syColNr := linePos;

    CASE ch OF
      EOF_CH:    BEGIN sy := eofSy; END;
      '+':       BEGIN sy := plusSy; NewCh; END;
      '*':       BEGIN sy := timesSy; NewCh; END;
      '-':       BEGIN sy := minusSy; NewCh; END;
      '/':       BEGIN sy := divSy; NewCh; END;
      '(':       BEGIN sy := leftParSy; NewCh; END;
      ')':       BEGIN sy := rightParSy; NewCh; END;
      ';':       BEGIN sy := semicolonSy; NewCh; END;
      ',':       BEGIN sy := commaSy; NewCh; END;
      '.':       BEGIN sy := dotSy; NewCh; END;
      ':':       BEGIN (* colonSy / assignSy *)
                   NewCh;
                   IF (ch = '=') THEN BEGIN
                     sy := assignSy;
                     NewCh;
                   END ELSE BEGIN
                     sy := colonSy;
                  END; (* IF *)
                 END; (* colonSy / assignSy *)
      '0'..'9':  BEGIN (* number *)
                   sy := number;
                   numberVal := 0;
                   WHILE (ch >= '0') AND (ch <= '9') DO BEGIN
                     numberVal := numberVal * 10 + Ord(ch) - Ord('0');
                     NewCh;
                   END; (* WHILE *)
                 END; (* number *)
      'a'..'z',
      'A'..'Z',
      '_'      : BEGIN (* keyword / ident *)
                   identStr := '';
                   WHILE (ch IN ['a'..'z', 'A'..'Z', '_', '0'..'9']) DO BEGIN
                     identStr := identStr + ch;
                     NewCh;
                   END; (* WHILE *)
                   identStr := UpCase(identStr);
 
                   IF (identStr = 'PROGRAM') THEN BEGIN
                     sy := programSy;
                   END ELSE IF (identStr = 'BEGIN') THEN BEGIN
                     sy := beginSy;
                   END ELSE IF (identStr = 'END') THEN BEGIN
                     sy := endSy;
                   END ELSE IF (identStr = 'VAR') THEN BEGIN
                     sy := varSy;
                   END ELSE IF (identStr = 'INTEGER') THEN BEGIN
                     sy := integerSy;
                   END ELSE IF (identStr = 'READ') THEN BEGIN
                     sy := readSy;
                   END ELSE IF (identStr = 'WRITE') THEN BEGIN
                     sy := writeSy;
                   END ELSE BEGIN
                     sy := ident;
                   END; (* IF *)
                 END; (* keyword / ident *)
      ELSE       BEGIN sy := errSy; END;
    END; (* CASE *)
  END; (* NewSy *)

  PROCEDURE NewCh;
  BEGIN (* NewCh *)
    Inc(linePos);
    IF (linePos > Length(line)) THEN BEGIN
      IF (NOT Eof(inputFile)) THEN BEGIN
        ReadLn(inputFile, line);
        Inc(lineNr);
        linePos := 0;
        ch := ' ';
      END ELSE BEGIN
        ch := EOF_CH;
        line := '';
        linePos := 0;
        Close(inputFile);
      END; (* IF *)
    END ELSE BEGIN
      ch := line[linePos];
    END; (* IF *)
  END; (* NewCh *)
END. (* MPL *)
