UNIT KaffeeautomatMod;


INTERFACE

TYPE Coins = RECORD
                OneEuro: integer;
                FiftyCent: integer;
                TenCent: integer;
              END;

VAR errNotEnoughChange: integer;
    coinsInput: Coins;
    coinsOutput: Coins;

PROCEDURE ResetMachine;
PROCEDURE CoffeeButtonPressed(input: Coins; var change: Coins);

IMPLEMENTATION

  
  const coffeePrize = 40;

  var totalChange: Coins;
      totalCredit: integer;
      changeBank: Coins;

  PROCEDURE ResetMachine;

  BEGIN
    coinsInput.OneEuro := 0;
    coinsInput.FiftyCent := 0;
    coinsInput.TenCent := 0;
    totalChange.OneEuro := 0;
    totalChange.FiftyCent := 0;
    totalChange.TenCent := 0;
    totalCredit := 0;
  END;

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
  BEGIN
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
  END;

BEGIN (* KaffeeautomatMod *)
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
END. (* KaffeeautomatMod *)