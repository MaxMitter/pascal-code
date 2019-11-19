PROGRAM Roulette;

FUNCTION SpinTheWheel: integer;
BEGIN (* SpinTheWheel *)
  SpinTheWheel := Random(37);
END; (* SpinTheWheel *)

FUNCTION BenefitForLuckyNr(luckyNr, bet: integer): integer;
  var randNumber: integer;
BEGIN (* BenefitForLuckyNr *)
  randNumber := SpinTheWheel;

  IF (luckyNr = randNumber) THEN BEGIN
    BenefitForLuckyNr := bet * 35;
  END ELSE BEGIN
    BenefitForLuckyNr := -bet;  
  END; (* IF *)

  //Write(' LN: ', luckyNr, ' RN: ', randNumber, ' | ');
END; (* BenefitForLuckyNr *)

FUNCTION BenefitForEvenNr(bet: integer): integer;
  var randNr: integer;
BEGIN (* BenefitForEvenNr *)
  randNr := SpinTheWheel;

  IF (randNr = 0) THEN BEGIN
    BenefitForEvenNr := -bet;
  END ELSE IF (NOT(ODD(randNr))) THEN BEGIN
    BenefitForEvenNr := bet * 2 - bet;
  END ELSE BEGIN
    BenefitForEvenNr := -bet;
  END; (* IF *)
END; (* BenefitForEvenNr *)

PROCEDURE TestGameLuckyNumber(luckyNr, money: integer);

  var gamesLost, gamesWon, maxMoney, newMoney: Longint;

BEGIN (* TestGameLuckyNumber *)
  IF (luckyNr < 0) OR (luckyNr > 36) THEN BEGIN
    WriteLn('Lucky Number is not valid, terminating program.');
    HALT;
  END;

  gamesWon := 0;
  gamesLost := 0;
  maxMoney := money;
  WHILE (money > 0) DO BEGIN
    newMoney := money + BenefitForLuckyNr(luckyNr, 1);
    //WriteLn(money, ' ', newMoney);

    IF (newMoney > money) THEN BEGIN
      Inc(gamesWon);
      IF (newMoney > maxMoney) THEN BEGIN
        maxMoney := newMoney;
      END; (* IF *)
    END ELSE BEGIN
      Inc(gamesLost);
    END; (* IF *)
    money := newMoney;
  END; (* WHILE *)

  WriteLn('Games Won: ', gamesWon:9);
  WriteLn('Games Lost: ', gamesLost:9);
  WriteLn('Max Money: ', maxMoney:9);
END; (* TestGameLuckyNumber *)

PROCEDURE TestGameEven(money: integer);
  var gamesLost, gamesWon, maxMoney, newMoney: Longint;
BEGIN (* TestGameEven *)
  gamesWon := 0;
  gamesLost := 0;
  maxMoney := money;
  WHILE (money > 0) DO BEGIN
    newMoney := money + BenefitForEvenNr(1);
    //WriteLn(money, ' ', newMoney);

    IF (newMoney > money) THEN BEGIN
      Inc(gamesWon);
      IF (newMoney > maxMoney) THEN BEGIN
        maxMoney := newMoney;
      END; (* IF *)
    END ELSE BEGIN
      Inc(gamesLost);
    END; (* IF *)
    money := newMoney;
  END; (* WHILE *)

  WriteLn('Games Won: ', gamesWon:9);
  WriteLn('Games Lost: ', gamesLost:9);
  WriteLn('Max Money: ', maxMoney:9);
END; (* TestGameEven *)

  var luckyNr: integer;

BEGIN (* Roulette *)
  Randomize;
  Write('Enter your lucky number (0 - 36): ');
  Read(luckyNr);
  TestGameLuckyNumber(luckyNr, 1000);
  WriteLn;
  TestGameEven(1000);
END. (* Roulette *)