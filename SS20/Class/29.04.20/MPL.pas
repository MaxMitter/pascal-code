(* MPL:                                                       MM, 2020-04-29 *)
(* ------                                                                    *)
(* MiniPascal scanner                                                        *)
(* ========================================================================= *)

UNIT MPL;

INTERFACE

  TYPE
    Symbol = (errSy, eofSy,
              programSy, varSy, beginSy, endSy,
              readSy, writeSy, integerSy,
              semcolSy, colonSy, commaSy, dotSy,
              assignSy,
              plusSy, minusSy, timesSy, divSy,
              leftParSy, rightParSy,
              ident, number);

  VAR
    sy: Symbol;
    numberVal: INTEGER;
    identStr: STRING;
  
  PROCEDURE NewSy;
  PROCEDURE InitLex(inputFilePath: STRING);

IMPLEMENTATION

  CONST
    EOF_CH = Chr(26);
    TAB_CH = Chr(9);

  VAR
    inputFile: TEXT;
    line: STRING;
    linePos: INTEGER;
    ch: CHAR;

  PROCEDURE NewCh;
    BEGIN (* NewCh *)
      Inc(linePos);
      IF (linePos > Length(line)) THEN BEGIN
        IF (NOT Eof(inputFile)) THEN BEGIN
          ReadLn(inputFile, line);
          linePos := 0;
          ch := ' ';
        END ELSE BEGIN
          ch := EOF_CH;
          line := '';
          linePos := 0;
        END; (* IF *)
      END ELSE BEGIN
        ch := line[linePos];
      END; (* IF *)
  END; (* NewCh *)

  PROCEDURE NewSy;
    BEGIN (* NewSy *)
      WHILE (ch = ' ') OR (ch = TAB_CH) DO BEGIN
        NewCh;
      END; (* WHILE *)

      CASE ch OF
        '+': BEGIN sy := plusSy; NewCh; END;
        '-': BEGIN sy := minusSy; NewCh; END;
        '*': BEGIN sy := timesSy; NewCh; END;
        '/': BEGIN sy := divSy; NewCh; END;
        ':': BEGIN 
              NewCh;
              IF (ch = '=') THEN BEGIN
                sy := assignSy;
                NewCh;
              END ELSE BEGIN
                sy := colonSy;
              END;
             END;
        ';': BEGIN sy := semcolSy; NewCh; END;
        ',': BEGIN sy := commaSy; NewCh; END;
        '.': BEGIN sy := dotSy; NewCh; END;
        '(': BEGIN sy := leftParSy; NewCh; END;
        ')': BEGIN sy := rightParSy; NewCh; END;
        EOF_CH: BEGIN sy := eofSy; END;
        '0'..'9': BEGIN
                    sy := number;
                    numberVal := 0;
                    WHILE ((ch >= '0') AND (ch <= '9')) DO BEGIN
                      numberVal := numberVal * 10 + Ord(ch) - Ord('0');
                      NewCh;
                    END; (* WHILE *)
                  END;
        'a'..'z','A'..'Z','_': BEGIN
                                  identStr := '';
                                  WHILE (ch in ['a'..'z','A'..'Z','_','0'..'9']) DO BEGIN
                                    identStr := identStr + ch;
                                    NewCh; 
                                  END; (* WHILE *)
                                  identStr := Upcase(identStr);
                                  
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
                               END;
      ELSE
        sy := errSy;
      END; (* CASE *)
  END; (* NewSy *)

  PROCEDURE InitLex(inputFilePath: STRING);
    BEGIN (* InitLex *)
      Assign(inputFile, inputFilePath);
      Reset(inputFile);
      line := '';
      linePos := 0;
      NewCh;
      NewSy;
  END; (* InitLex *)  

BEGIN (* MPL *)
  
END. (* MPL *)