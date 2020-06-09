PROGRAM Test;

USES VectorClass, NaturalVectorClass, PrimeVectorClass;

  PROCEDURE TestVector;
    VAR v: Vector;
      i: INTEGER;
      success: BOOLEAN;
    BEGIN (* TestVector *)
      New(v, Init);

      FOR i := 0 TO 9 DO BEGIN
        v^.Add(i - 5);
      END; (* FOR *)

      v^.WriteVector;

      WriteLn('IsFull? ', v^.IsFull);

      v^.InsertElementAt(5, 20);

      v^.WriteVector;

      v^.GetElementAt(0, success, i);
      IF (success) THEN BEGIN
        WriteLn('Position: 0 | Element: ', i);
      END ELSE BEGIN
        WriteLn('Position in Vector not found.');
      END; (* IF *)
      v^.GetElementAt(6, success, i);
      IF (success) THEN BEGIN
        WriteLn('Position: 6 | Element: ', i);
      END ELSE BEGIN
        WriteLn('Position in Vector not found.');
      END; (* IF *)
      v^.GetElementAt(23, success, i);
      IF (success) THEN BEGIN
        WriteLn('Position: 23 | Element: ', i);
      END ELSE BEGIN
        WriteLn('Position 23 in Vector not found.');
      END; (* IF *)
      v^.GetElementAt(-6, success, i);
      IF (success) THEN BEGIN
        WriteLn('Position: -6 | Element: ', i);
      END ELSE BEGIN
        WriteLn('Position -6 in Vector not found.');
      END; (* IF *)

      WriteLn('GetSize: ', v^.GetSize);
      WriteLn('GetCapa: ', v^.GetCapacity);

      v^.Clear;
      v^.WriteVector;

      Dispose(v, Done);
  END; (* TestVector *)

  PROCEDURE TestNaturalVector;
    VAR v: NaturalVector;
        i: INTEGER;
    BEGIN (* TestNaturalVector *)
      New(v, Init);

      FOR i := 0 TO 9 DO BEGIN
        v^.Add(i - 5);
      END; (* FOR *)

      v^.WriteVector;

      WriteLn('IsFull? ', v^.IsFull);

      v^.InsertElementAt(5, 20);
      v^.InsertElementAt(8, -6);
      v^.WriteVector;

      Dispose(v, Done);
  END; (* TestNaturalVector *)

  PROCEDURE TestPrimeVector;
    VAR v: PrimeVector;
        i: INTEGER;
    BEGIN (* TestPrimeVector *)
      New(v, Init);

      FOR i := 1 TO 11 DO BEGIN
        v^.Add(i);
      END; (* FOR *)

      v^.WriteVector;

      WriteLn('IsFull? ', v^.IsFull);

      v^.InsertElementAt(9, 31171);
      v^.InsertElementAt(4, 31183);
      v^.WriteVector;

      Dispose(v, Done);
  END; (* TestPrimeVector *)

BEGIN (* Test *)
  TestVector;
  TestNaturalVector;
  TestPrimeVector;
END. (* Test *)