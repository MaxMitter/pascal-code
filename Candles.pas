PROGRAM Candles;

  FUNCTION CalculateCandles(height: integer): integer;
    BEGIN (* CalculateCandles *)
      if height > 1 then
        CalculateCandles := 3 * CalculateCandles(height - 1) + 1
      else if height = 1 then
        CalculateCandles := 1
      else
        CalculateCandles := 0;
    END; (* CalculateCandles *)

  FUNCTION CalculateCandlesIterative(height: integer): integer;
    var sum, i: integer;
    BEGIN (* CalculateCandlesIterative *)
      if height > 0 then begin
        sum := 0;
        for i := 1 to height do begin
          sum := 1 + sum * 3;
        end; (* FOR *)
      end else
        sum := 0;

      CalculateCandlesIterative := sum;
    END; (* CalculateCandlesIterative *)

BEGIN (* Candles *)
  WriteLn('Hoehe 0: ', CalculateCandles(0), ' Kerzen');
  WriteLn('Hoehe 1: ', CalculateCandles(1), ' Kerzen');
  WriteLn('Hoehe 2: ', CalculateCandles(2), ' Kerzen');
  WriteLn('Hoehe 3: ', CalculateCandles(3), ' Kerzen');
  WriteLn('Hoehe 4: ', CalculateCandles(4), ' Kerzen');
  WriteLn('Hoehe 5: ', CalculateCandles(5), ' Kerzen');
  WriteLn('Hoehe 6: ', CalculateCandles(6), ' Kerzen');
  WriteLn();
  WriteLn('Hoehe 0: ', CalculateCandlesIterative(0), ' Kerzen');
  WriteLn('Hoehe 1: ', CalculateCandlesIterative(1), ' Kerzen');
  WriteLn('Hoehe 2: ', CalculateCandlesIterative(2), ' Kerzen');
  WriteLn('Hoehe 3: ', CalculateCandlesIterative(3), ' Kerzen');
  WriteLn('Hoehe 4: ', CalculateCandlesIterative(4), ' Kerzen');
  WriteLn('Hoehe 5: ', CalculateCandlesIterative(5), ' Kerzen');
  WriteLn('Hoehe 6: ', CalculateCandlesIterative(6), ' Kerzen');
END. (* Candles *)