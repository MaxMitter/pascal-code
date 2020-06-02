(* CIStringSetUnit:                                           MM, 2020-05-30 *)
(* ------                                                                    *)
(* A simple class for CaseInsensitiveStringSet Operations                    *)
(* ========================================================================= *)
UNIT CIStringSetUnit;

INTERFACE

  USES StringSetUnit;

  TYPE

    CIStringSet = ^CIStringSetObj;
    CIStringSetObj = OBJECT(StringSetObj)
      PUBLIC
        CONSTRUCTOR Init(size: INTEGER);
        DESTRUCTOR Done; VIRTUAL;

        FUNCTION Contains(x: STRING): BOOLEAN;
        PROCEDURE Add(x: STRING);
        PROCEDURE Remove(x: STRING);
      END; (* StringSetObj *)

IMPLEMENTATION

  CONSTRUCTOR CIStringSetObj.Init(size: INTEGER);
    BEGIN
      INHERITED Init(size);
  END; (* CIStringSetObj.Init *)

  DESTRUCTOR CIStringSetObj.Done;
    BEGIN
      INHERITED Done;
  END; (* CIStringSetObj.Done *)

  FUNCTION CIStringSetObj.Contains(x: STRING): BOOLEAN;
    BEGIN (* CIStringSetObj.Contains *)
      INHERITED Contains(UpCase(x));
  END; (* CIStringSetObj.Contains *)

  PROCEDURE CIStringSetObj.Add(x: STRING);
    BEGIN (* StringSetObj.Add *)
      INHERITED Add(UpCase(x));
  END; (* StringSetObj.Add *)

  PROCEDURE CIStringSetObj.Remove(x: STRING);
    BEGIN (* StringSetObj.Remove *)
      INHERITED Remove(UpCase(x));
  END; (* StringSetObj.Remove *)

END. (* CIStringSetUnit *)