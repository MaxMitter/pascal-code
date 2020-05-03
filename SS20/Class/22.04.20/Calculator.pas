(* Calculator:                                                MM, 2020-04-22 *)
(* ------                                                                    *)
(* Scanner and parser for computing simple arithmatic expressions            *)
(* ========================================================================= *)
PROGRAM Calculator;

  CONST
    EOF_CH = Chr(0);

  TYPE
    SymbolCode =  (noSy, (* error symbol *)
                  eofSy,
                  plusSy, minusSy, timesSy, divSy,
                  leftParSy, rightParSy,
                  number);

  VAR
    line: STRING;
    ch: CHAR;
    cnr: INTEGER;
    sy: SymbolCode;
    numberVal: INTEGER;
    success: BOOLEAN;

  PROCEDURE	S FORWARD;
  PROCEDURE Expr(VAR e: INTEGER) FORWARD;
  PROCEDURE Term(VAR t: INTEGER) FORWARD;
  PROCEDURE Fact(VAR f: INTEGER) FORWARD;

  PROCEDURE NewCh;
    BEGIN (* NewCh *)
      IF (cnr < Length(line)) THEN BEGIN
        Inc(cnr);
        ch := line[cnr];
      END ELSE BEGIN
        ch := EOF_CH;
      END; (* IF *)
  END; (* NewCh *)

  PROCEDURE NewSy;
    BEGIN (* NewSy *)
      WHILE (ch = ' ') DO BEGIN
        NewCh;
      END; (* WHILE *)

      CASE ch OF
        EOF_CH:   BEGIN sy := eofSy; END;
        '+':     BEGIN sy := plusSy; NewCh; END;
        '-':     BEGIN sy := minusSy; NewCh; END;
        '*':     BEGIN sy := timesSy; NewCh; END;
        '/':     BEGIN sy := divSy; NewCh; END;
        '(':     BEGIN sy := leftParSy; NewCh; END;
        ')':     BEGIN sy := rightParSy; NewCh; END;
        '0'..'9': BEGIN
                  sy := number;
                  numberVal := 0;
                  WHILE ((ch >= '0') AND (ch <= '9')) DO BEGIN
                    numberVal := numberVal * 10 + Ord(ch) - Ord('0');
                    NewCh;
                  END; (* WHILE *)
                 END;
        ELSE     BEGIN sy := noSy; END;
      END; (* Case *)
  END; (* NewSy *)

  (* Expr = Term { "+" | "-" Term] . *)
  PROCEDURE Expr(VAR e: INTEGER);
    VAR t: INTEGER;
    BEGIN (* Expr *)
      Term(e); IF (NOT success) THEN Exit;
      WHILE ((sy = plusSy) OR (sy = minusSy)) DO BEGIN
        CASE sy OF
          plusSy: BEGIN 
                    NewSy;
                    Term(t); IF (NOT success) THEN Exit;
                    (*SEM*) e := e + t;
                  END;
          minusSy: BEGIN 
                    NewSy;
                    Term(t); IF (NOT success) THEN Exit;
                    (*SEM*) e := e - t;
                  END;
        END; (* CASE *)
      END; (* WHILE *)
  END; (* Expr *)

  (* Term = Fact { "*" Fact | */* Fact}  . *)
  PROCEDURE Term(VAR t: INTEGER);
    VAR f: INTEGER;
    BEGIN (* Term *)
      Fact(t); IF (NOT success) THEN Exit;
      WHILE ((sy = timesSy) OR (sy = divSy)) DO BEGIN
        CASE sy OF
          timesSy: BEGIN 
                    NewSy;
                    Fact(f); IF (NOT success) THEN Exit;
                    (*SEM*) t := t * f; (*ENDSEM*)
                  END;
          divSy: BEGIN 
                    NewSy;
                    Fact(f); IF (NOT success) THEN Exit;
                    (*SEM*) t := t DIV f; (*ENDSEM*)
                  END;
        END; (* CASE *)
      END; (* WHILE *)
  END; (* Term *)

  (* Fact = number | "(" Expr ")" . *)
  PROCEDURE Fact(VAR f: INTEGER);
    BEGIN (* Fact *)
      CASE sy OF 
        number:    BEGIN
                    (*SEM*) f := numberVal; (*ENDSEM*)
                    NewSy;
                  END;
        leftParSy: BEGIN
                    NewSy;
                    Expr(f); IF (NOT success) THEN Exit;
                    IF (sy <> rightParSy) THEN BEGIN
                      success := FALSE;
                      Exit;
                    END; (* IF *)
                    NewSy;
                  END;
        ELSE BEGIN
          success := FALSE;
          Exit;
        END; (* ELSE *)
      END; (* CASE *)
  END; (* Fact *)

  PROCEDURE S;
    VAR e: INTEGER;
    BEGIN (* S *)
      Expr(e); IF (NOT success) THEN Exit;
      IF (sy <> eofSy) THEN BEGIN
        success := FALSE;
        Exit;
      END; (* IF *)
      (*SEM*) WriteLn('Result: ', e);
  END; (* S *)

BEGIN (* Calculator *)
  REPEAT
    Write('expr > ');
    ReadLn(line);

    cnr := 0;
    NewCh;
    NewSy;
    success := TRUE;
    S;

    IF (success) THEN BEGIN
      WriteLn('syntax valid');
    END ELSE BEGIN
      WriteLn('syntax error in column ', cnr);
    END; (* IF *)

    WriteLn;
  UNTIL (Length(line) = 0); (* REPEAT *)
END. (* Calculator *)