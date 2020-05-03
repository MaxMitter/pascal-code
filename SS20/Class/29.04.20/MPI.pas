(* MPI:                                                       MM, 2020-04-29 *)
(* ------                                                                    *)
(* MiniPascal Interpreter.                                                   *)
(* ========================================================================= *)

PROGRAM MPI;

USES MPL, MPP;

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
    WriteLn('parsing complete: success');
  END ELSE BEGIN
    WriteLn('parsing failed.');
  END; (* IF *)
END. (* MPI *)