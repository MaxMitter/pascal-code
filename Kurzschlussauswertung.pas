PROGRAM Kurzschlussauswertung;

FUNCTION IsElementFullEval(a: array of integer; x: integer): boolean;
  var i: integer;
BEGIN
  (*$B+*)
  i := 0;
  WHILE (i <= High(a)) AND (a[i] <> x) DO BEGIN
    i := i + 1;
  END; (* WHILE *)
  IsElementFullEval := (i <= High(a));
  (*$B-*)
END; (* IsElementFullEval *)

FUNCTION IsElementFullEvalNoError(a: array of integer; x: integer): boolean;
  var i: integer;
BEGIN
  (*$B+*)
  i := 0;
  WHILE (i <= High(a)) DO BEGIN
    IF a[i] <> x THEN BEGIN
      i := i + 1;
    END ELSE BEGIN
      break;
    END;
  END; (* WHILE *)
  IsElementFullEvalNoError := (i <= High(a));
  (*$B-*)
END; (* IsElementFullEval *)

FUNCTION IsElement(a:array of integer; x: integer): boolean;
  var i: integer;
BEGIN
  i := 0;
  WHILE (i <= High(a)) AND (a[i] <> x) DO BEGIN
    i := i + 1;
  END; (* WHILE *)
  IsElement := (i <= High(a));
END; (* IsElement *)

  var testArray: ARRAY [1..10] of integer;
      testNumber: integer;
      i: integer;
BEGIN (* Main *)
  Randomize;
  FOR i := Low(testArray) TO High(testArray) DO BEGIN
    testArray[i] := Random(10);
  END; (* FOR *)

  Write('Please enter a test number (1-9): ');
  Read(testNumber);

  FOR i := Low(testArray) TO High(testArray) DO BEGIN
    Write(testArray[i], ', ');
  END; (* FOR *)
  Write('Found test number? ', IsElementFullEvalNoError(testArray, testNumber));
END.