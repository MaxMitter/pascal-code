PROGRAM Fibonacci;
  var calls: longint;
  FUNCTION Fib(n: integer): longint;
    BEGIN
      Inc(calls);
      if n <= 2 then Fib := 1 else Fib := Fib(n-1) + Fib(n-2);
    END; (* Fib *)

  FUNCTION FibRec(n: integer; fn2, fn1: longint): longint;
    BEGIN
      if n <= 2 then
        FibRec := fn1
      else
        FibRec := FibRec(n - 1, fn1, fn2 + fn1);
    END;

  FUNCTION Fib2(n: integer): longint;
    BEGIN
      Inc(calls);
      Fib2 := FibRec(n, 1, 1);
    END;

BEGIN (* Fibonacci *)
  calls := 0;
  WriteLn('Fib 6: ', Fib2(6), ' calls: ', calls);
  calls := 0;
  WriteLn('Fib 10: ', Fib2(10), ' calls: ', calls);
  calls := 0;
  WriteLn('Fib 11: ', Fib2(11), ' calls: ', calls);
  calls := 0;
  WriteLn('Fib 12: ', Fib2(12), ' calls: ', calls);
  calls := 0;
  WriteLn('Fib 13: ', Fib2(13), ' calls: ', calls);
  calls := 0;
  WriteLn('Fib 14: ', Fib2(14), ' calls: ', calls);
  calls := 0;
  WriteLn('Fib 25: ', Fib2(25), ' calls: ', calls);
END. (* Fibonacci *)