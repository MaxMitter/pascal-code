(* MPP:                                                      SWa, 2020-04-29 *)
(* ------                                                                    *)
(* MiniPascal parser.                                                       *)
(* ========================================================================= *)
UNIT MPP;

INTERFACE
  VAR
    success: BOOLEAN;

  PROCEDURE S;

IMPLEMENTATION
  USES
    MPL;

  FUNCTION SyIsNot(expected: Symbol): BOOLEAN;
  BEGIN (* SyIsNot *)
    IF (sy <> expected) THEN BEGIN
      success := FALSE;
    END; (* IF *)
    SyIsNot := NOT success;
  END; (* SyIsNot *)
  
  PROCEDURE SemErr(msg: STRING);
  BEGIN (* SemErr *)
    WriteLn(' ### ERROR: ', msg);
    success := FALSE;
  END; (* SemErr *)

  PROCEDURE MP; FORWARD;
  PROCEDURE VarDecl; FORWARD;
  PROCEDURE StatSeq; FORWARD;
  PROCEDURE Stat; FORWARD;
  PROCEDURE Expr; FORWARD;
  PROCEDURE Term; FORWARD;
  PROCEDURE Fact; FORWARD;
  
  PROCEDURE S;
  BEGIN (* S *)
    success := TRUE;
    MP; IF (NOT success) THEN Exit;
    IF (SyIsNot(eofSy)) THEN Exit;
  END; (* S *)
 
  PROCEDURE MP;
  BEGIN (* MP *)
    IF (SyIsNot(programSy)) THEN Exit;
    NewSy;
    IF (SyIsNot(ident)) THEN Exit;
    NewSy;
    IF (SyIsNot(semiColonSy)) THEN Exit;
    NewSy;

    IF (sy = varSy) THEN BEGIN
      VarDecl; IF (NOT success) THEN Exit;
    END; (* IF *)

    IF (SyIsNot(beginSy)) THEN Exit;
    NewSy;

    StatSeq; IF (NOT success) THEN Exit;

    IF (SyIsNot(endSy)) THEN Exit;
    NewSy;
    IF (SyIsNot(dotSy)) THEN Exit;
    NewSy;
  END; (* MP *)

  PROCEDURE VarDecl;
  BEGIN (* VarDecl *)
    IF (SyIsNot(varSy)) THEN Exit;
    NewSy;
    IF (SyIsNot(ident)) THEN Exit;
    NewSy;

    WHILE (sy = commaSy) DO BEGIN
      NewSy;
      IF (SyIsNot(ident)) THEN Exit;
      NewSy;
    END; (* WHILE *)

    IF (SyIsNot(colonSy)) THEN Exit;
    NewSy;
    IF (SyIsNot(integerSy)) THEN Exit;
    NewSy;
    IF (SyIsNot(semiColonSy)) THEN Exit;
    NewSy;
  END; (* VarDecl *)

  PROCEDURE StatSeq;
  BEGIN (* StatSeq *)
    Stat; IF (NOT success) THEN Exit;
    WHILE (sy = semiColonSy) DO BEGIN
      NewSy;
      Stat; IF (NOT success) THEN Exit;
    END; (* WHILE *)
  END; (* StatSeq *)

  PROCEDURE Stat;
  BEGIN (* Stat *)
    CASE sy OF
      ident:   BEGIN (* assignment *)
                 NewSy;
                 IF (SyIsNot(assignSy)) THEN Exit;
                 NewSy;
                 Expr; IF (NOT success) THEN Exit;
               END; (* assignment *)
      readSy:  BEGIN (* read statement *)
                 NewSy;
                 IF (SyIsNot(leftParSy)) THEN Exit;
                 NewSy;
                 IF (SyIsNot(ident)) THEN Exit;
                 NewSy;
                 IF (SyIsNot(rightParSy)) THEN Exit;
                 NewSy;
               END; (* read statement *)
      writeSy: BEGIN (* write statement *)
                 NewSy;
                 IF (SyIsNot(leftParSy)) THEN Exit;
                 NewSy;
                 Expr; IF (NOT success) THEN Exit;
                 IF (SyIsNot(rightParSy)) THEN Exit;
                 NewSy;
               END; (* write statement *)
    END; (* CASE *)
  END; (* Stat *)

  PROCEDURE Expr;
  BEGIN (* Expr *)
    Term; IF (NOT success) THEN Exit;
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      CASE sy OF
        plusSy: BEGIN
          NewSy;
          Term; IF (NOT success) THEN Exit;
        END; (* plusSy *)
        minusSy: BEGIN
          NewSy;
          Term; IF (NOT success) THEN Exit;
        END; (* minusSy *)
      END; (* CASE *)
    END; (* WHILE *)
  END; (* Expr *)

  PROCEDURE Term;
  BEGIN (* Term *)
    Fact; IF (NOT success) THEN Exit;
    WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN
      CASE sy OF
        timesSy: BEGIN
          NewSy;
          Fact; IF (NOT success) THEN Exit;
        END; (* timesSy *)
        divSy: BEGIN
          NewSy;
          Fact; IF (NOT success) THEN Exit;
        END; (* divSy *)
      END; (* CASE *)
    END; (* WHILE *)
  END; (* Term *)

  PROCEDURE Fact;
  BEGIN (* Fact *)
    CASE sy OF
      ident: BEGIN
        NewSy;
      END; (* ident *)
      number: BEGIN
        NewSy;
      END; (* number *)
      leftParSy: BEGIN
        NewSy;
        Expr; IF (NOT success) THEN Exit;
        IF (SyIsNot(rightParSy)) THEN Exit;
        NewSy;
      END; (* leftParSy *)
      ELSE BEGIN
        success := FALSE;
        Exit;
      END; (* ELSE *)
    END; (* CASE *)
  END; (* Fact *)

END. (* MPL *)
