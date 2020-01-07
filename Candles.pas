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
  WriteLn(CalculateCandles(0));
  WriteLn(CalculateCandles(1));
  WriteLn(CalculateCandles(2));
  WriteLn(CalculateCandles(3));
  WriteLn(CalculateCandles(4));
  WriteLn(CalculateCandles(5));
  WriteLn(CalculateCandles(6));
  WriteLn();
  WriteLn(CalculateCandlesIterative(0));
  WriteLn(CalculateCandlesIterative(1));
  WriteLn(CalculateCandlesIterative(2));
  WriteLn(CalculateCandlesIterative(3));
  WriteLn(CalculateCandlesIterative(4));
  WriteLn(CalculateCandlesIterative(5));
  WriteLn(CalculateCandlesIterative(6));
END. (* Candles *)