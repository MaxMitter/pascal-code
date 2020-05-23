(* MPC:                                                      SWa, 2020-05-06 *)
(* ----                                                                      *)
(* MiniPascal compiler.                                                      *)
(* ========================================================================= *)
PROGRAM MPC;
  USES
    MPL, MPPC, CodeDef, CodeGen, CodeInt, CodeDis;
  
  VAR
    inputFilePath: STRING;
    ca: CodeArray;
    ok: BOOLEAN;
 
BEGIN (* MPC *)
  IF (ParamCount = 1) THEN BEGIN
    inputFilePath := ParamStr(1);
  END ELSE BEGIN
    Write('MiniPascal source file > ');
    ReadLn(inputFilePath);
  END; (* IF *)

  InitLex(inputFilePath);

  S;

  IF (success) THEN BEGIN
    WriteLn('parsing completed: success');
    GetCode(ca);
    DisassembleCode(ca);
    StoreCode(inputFilePath + 'c', ca);
    
    // MiniPascal virtual Machine:
    LoadCode(inputFilePath + 'c', ca, ok);
    IF (NOT ok) THEN BEGIN
      WriteLn('ERROR: cannot open mpc file');
      HALT;
    END; (* IF *)
    InterpretCode(ca);
  END ELSE BEGIN
    WriteLn('parsing failed. ERROR at position (', syLineNr, ',', syColNr, ')');
  END; (* IF *)
END. (* MPC *)
