PROGRAM Candles;

  FUNCTION CalculateCandles(height: integer): integer;
    BEGIN (* CalculateCandles *)
      if height > 1 then
        CalculateCandles := 3 * CalculateCandles(height - 1) + CalculateCandles(height - 2)
      else
        CalculateCandles := 1;
    END; (* CalculateCandles *)

  FUNCTION CalculateCandlesIterative(height: integer): integer;
    var sum, i, prev: integer;
    BEGIN (* CalculateCandlesIterative *)
      if height > 0 then begin
        sum := 1;
        prev := 0;
        for i := 1 to height do begin
          sum := sum + prev * 3;
          prev := sum - prev;
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