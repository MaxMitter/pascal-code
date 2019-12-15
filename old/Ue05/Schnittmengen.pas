PROGRAM Schnittmengen;

  const testA1: ARRAY [1..6] OF integer = (1, 2, 3, 5, 7, 13);
  const testA2: ARRAY [1..7] OF integer = (1, 3, 5, 20, 9, 13, 15);
  
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
      FOR i := 0 TO Length(a1) - 1 DO BEGIN
        FOR j := 0 TO Length(a2) - 1 DO BEGIN
          IF (a1[i] = a2[j]) THEN BEGIN
            IF (n3 <= High(a3)) THEN BEGIN
              a3[n3] := a1[i];
              Inc(n3);
            END ELSE BEGIN
              break;
            END; (* IF *)
          END; (* IF *)
        END; (* FOR *)
      END; (* FOR *)
    END; (* IF *)
  END ELSE BEGIN
    n3 := -1;
  END; (* IF *)
END; (* Intersect *)

  var zielArray: ARRAY OF integer;
      i, zielN: integer;
BEGIN (* Schnittmengen *)
  FOR i := 1 TO High(testA1) DO BEGIN
    Write(testA1[i], ' ');
  END; (* FOR *)
  WriteLn();
  FOR i := 1 TO High(testA2) DO BEGIN
    Write(testA2[i], ' ');
  END; (* FOR *)
  WriteLn();
  
  Write('Geben Sie die groesse der Schnittmenge ein: ');
  Read(zielN);
  setLength(zielArray, zielN);
  Intersect(testA1, Length(testA1), testA2, Length(testA2), zielArray, zielN);

  FOR i := 0 TO ZielN - 1 DO BEGIN
    Write(zielArray[i], ', ');
  END; (* FOR *)

  WriteLn('ZielN: ', zielN);
END. (* Schnittmengen *)