(* Multiset:                                                  MM, 2020-04-17 *)
(* ------                                                                    *)
(* Unit to create String Multisets as ADT                                    *)
(* ========================================================================= *)


UNIT Multiset;

INTERFACE
  TYPE
    StrMSet = POINTER;

  PROCEDURE NewStrMSet(VAR ms: StrMSet);
  PROCEDURE DisposeStrMSet(VAR ms: StrMSet);
  PROCEDURE Insert(VAR ms: StrMSet; element: STRING);
  PROCEDURE WriteTree(ms: StrMSet; space: INTEGER);
  PROCEDURE Remove(VAR ms: StrMSet; element: STRING);
  FUNCTION IsEmpty(ms: StrMSet): BOOLEAN;
  FUNCTION Contains(ms: StrMSet; element: STRING): BOOLEAN;
  FUNCTION Count(ms: StrMSet; element: STRING): INTEGER;
  FUNCTION Cardinality(ms: StrMSet): INTEGER;
  FUNCTION CountUnique(ms: StrMSet): INTEGER;
  PROCEDURE WriteTreeAsList(ms: StrMSet);
  PROCEDURE ToArray(ms: StrMSet; VAR a: ARRAY OF STRING; VAR count: INTEGER);

IMPLEMENTATION

  TYPE
    StrMSetPtr = ^StrMultSet;
    StrMultSet = RECORD
      element: STRING;
      count: INTEGER;
      left: StrMSetPtr;
      right: StrMSetPtr;
    END; (* StrMSet *)

  PROCEDURE ToArray(ms: StrMSet; VAR a: ARRAY OF STRING; VAR count: INTEGER);
    BEGIN (* ToArray *)
      IF (ms <> NIL) THEN BEGIN
        {$R-}
          a[count] := StrMSetPtr(ms)^.element;
        {$R+}

        Inc(count);
        ToArray(StrMSetPtr(ms)^.left, a, count);
        Inc(count);
        ToArray(StrMSetPtr(ms)^.right, a, count);
      END; (* IF *)
  END; (* ToArray *)

  FUNCTION NewNode(x: STRING): StrMSetPtr;
    VAR n: StrMSetPtr;
    BEGIN (* NewNode *)
      New(n);
      n^.element := x;
      n^.count := 1;
      n^.left := NIL;
      n^.right := NIL;
      NewNode := n;
  END; (* NewNode *)

  PROCEDURE NewStrMSet(VAR ms: StrMSet);
    BEGIN (* NewStrMSet *)
      GetMem(ms, SizeOf(STRING) + 2 * SizeOf(StrMSetPtr) + SizeOf(INTEGER));
      StrMSetPtr(ms)^.element := '';
      StrMSetPtr(ms)^.count := 0;
      StrMSetPtr(ms)^.left := NIL;
      StrMSetPtr(ms)^.right := NIL;
  END; (* NewStrMSet *)
  
  PROCEDURE DisposeStrMSet(VAR ms: StrMSet);
    BEGIN (* DisposeStrMSet *)
      IF (ms <> NIL) THEN BEGIN
        DisposeStrMSet(StrMSetPtr(ms)^.left);
        DisposeStrMSet(StrMSetPtr(ms)^.right);
        FreeMem(ms, SizeOf(STRING) + 2 * SizeOf(StrMSetPtr));
      END; (* IF *)
      
  END; (* DisposeStrMSet *)

  PROCEDURE Insert(VAR ms: StrMSet; element: STRING);
    BEGIN (* Insert *)
      IF ((ms <> NIL) AND (StrMSetPtr(ms)^.element <> '')) THEN BEGIN      
        IF (StrMSetPtr(ms)^.element = element) THEN BEGIN
          Inc(StrMSetPtr(ms)^.count);
        END ELSE IF (StrMSetPtr(ms)^.element < element) THEN BEGIN
          IF (StrMSetPtr(ms)^.right <> NIL) THEN BEGIN
            Insert(StrMSetPtr(ms)^.right, element);
          END ELSE BEGIN
            StrMSetPtr(ms)^.right := NewNode(element);    
          END; (* IF *)
        END ELSE IF (StrMSetPtr(ms)^.element > element) THEN BEGIN
          IF (StrMSetPtr(ms)^.left <> NIL) THEN BEGIN
            Insert(StrMSetPtr(ms)^.left, element);
          END ELSE BEGIN
            StrMSetPtr(ms)^.left := NewNode(element);
          END; (* IF *)
        END ELSE BEGIN
          WriteLn('ERROR: Could not insert element "', element, '" into data structure.');
          HALT;
        END; (* IF *)
      END ELSE BEGIN
        StrMSetPtr(ms)^.element := element;
        StrMSetPtr(ms)^.count := 1;
      END; (* IF *)
  END; (* Insert *)

  PROCEDURE WriteTree(ms: StrMSet; space: INTEGER);
    VAR i: INTEGER;
    BEGIN (* WriteTree *)
      IF (ms <> NIL) THEN BEGIN
        space := space + 10;

        WriteTree(StrMSetPtr(ms)^.right, space);

        WriteLn;
        FOR i := 10 TO space DO BEGIN
          Write(' ');
        END; (* FOR *)
        WriteLn(StrMSetPtr(ms)^.element, ': ', StrMSetPtr(ms)^.count);

        WriteTree(StrMSetPtr(ms)^.left, space);
      END; (* IF *)
  END; (* WriteTree *)

  PROCEDURE Remove(VAR ms: StrMSet; element: STRING);
    VAR cur, prev, child, next, nextPrev: StrMSetPtr;
    BEGIN (* Remove *)
      prev := NIL;
      cur := StrMSetPtr(ms);
      WHILE ((cur <> NIL) AND (cur^.element <> element)) DO BEGIN
        prev := cur;
        IF (element < cur^.element) THEN
          cur := cur^.left
        ELSE
          cur := cur^.right;
      END; (* WHILE *)

      IF (cur <> NIL) THEN BEGIN
        IF (cur^.right = NIL) THEN BEGIN
          child := cur^.left;
        END ELSE IF (cur^.right^.left = NIL) THEN BEGIN
          child := cur^.right;
          child^.left := cur^.left;
        END ELSE BEGIN
          nextPrev := NIL;
          next := cur^.right;
          WHILE (next^.left <> NIL) DO BEGIN
            nextPrev := next;
            next := next^.left;
          END; (* WHILE *)
          nextPrev^.left := next^.right;
          next^.left := cur^.left;
          child := next;
        END; (* IF *)

        IF (prev = NIL) THEN BEGIN
          StrMSetPtr(ms) := child;
        END ELSE IF (cur^.element < prev^.element) THEN BEGIN
          prev^.left := child;
        END ELSE BEGIN
          prev^.right := child
        END; (* IF *)
        
        cur^.left := NIL;
        cur^.right := NIL;

        Dispose(cur);
      END; (* IF *)
  END; (* Remove *)

  FUNCTION IsEmpty(ms: StrMSet): BOOLEAN;
    BEGIN (* IsEmpty *)
      IsEmpty := (ms = NIL) OR (StrMSetPtr(ms)^.element = '');
  END; (* IsEmpty *)

  FUNCTION Contains(ms: StrMSet; element: STRING): BOOLEAN;
    BEGIN (* Contains *)
      IF (ms = NIL) THEN BEGIN
        Contains := FALSE;
      END ELSE IF (StrMSetPtr(ms)^.element = element) THEN BEGIN
        Contains := TRUE;
      END ELSE IF (element < StrMSetPtr(ms)^.element) THEN BEGIN
        Contains := Contains(StrMSetPtr(ms)^.left, element);
      END ELSE BEGIN
        Contains := Contains(StrMSetPtr(ms)^.right, element);
      END; (* IF *)
  END; (* Contains *)

  FUNCTION Count(ms: StrMSet; element: STRING): INTEGER;
    BEGIN (* Count *)
      IF (ms = NIL) THEN BEGIN
        Count := 0;
      END ELSE IF (StrMSetPtr(ms)^.element = element) THEN BEGIN
        Count := StrMSetPtr(ms)^.count;
      END ELSE IF (element < StrMSetPtr(ms)^.element) THEN BEGIN
        Count := Count(StrMSetPtr(ms)^.left, element);
      END ELSE BEGIN
        Count := Count(StrMSetPtr(ms)^.right, element);
      END; (* IF *)
  END; (* Count *)

  FUNCTION Cardinality(ms: StrMSet): INTEGER;
    BEGIN (* Cardinality *)
      IF (ms <> NIL) THEN BEGIN
        Cardinality := StrMSetPtr(ms)^.count + Cardinality(StrMSetPtr(ms)^.left) + Cardinality(StrMSetPtr(ms)^.right);
      END ELSE BEGIN
        Cardinality := 0;
      END; (* IF *)
  END; (* Cardinality *)

  FUNCTION CountUnique(ms: StrMSet): INTEGER;
    BEGIN (* CountUnique *)
     IF (ms <> NIL) THEN BEGIN
        CountUnique := 1 + CountUnique(StrMSetPtr(ms)^.left) + CountUnique(StrMSetPtr(ms)^.right);
      END ELSE BEGIN
        CountUnique := 0;
      END; (* IF *)
  END; (* CountUnique *)

  PROCEDURE WriteTreeAsList(ms: StrMSet);
    BEGIN (* WriteTreeAsList *)
      IF (ms <> NIL) THEN BEGIN
        WriteLn(StrMSetPtr(ms)^.element, ': ', StrMSetPtr(ms)^.count);

        WriteTreeAsList(StrMSetPtr(ms)^.left);
        WriteTreeAsList(StrMSetPtr(ms)^.right);  
      END; (* IF *)
  END; (* WriteTreeAsList *)

BEGIN (* Multiset *)
  
END. (* Multiset *)