PROGRAM Kaffeeautomat;

  TYPE Coins = RECORD
                OneEuro: integer;
                FiftyCent: integer;
                TenCent: integer;
              END;

  const coffeePrize = 40;

  var changeBank: Coins;
  var totalChange: Coins;
  var coinsInput: Coins;
  var coinsOutput: Coins;
  var totalCredit: integer;
  var errNotEnoughChange: integer;

  PROCEDURE Init;
  BEGIN (* Init *)
    changeBank.OneEuro := 0;
    changeBank.FiftyCent := 5;
    changeBank.TenCent := 10;
    coinsInput.OneEuro := 0;
    coinsInput.FiftyCent := 0;
    coinsInput.TenCent := 0;
    totalChange.OneEuro := 0;
    totalChange.FiftyCent := 0;
    totalChange.TenCent := 0;
    totalCredit := 0;
    errNotEnoughChange := 0;
  END; (* Init *)

  PROCEDURE ResetMachine;
  BEGIN (* ResetMachine *)
    coinsInput.OneEuro := 0;
    coinsInput.FiftyCent := 0;
    coinsInput.TenCent := 0;
    totalChange.OneEuro := 0;
    totalChange.FiftyCent := 0;
    totalChange.TenCent := 0;
    totalCredit := 0;
  END; (* ResetMachine *)

  FUNCTION CalculateChange(credit: integer): Coins;

  var returnCoins: Coins;
  BEGIN (* CalculateChange *)
    returnCoins.OneEuro := 0;
    returnCoins.FiftyCent := 0;
    returnCoins.TenCent := 0;

    if credit < coffeePrize then BEGIN
      WriteLn('Not enough credit. Please input at least ', (coffeePrize / 100):1:2, ' EUR.');
      CalculateChange := coinsInput;
    end else BEGIN
      credit := credit - coffeePrize; (* Removes the prize for one coffe from the total credits *)
      while (credit >= 100) AND (changeBank.OneEuro > 0) do BEGIN
        Inc(returnCoins.OneEuro);
        Dec(changeBank.OneEuro);
        credit := credit - 100;
      END; (* WHILE *)

      while (credit >= 50) AND (changeBank.FiftyCent > 0) do BEGIN
        Inc(returnCoins.FiftyCent);
        Dec(changeBank.FiftyCent);
        credit := credit - 50;
      END; (* WHILE *)

      while (credit >= 10) AND (changeBank.TenCent > 0) do BEGIN
        Inc(returnCoins.TenCent);
        Dec(changeBank.TenCent);
        credit := credit - 10;
      END; (* WHILE *)

      if credit > 0 then BEGIN
        Write('Machine has not enough change! ');
        Inc(errNotEnoughChange);
        CalculateChange := coinsInput;
      end else BEGIN
        CalculateChange := returnCoins;
      END; (* IF *)
    END; (* IF *)
  END; (* CalculateChange *)

  PROCEDURE CoffeeButtonPressed(input: Coins; var change: Coins);
  BEGIN (* CoffeeButtonPressed *)
    totalCredit := input.OneEuro * 100;
    totalCredit := totalCredit + input.FiftyCent * 50;
    totalCredit := totalCredit + input.TenCent * 10;

    changeBank.OneEuro := changeBank.OneEuro + input.OneEuro;
    changeBank.FiftyCent := changeBank.FiftyCent + input.FiftyCent;
    changeBank.TenCent := changeBank.TenCent + input.TenCent;

    if totalCredit <> coffeePrize then BEGIN
      totalChange := CalculateChange(totalCredit);
      if (totalChange.OneEuro <> input.OneEuro) OR (totalChange.FiftyCent <> input.FiftyCent)
          OR (totalChange.TenCent <> input.TenCent) then
        WriteLn('Thank you, enjoy your coffee!');
      Write('You get ');
      if totalChange.OneEuro > 0 then
        Write(totalChange.OneEuro, ' One Euro Coin(s) ');
      if totalChange.FiftyCent > 0 then
        Write(totalChange.FiftyCent, ' Fifty Cent Coin(s) ');
      if totalChange.TenCent > 0 then
        Write(totalChange.TenCent, ' Ten Cent Coin(s) ');

      Write('in change.');
    end else BEGIN
      WriteLn('Thank you, enjoy your coffee!');
    END; (* IF *)
  END; (* CoffeeButtonPressed *)

  var x: integer;
BEGIN (* Kaffeeautomat *)
  Init;

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
END. (* Kaffeeautomat *)