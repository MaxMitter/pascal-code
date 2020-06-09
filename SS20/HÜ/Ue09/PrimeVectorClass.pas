(* PrimeVectorClass:                                          MM, 2020-06-05 *)
(* ------                                                                    *)
(* Simple Class to store Prime Vectors in an IntArray                        *)
(* ========================================================================= *)

UNIT PrimeVectorClass;

INTERFACE

  USES VectorClass;

  TYPE
    PrimeVector = ^PrimeVectorObj;
    PrimeVectorObj = OBJECT(VectorObj)
      PUBLIC
        CONSTRUCTOR Init;
        DESTRUCTOR Done; VIRTUAL;

        PROCEDURE Add(value: INTEGER); VIRTUAL;
        PROCEDURE InsertElementAt(pos, value: INTEGER); VIRTUAL;
    END; (* PrimeVectorObj *)

IMPLEMENTATION

  FUNCTION IsPrime(value: INTEGER): BOOLEAN;
    VAR i, count, check: INTEGER;
    BEGIN (* IsPrime *)
      count := 0;
      FOR i := 2 TO value - 1 DO BEGIN
        IF (value MOD i = 0) THEN 
          Inc(count);
      END; (* FOR *)

      IsPrime := count = 0;
  END; (* IsPrime *)

  CONSTRUCTOR PrimeVectorObj.Init;
    BEGIN (* PrimeVectorObj.Init *)
      INHERITED Init;
  END; (* PrimeVectorObj.Init *)

  DESTRUCTOR PrimeVectorObj.Done;
    BEGIN (* PrimeVectorObj.Done *)
      INHERITED Done;
  END; (* PrimeVectorObj.Done *)

  PROCEDURE PrimeVectorObj.Add(value: INTEGER);
    BEGIN (* PrimeVectorObj.Add *)
      IF (IsPrime(value)) THEN
        INHERITED Add(value)
      ELSE
        WriteLn('"', value, '" is not a Prime Number, cannot be added.');
  END; (* PrimeVectorObj.Add *)

  PROCEDURE PrimeVectorObj.InsertElementAt(pos, value: INTEGER);
    BEGIN (* PrimeVectorObj.InsertElementAt *)
      IF (IsPrime(value)) THEN
        INHERITED InsertElementAt(pos, value)
      ELSE
        WriteLn('"', value, '" is not a Prime Number, cannot be added.');
  END; (* PrimeVectorObj.InsertElementAt *)

END. (* PrimeVectorObj *)