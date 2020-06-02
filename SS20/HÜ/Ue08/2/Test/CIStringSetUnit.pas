(* CIStringSetUnit:                                           MM, 2020-05-30 *)
(* ------                                                                    *)
(* A simple class for CaseInsensitiveStringSet Operations using              *)
(* a single linked list                                                      *)
(* ========================================================================= *)
UNIT CIStringSetUnit;

INTERFACE

  USES StringSetListUnit;

  TYPE

    CIStringSet = ^CIStringSetObj;
    CIStringSetObj = OBJECT(StringSetObj)
      PUBLIC
        CONSTRUCTOR Init;
        DESTRUCTOR Done; VIRTUAL;

        FUNCTION Contains(x: STRING): BOOLEAN;
        PROCEDURE Add(x: STRING);
      END; (* StringSetObj *)

IMPLEMENTATION

  CONSTRUCTOR CIStringSetObj.Init;
    BEGIN
      INHERITED Init;
  END; (* CIStringSetObj.Init *)

  DESTRUCTOR CIStringSetObj.Done;
    BEGIN
      INHERITED Done;
  END; (* CIStringSetObj.Done *)

  FUNCTION CIStringSetObj.Contains(x: STRING): BOOLEAN;
    VAR curr: Node;
    BEGIN (* CIStringSetObj.Contains *)
      curr := elements;
      IF(curr <> NIL) THEN BEGIN
        WHILE (curr^.next <> NIL) AND (UpCase(curr^.value) <> UpCase(x)) DO BEGIN
          curr := curr^.next;
        END; (* WHILE *)
        Contains := UpCase(curr^.value) = UpCase(x);
      END ELSE BEGIN
        Contains := FALSE;
      END; (* IF *)
  END; (* CIStringSetObj.Contains *)

  PROCEDURE CIStringSetObj.Add(x: STRING);
    BEGIN (* StringSetObj.Add *)
      IF (NOT Contains(x)) THEN BEGIN
        INHERITED AddFromSubClass(x);
      END; (* IF *)
  END; (* StringSetObj.Add *)

END. (* CIStringSetUnit *)