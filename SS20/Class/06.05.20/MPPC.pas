(* MPPC:                                                      MM, 2020-04-29 *)
(* -----                                                                     *)
(* MiniPascal parser with semantics for compilation.                         *)
(* ========================================================================= *)
UNIT MPPC;

INTERFACE
  VAR
    success: BOOLEAN;

  PROCEDURE S;

IMPLEMENTATION
  USES
    MPL, SymTab, CodeDef, CodeGen;

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
  PROCEDURE Fact(VAR f: INTEGER); FORWARD;
  
  PROCEDURE S;
  BEGIN (* S *)
    success := TRUE;
    MP; IF (NOT success) THEN Exit;
    IF (SyIsNot(eofSy)) THEN Exit;
  END; (* S *)
 
  PROCEDURE MP;
  BEGIN (* MP *)
    (* SEM *) InitSymbolTable; (* ENDSEM *)
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
    VAR
      ok: BOOLEAN;
  BEGIN (* VarDecl *)
    IF (SyIsNot(varSy)) THEN Exit;
    NewSy;
    IF (SyIsNot(ident)) THEN Exit;
    (* SEM *)
      DeclVar(identStr, ok);
      IF (NOT ok) THEN SemErr('help im lost');
    (* ENDSEM *)
    NewSy;

    WHILE (sy = commaSy) DO BEGIN
      NewSy;
      IF (SyIsNot(ident)) THEN Exit;
      (* SEM *)
        DeclVar(identStr, ok);
        IF (NOT ok) THEN BEGIN
          SemErr('multiple declaration of same variable'); Exit;
        END; (* IF *)
      (* ENDSEM *)
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
    VAR
      destId: STRING;
  BEGIN (* Stat *)
    CASE sy OF
      ident:   BEGIN (* assignment *)
                 (* SEM *) 
                   destId := identStr;
                   IF (NOT IsDecl(destId)) THEN BEGIN
                    SemErr('variable not declared'); Exit;
                  END ELSE BEGIN
                    Emit2(LoadAddrOpc, AddrOf(destId));
                   END; (* IF *)
                 (* ENDSEM *)
                 NewSy;
                 IF (SyIsNot(assignSy)) THEN Exit;
                 NewSy;
                 Expr; IF (NOT success) THEN Exit;
                 (* SEM *) IF (IsDecl(destId)) THEN Emit1(StoreOpc); (* ENSEM *)
               END; (* assignment *)
      readSy:  BEGIN (* read statement *)
                 NewSy;
                 IF (SyIsNot(leftParSy)) THEN Exit;
                 NewSy;
                 IF (SyIsNot(ident)) THEN Exit;
                 (* SEM *)
                  IF (NOT IsDecl(identStr)) THEN SemErr('variable not declared')
                  ELSE Emit2(ReadOpc, AddrOf(identStr));
                 (* ENDSEM *)
                 NewSy;
                 IF (SyIsNot(rightParSy)) THEN Exit;
                 NewSy;
               END; (* read statement *)
      writeSy: BEGIN (* write statement *)
               END; (* write statement *)
    END; (* CASE *)
  END; (* Stat *)

  PROCEDURE Expr;
    VAR
      t: INTEGER;
  BEGIN (* Expr *)
    Term; IF (NOT success) THEN Exit;
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      CASE sy OF
        plusSy: BEGIN
          NewSy;
          Term; IF (NOT success) THEN Exit;
          (* SEM *) Emit1(AddOpc); (* ENDSEM *)
        END; (* plusSy *)
        minusSy: BEGIN
          NewSy;
          Term; IF (NOT success) THEN Exit;
          (* SEM *) Emit1(SubOpc); (* ENDSEM *)
        END; (* minusSy *)
      END; (* CASE *)
    END; (* WHILE *)
  END; (* Expr *)

  PROCEDURE Term;
  
    VAR
      f: INTEGER;
  BEGIN (* Term *)
    Fact(f); IF (NOT success) THEN Exit;
    WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN
      CASE sy OF
        timesSy: BEGIN
          NewSy;
          Fact(f); IF (NOT success) THEN Exit;
          (* SEM *) Emit1(MulOpc); (* ENDSEM *)
        END; (* timesSy *)
        divSy: BEGIN
          NewSy;
          Fact(f); IF (NOT success) THEN Exit;
          (* SEM *)
            IF (f = 0) THEN BEGIN
              SemErr('division by zero'); Exit;
            END ELSE BEGIN
              Emit1(DivOpc);
            END; (* IF *)
          (* ENDSEM *)
        END; (* divSy *)
      END; (* CASE *)
    END; (* WHILE *)
  END; (* Term *)

  PROCEDURE Fact(VAR f: INTEGER);
  BEGIN (* Fact *)
    CASE sy OF
      ident: BEGIN
        (* SEM *)
          IF (NOT IsDecl(identStr)) THEN BEGIN
            SemErr('variable not declared'); Exit;
          END ELSE BEGIN
            GetVal(identStr, f);
          END; (* IF *)
        (* ENDSEM *)
        NewSy;
      END; (* ident *)
      number: BEGIN
        (* SEM *) f := numberVal; (* ENDSEM *)
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

END. (* MPPI *)
