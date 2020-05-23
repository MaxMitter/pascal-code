(* MPPC:                                                SWa, MM, 2020-05-20 *)
(* -----                                                                    *)
(* MidiPascal parser with semantics for compilation.                        *)
(* ======================================================================== *)
UNIT MPPC;

INTERFACE
  VAR
    success: BOOLEAN;

  PROCEDURE S;

IMPLEMENTATION
  USES
    MPL, SymTab, CodeDef, CodeGen, syntaxtree;

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
  PROCEDURE Expr(VAR e: SynTree); FORWARD;
  PROCEDURE Term(VAR t: SynTree); FORWARD;
  PROCEDURE Fact(VAR f: SynTree); FORWARD;
  
  PROCEDURE S;
    BEGIN (* S *)
      success := TRUE;
      MP; IF (NOT success) THEN Exit;
      IF (SyIsNot(eofSy)) THEN Exit;
  END; (* S *)
 
  PROCEDURE MP;
    BEGIN (* MP *)
      (*SEM*)
        InitSymbolTable;
        InitCodeGenerator;
      (*ENDSEM*)
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
      (*SEM*) Emit1(EndOpc); (*ENDSEM*)

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
      (*SEM*) DeclVar(identStr, ok); (*ENDSEM*)
      NewSy;

      WHILE (sy = commaSy) DO BEGIN
        NewSy;
        IF (SyIsNot(ident)) THEN Exit;
        (*SEM*)
          DeclVar(identStr, ok);
          IF (NOT ok) THEN SemErr('variable declared multiple times');
        (*ENDSEM*)
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
      address1, address2: INTEGER;
      e: SynTree;
    BEGIN (* Stat *)
      CASE sy OF
        ident:   BEGIN (* assignment *)
                  (*SEM*)
                    destId := identStr;
                    IF (NOT IsDecl(destId)) THEN SemErr('variable not declared')
                    ELSE Emit2(LoadAddrOpc, AddrOf(destId));
                  (*ENDSEM*)
                  NewSy;
                  IF (SyIsNot(assignSy)) THEN Exit;
                  NewSy;
                  Expr(e); IF (NOT success) THEN Exit;
                  EmitCodeForExprTree(e);
                  (*SEM*) IF (IsDecl(destId)) THEN Emit1(StoreOpc); (*ENDSEM*)
                END; (* assignment *)
        readSy:  BEGIN (* read statement *)
                  NewSy;
                  IF (SyIsNot(leftParSy)) THEN Exit;
                  NewSy;
                  IF (SyIsNot(ident)) THEN Exit;
                  (*SEM*)
                    IF (NOT IsDecl(identStr)) THEN SemErr('variable not declared')
                    ELSE Emit2(ReadOpc, AddrOf(identStr));
                  (*ENDSEM*)
                  NewSy;
                  IF (SyIsNot(rightParSy)) THEN Exit;
                  NewSy;
                END; (* read statement *)
        writeSy: BEGIN (* write statement *)
                  NewSy;
                  IF (SyIsNot(leftParSy)) THEN Exit;
                  NewSy;
                  Expr(e); IF (NOT success) THEN Exit;
                  EmitCodeForExprTree(e);
                  (*SEM*) Emit1(WriteOpc); (*ENDSEM*)
                  IF (SyIsNot(rightParSy)) THEN Exit;
                  NewSy;
                END; (* write statement *)
        beginSy: BEGIN (* begin statement *)
                  NewSy;
                  StatSeq; IF (NOT success) THEN Exit;
                  IF (SyIsNot(endSy)) THEN Exit;
                  NewSy;
                  IF (SyIsNot(semiColonSy)) THEN Exit;
                END; (* begin statement *)
        ifSy:    BEGIN (* if statement *)
                  NewSy; IF (SyIsNot(ident)) THEN Exit;
                  (*SEM*)
                    IF (NOT IsDecl(identStr)) THEN SemErr('variable not declared');
                    Emit2(LoadValOpc, AddrOf(identStr));
                    Emit2(JmpZOpc, 0); (* 0 as dummy address *)
                    address1 := CurAddr - 2;
                  (*ENDSEM*)
                  NewSy; IF (SyIsNot(thenSy)) THEN Exit;
                  NewSy;
                  Stat; IF (NOT success) THEN Exit;
                  NewSy;
                  IF (SyIsNot(elseSy)) THEN Exit
                  ELSE BEGIN
                  (*SEM*)
                    Emit2(JmpOpc, 0); (* 0 as dummy address *)
                    FixUp(address1, CurAddr);
                    address1 := CurAddr - 2;
                  (*ENDSEM*)
                  NewSy;
                  Stat; IF (NOT success) THEN Exit;
                  END; (* ELSE *)
                  (*SEM*)
                    FixUp(address1, CurAddr);
                  (*ENDSEM*)
                END; (* if statement *)
        whileSy: BEGIN (* while statement *)
                  NewSy; IF (SyIsNot(ident)) THEN Exit;
                  (*SEM*)
                    IF (NOT IsDecl(identStr)) THEN SemErr('variable not declared');
                    address1 := CurAddr;
                    Emit2(LoadValOpc, AddrOf(identStr));
                    Emit2(JmpZOpc, 0); (* 0 as dummy address *)
                    address2 := CurAddr - 2;
                  (*ENDSEM*)
                  NewSy; IF (SyIsNot(doSy)) THEN Exit;
                  NewSy;
                  Stat; IF (NOT success) THEN Exit;
                  (*SEM*)
                    Emit2(JmpOpc, address1);
                    FixUp(address2, CurAddr);
                  (*ENDSEM*)
                END; (* while statement *)
      END; (* CASE *)
  END; (* Stat *)

  PROCEDURE Expr(VAR e: SynTree);
    VAR t: SynTree;
    BEGIN (* Expr *)
      Term(e); IF (NOT success) THEN Exit;
      WHILE ((sy = plusSy) OR (sy = minusSy)) DO BEGIN
        CASE sy OF
          plusSy: BEGIN
                    NewSy;
                    Term(t); IF (NOT success) THEN Exit;
                    e := TreeOf('+', e, t);
                  END;
          minusSy:  BEGIN
                      NewSy;
                      Term(t); IF (NOT success) THEN Exit;
                      e := TreeOf('-', e, t);
                    END;
        END; (* CASE *)
      END; (* WHILE *)
  END; (* Expr *)

  PROCEDURE Term(VAR t: SynTree);
    VAR f: SynTree;
    BEGIN (* Term *)
      Fact(t); IF (NOT success) THEN Exit;
      WHILE ((sy = timesSy) OR (sy = divSy)) DO BEGIN
        CASE sy OF
          timesSy: BEGIN 
                    NewSy;
                    Fact(f); IF (NOT success) THEN Exit;
                    t := TreeOf('*', t, f);
                  END;
          divSy: BEGIN 
                    NewSy;
                    Fact(f); IF (NOT success) THEN Exit;
                    t := TreeOf('/', t, f);
                  END;
        END; (* CASE *)
      END; (* WHILE *)
  END; (* Term *)

  PROCEDURE Fact(VAR f: SynTree);
    VAR n: STRING;
    BEGIN (* Fact *)
      CASE sy OF
        ident:  BEGIN
                  IF (NOT IsDecl(identStr)) THEN SemErr('variable not declared')
                  ELSE f := TreeOf(identStr, NIL, NIL);
                  NewSy;
                END;
        number:     BEGIN
                      Str(numberVal, n);
                      f := TreeOf(n, NIL, NIL);
                      NewSy;
                    END;
        leftParSy:  BEGIN
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
        END;
      END; (* CASE *)
  END; (* Fact *)

END. (* MPPC *)
