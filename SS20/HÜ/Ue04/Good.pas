PROGRAM FibonacciRI;

USES
  IntStack;

CONST
  MAX = 21;

TYPE
  IntArray = ARRAY[0..MAX] of INTEGER;

CONST
  FIBONACCI: IntArray=(0, 1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765,10946);

FUNCTION Fib(n: INTEGER): INTEGER;
BEGIN
  IF n = 0 THEN
    Fib := 0
  ELSE IF n = 1 THEN
    Fib := 1
  ELSE
    Fib := Fib(n - 1) + Fib(n - 2)
END;

FUNCTION Fib1(n: INTEGER): INTEGER;
VAR
  f1, f2: INTEGER;
BEGIN
  IF n = 0 THEN
    Fib1 := 0
  ELSE IF n = 1 THEN
    Fib1 := 1
  ELSE BEGIN
    f1 := Fib1(n - 1);
    f2 := Fib1(n - 2);
    Fib1 := f1 + f2;
  END
END;

FUNCTION Fib2(n: INTEGER): INTEGER;
VAR
  state, result: INTEGER;
  f1, f2: INTEGER;
BEGIN
  state := 1;
  while (state<>0) DO BEGIN
    IF state = 1 THEN BEGIN
      IF n = 0 THEN BEGIN
        result := 0;
        state := 0;
      END ELSE IF n = 1 THEN BEGIN
        result := 1;
        state := 0
      END ELSE BEGIN
        result := Fib2(n - 1);
        state := 2;
      END
    END ELSE IF state = 2 THEN BEGIN
      f1 := result;
      result := Fib2(n-2);
      state := 3;
    END ELSE IF state = 3 THEN BEGIN
      f2 := result;
      result := f1 + f2;
      state := 0;
    END
  END;
  Fib2 := result;
END;

FUNCTION Fib3(n: INTEGER): INTEGER;
VAR
  state, result:INTEGER;
  f1, f2:INTEGER;
BEGIN
  InitStack;
  state := 1;
  while (state <> 0) DO BEGIN
    IF state = 1 THEN BEGIN
      IF n = 0 THEN BEGIN
        result := 0;
        state := 0;
      END ELSE IF n = 1 THEN BEGIN
        result := 1;
        state := 0
      END ELSE BEGIN
        Push(n);    
        Push(2);    
        n := n - 1;
        state := 1;  
      END
    END ELSE IF state = 2 THEN BEGIN
      Pop(n);     
      f1 := result;
      Push(n);     
      Push(f1);    
      Push(3);     
      n := n - 2;
      state := 1;  
    END ELSE IF state = 3 THEN BEGIN
      Pop(f1);     
      Pop(n);     
      f2 := result;
      result := f1 + f2;
      state := 0; 
    END;

    IF (state = 0) and not Empty THEN BEGIN
      Pop(state);
    END;

  END;
  Fib3 := result;
END;

VAR
  i, result:INTEGER;

BEGIN
  FOR i := 0 to MAX DO BEGIN
    result := Fib3(i);
    Write('Fib(',i,')=',result);
    IF (result <> FIBONACCI[i]) THEN
      Write('ERROR Fib(',i,')=',FIBONACCI[i]);
    WriteLn;
  END;
END.
