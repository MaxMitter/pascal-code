(* NaturalVectorClass:                                        MM, 2020-06-05 *)
(* ------                                                                    *)
(* Simple Class to store Natural Vectors in an IntArray                      *)
(* ========================================================================= *)

UNIT NaturalVectorClass;

INTERFACE

  USES VectorClass;

  TYPE
    NaturalVector = ^NaturalVectorObj;
    NaturalVectorObj = OBJECT(VectorObj)
      PUBLIC
        CONSTRUCTOR Init;
        DESTRUCTOR Done; VIRTUAL;

        PROCEDURE Add(value: INTEGER); VIRTUAL;
        PROCEDURE InsertElementAt(pos, value: INTEGER); VIRTUAL;
    END; (* NaturalVectorObj *)

IMPLEMENTATION

  CONSTRUCTOR NaturalVectorObj.Init;
    BEGIN (* NaturalVectorObj.Init *)
      INHERITED Init;
  END; (* NaturalVectorObj.Init *)

  DESTRUCTOR NaturalVectorObj.Done;
    BEGIN (* NaturalVectorObj.Done *)
      INHERITED Done;
  END; (* NaturalVectorObj.Done *)

  PROCEDURE NaturalVectorObj.Add(value: INTEGER);
    BEGIN (* NaturalVectorObj.Add *)
      IF (value >= 0) THEN
        INHERITED Add(value)
      ELSE
        WriteLn('"', value, '" is not a Natural Number, cannot be added.');
  END; (* NaturalVectorObj.Add *)

  PROCEDURE NaturalVectorObj.InsertElementAt(pos, value: INTEGER);
    BEGIN (* NaturalVectorObj.InsertElementAt *)
      IF (value >= 0) THEN
        INHERITED InsertElementAt(pos, value)
      ELSE
        WriteLn('"', value, '" is not a Natural Number, cannot be added.');
  END; (* NaturalVectorObj.InsertElementAt *)

END. (* NaturalVectorClass *)