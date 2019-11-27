PROGRAM KaffeeautomatMitModul;
USES KaffeeautomatMod;

  var x: integer;
BEGIN (* KaffeeautomatMitModul *)

  while(errNotEnoughChange < 3) do BEGIN
    WriteLn();
    Write('Enter the amount of money you wish to input (10 for 10 Cents, 50 for 50 Cents, 1 for 1 Euro, 0 to end input): ');
    Read(x);
    While(x <> 0) do BEGIN
      IF (x = 1) THEN BEGIN
        Inc(CoinsInput.OneEuro);
      END ELSE IF (x = 50) THEN BEGIN
        Inc(CoinsInput.FiftyCent);
      END ELSE IF (x = 10) THEN BEGIN
        Inc(CoinsInput.TenCent);
      END ELSE BEGIN
        Write('Invalid input, terminating program.');
        HALT;
      END; (* IF *)

      Read(x);
    END; (* WHILE *)
    
    CoffeeButtonPressed(CoinsInput, CoinsOutput);

    ResetMachine;
  END; (* WHILE *)

  WriteLn();
  WriteLn('ERROR: Out of order!');
END. (* KaffeeautomatMitModul *)