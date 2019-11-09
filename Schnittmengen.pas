PROGRAM Schnittmengen;

  const testA1: ARRAY [1..6] OF integer = (1, 2, 3, 5, 7, 13);
  const testA2: ARRAY [1..5] OF integer = (1, 3, 5, 7, 9);
  
FUNCTION IsSorted(a: ARRAY of integer): boolean;
  var i: integer;
BEGIN (* IsSorted *)
  FOR i := 1 TO Length(a) - 1 DO BEGIN
    IF (a[i] >= a[i-1]) THEN BEGIN
      //
    END ELSE BEGIN
      Exit(false);
    END; (* IF *)
  END; (* FOR *)
  IsSorted := true;
END; (* IsSorted *)

PROCEDURE Intersect(a1: ARRAY of integer; n1: integer;
                    a2: ARRAY of integer; n2: integer; var a3: ARRAY of integer; var n3: integer);

  var i, j: integer;

BEGIN (* Intersect *)
  n3 := 0;

  IF (IsSorted(a1) AND IsSorted(a2)) THEN BEGIN
    //
  END ELSE BEGIN
    n3 := -1;
    Exit();  
  END; (* IF *)

  IF (Length(a1) > Length(a2)) THEN BEGIN
    FOR i := 0 TO Length(a2) - 1 DO BEGIN
      FOR j := 0 TO Length(a1) - 1 DO BEGIN
        IF (a2[i] = a1[j]) THEN BEGIN
          IF (n3 <= High(a3)) THEN BEGIN
            a3[n3] := a2[i];
            Inc(n3);
          END ELSE BEGIN
            break;
          END; (* IF *)
        END; (* IF *)
      END; (* FOR *)
    END; (* FOR *)
  END ELSE BEGIN
  END; (* IF *)

END; (* Intersect *)
  const max = 3;
  var zielArray: ARRAY [1..max] OF integer;
      i, zielN: integer;
BEGIN (* Schnittmengen *)
  Intersect(testA1, Length(testA1), testA2, Length(testA2), zielArray, zielN);

  FOR i := 1 TO ZielN DO BEGIN
    Write(zielArray[i], ', ');
  END; (* FOR *)

  WriteLn('ZielN: ', zielN);
END. (* Schnittmengen *)