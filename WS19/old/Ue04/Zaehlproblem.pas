PROGRAM Zaehlproblem;
  const
    MAX = 100;
  type
    IntegerArray = ARRAY [1..MAX] OF integer;

  FUNCTION DifferentValues(a: IntegerArray; n: integer): integer;

    var i, numberOfIntegers: integer;

  BEGIN (* DifferentValues *)
    numberOfIntegers := 0;

    FOR i := 1 TO n DO BEGIN
      IF (i > 1) THEN BEGIN
        IF (a[i] = a[i - 1]) THEN BEGIN
          continue;
          END ELSE BEGIN
            Inc(numberOfIntegers);
        END; (* IF *)
        END ELSE BEGIN
          Inc(numberOfIntegers);
      END; (* IF *)
    END; (* FOR i *)

    DifferentValues := numberOfIntegers;
  END; (* DifferentValues *)

  var n, i: integer;
  var arr: IntegerArray;

BEGIN (* Zaehlproblem *)
  Write('n: ');
  Read(n);
  Write('Zahlen: ');
  
  FOR i := 1 TO n DO BEGIN
    Read(arr[i]);
  END; (* FOR *)

  Write('Anzahl Zahlen: ', DifferentValues(arr, n));
END. (* Zaehlproblem *)