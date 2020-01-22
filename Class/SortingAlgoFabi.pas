PROGRAM SortingAlgorithms;

TYPE IntArray = ARRAY [1..100] OF INTEGER;

VAR
  numComp, numAssign: LONGINT;

(* Less Than *)
FUNCTION LT(a, b: INTEGER): BOOLEAN;
BEGIN (* LT *)
  Inc(numComp);
  LT := a < b;
END; (* LT *)

PROCEDURE Swap(VAR a, b: INTEGER);
VAR t: INTEGER;
BEGIN (* Swap *)
  t := a;
  a := b;
  b := t;
  Inc(numAssign,3);
END; (* Swap *)

PROCEDURE SelectionSort(VAR arr: IntArray; left, right: INTEGER);
VAR i, j, minIdx: INTEGER;
BEGIN (* SelectionSort *)
  FOR i := left TO right - 1 DO BEGIN
    minIdx := i;
    FOR j := i + 1 to right DO BEGIN
      IF LT(arr[j], arr[minIdx]) THEN minIdx := j;
    END; (* FOR *)
    IF (i <> minIdx) THEN Swap(arr[i], arr[minIdx]);
  END; (* FOR *)
END; (* SelectionSort *)

VAR
  arr: IntArray;
  i, j : INTEGER;

BEGIN

  numAssign := 0;
  numComp := 0;

  for i := 1 to 100 do begin
    arr[i] := Random(100);
  end;

  SelectionSort(arr, 1, 100);

  for i := 1 to 100 do begin
    Write(arr[i], ', ');
  end;

  WriteLn();
  WriteLn(numComp);
  WriteLn(numAssign);

END.