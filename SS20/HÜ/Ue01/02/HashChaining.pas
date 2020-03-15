(* HashChaining:                             SWa, modified by MM, 2020-03-11 *)
(* -------------                                                             *)
(* Fun with hashing and separate chaining.                                   *)
(* ========================================================================= *)
UNIT HashChaining;

INTERFACE
  CONST
    MAX = 211;
  TYPE
    NodePtr = ^Node;
    Node = RECORD
      val: STRING;
      count: INTEGER;
      next: NodePtr;
    END; (* Node *)
    ListPtr = NodePtr;
    HashTable = ARRAY [0 .. MAX - 1] OF ListPtr;

  PROCEDURE Insert(VAR table: HashTable; val: STRING; hfunc: INTEGER);
  PROCEDURE InitHashTable(VAR table: HashTable);
  FUNCTION Contains(table: HashTable; val: STRING; hfunc: INTEGER): NodePtr;
  FUNCTION GetHashCode1(val: STRING): INTEGER;
  FUNCTION GetHashCode2(val: STRING): INTEGER;
  FUNCTION GetHashCode3(val: STRING): INTEGER;

IMPLEMENTATION

  FUNCTION NewNode(val: STRING; next: NodePtr): NodePtr;
    VAR
      n: NodePtr;
    BEGIN (* NewNode *)
      New(n);
      n^.val := val;
      n^.count := 1;
      n^.next := next;
      NewNode := n;
  END; (* NewNode *)

  PROCEDURE InitHashTable(VAR table: HashTable);
    VAR
      i: INTEGER;
    BEGIN (* InitHashTable *)
      FOR i := Low(table) TO High(table) DO BEGIN
        table[i] := NIL;
      END; (* FOR *)
  END; (* InitHashTable *)

  FUNCTION GetHashCode1(val: STRING): INTEGER;
    var h: INTEGER;
    BEGIN (* GetHashCode *)
      IF (Length(val) = 0) THEN BEGIN
        h := 0;
      END ELSE IF (Length(val) = 1) THEN BEGIN
        h := (Ord(val[1]) * 7 + 1) * 17;
      END ELSE BEGIN
        h := (Ord(val[1]) * 7 + Ord(val[2]) + Length(val)) * 17;
      END; (* IF *)

      GetHashCode1 := h MOD MAX
  END; (* GetHashCode1 *)

  FUNCTION GetHashCode2(val: STRING): INTEGER;
    var i: INTEGER;
        h: INTEGER;
    BEGIN (* GetHashCode *)
      IF (Length(val) = 0) THEN BEGIN
        GetHashCode2 := 0;
      END ELSE IF (Length(val) = 1) THEN BEGIN
        GetHashCode2 := Ord(val[1]) MOD MAX;
      END ELSE BEGIN
        h := 0;
        FOR i := 1 TO Length(val) DO BEGIN
          h := (h * 256 + Ord(val[i])) MOD MAX;
        END; (* FOR *)
        GetHashCode2 := h;
      END; (* IF *)
  END; (* GetHashCode2 *)
  
  FUNCTION GetHashCode3(val: STRING): INTEGER;
    var i, h: INTEGER;
    BEGIN (* GetHashCode3 *)
      IF (Length(val) = 0) THEN BEGIN
        h := 0;
      END ELSE IF (Length(val) = 1) THEN BEGIN
        h := Ord(val[1]);
      END ELSE BEGIN
        h := 0;
        FOR i := 1 TO Length(val) DO BEGIN
          h := (h + Ord(val[i]));
        END; (* FOR *)
      END; (* IF *)
      GetHashCode3 := h MOD MAX;
  END; (* GetHashCode3 *)

  PROCEDURE Insert(VAR table: HashTable; val: STRING; hfunc: INTEGER);
    VAR
      hashcode: INTEGER;
      n: NodePtr;
    BEGIN (* Insert *)
      IF hfunc = 1 THEN BEGIN
        hashcode := GetHashCode1(val);
      END ELSE IF hfunc = 2 THEN BEGIN
        hashcode := GetHashCode2(val);
      END ELSE IF hfunc = 3 THEN BEGIN
        hashcode := GetHashCode3(val);
      END; (* IF *)
      // prepend new element at index hashcode if not already in list
      n := Contains(table, val, hfunc);
      if n <> NIL THEN
        Inc(n^.count)
      else
        table[hashcode] := NewNode(val, table[hashcode]);
  END; (* Insert *)

  FUNCTION Contains(table: HashTable; val: STRING; hfunc: INTEGER): NodePtr;
    VAR
      hashcode: INTEGER;
      n: NodePtr;
  BEGIN (* Contains *)
    IF hfunc = 1 THEN BEGIN
      hashcode := GetHashCode1(val);
    END ELSE IF hfunc = 2 THEN BEGIN
      hashcode := GetHashCode2(val);
    END ELSE IF hfunc = 3 THEN BEGIN
      hashcode := GetHashCode3(val);
    END; (* IF *)
    n := table[hashcode];
    WHILE ((n <> NIL) AND (n^.val <> val)) DO BEGIN
      n := n^.next;
    END; (* WHILE *)
    Contains := n;
  END; (* Contains *)

  FUNCTION GetHighestCount(table: HashTable): NodePtr;
    var n: NodePtr;
        highest: NodePtr;
        i: INTEGER;
  BEGIN (* GetHighestCount *)
    highest := table[0];
    FOR i := 0 TO (MAX - 1) DO BEGIN
      n := table[i];
      WHILE n <> NIL DO BEGIN
        IF highest = NIL THEN
          highest := n
        ELSE BEGIN
          IF n^.count > highest^.count THEN
            highest := n;
        END; (* IF *)
        n := n^.next;
      END; (* WHILE *)
    END; (* FOR *)

    GetHighestCount := highest;
  END; (* GetHighestCount *)

BEGIN (* HashChaining *)
END. (* HashChaining *)
