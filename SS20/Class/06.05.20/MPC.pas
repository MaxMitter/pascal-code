(* MPC:                                                      MM, 2020-04-29 *)
(* ----                                                                      *)
(* MiniPascal compiler.                                                   *)
(* ========================================================================= *)
PROGRAM MPC;
  USES
    MPL, MPPC;
  
  VAR
    inputFilePath: STRING;
 
BEGIN (* MPI *)
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
  END ELSE BEGIN
    WriteLn('parsing failed. ERROR at position (', syLineNr, ',', syColNr, ')');
  END; (* IF *)
END. (* MPI *)
