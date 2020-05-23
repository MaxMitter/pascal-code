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
  PROCEDURE Fact; FORWARD;
  
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
                 Expr; IF (NOT success) THEN Exit;
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
                 Expr; IF (NOT success) THEN Exit;
                 (*SEM*) Emit1(WriteOpc); (*ENDSEM*)
                 IF (SyIsNot(rightParSy)) THEN Exit;
                 NewSy;
               END; (* write statement *)
      beginSy: BEGIN (* begin statement *)
                 NewSy;
                 StatSeq; IF (NOT success) THEN Exit;
                 IF (SyIsNot(endSy)) THEN Exit;
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
                 NewSy; IF (SyIsNot(semiColonSy)) THEN Exit;
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
                 NewSy; IF (SyIsNot(semiColonSy)) THEN Exit;
               END; (* while statement *)
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
          (*SEM*) Emit1(AddOpc); (*ENDSEM*)
        END; (* plusSy *)
        minusSy: BEGIN
          NewSy;
          Term; IF (NOT success) THEN Exit;
          (*SEM*) Emit1(SubOpc); (*ENDSEM*)
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
          (*SEM*) Emit1(MulOpc); (*ENDSEM*)
        END; (* timesSy *)
        divSy: BEGIN
          NewSy;
          Fact; IF (NOT success) THEN Exit;
          (*SEM*) Emit1(DivOpc); (*ENDSEM*)
        END; (* divSy *)
      END; (* CASE *)
    END; (* WHILE *)
  END; (* Term *)

  PROCEDURE Fact;
  BEGIN (* Fact *)
    CASE sy OF
      ident: BEGIN
        (*SEM*)
          IF (NOT IsDecl(identStr)) THEN SemErr('variable not declared')
          ELSE Emit2(LoadValOpc, AddrOf(identStr));
        (*ENDSEM*)
        NewSy;
      END; (* ident *)
      number: BEGIN
        (*SEM*) Emit2(LoadConstOpc, numberVal); (*ENDSEM*)
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

END. (* MPPC *)
