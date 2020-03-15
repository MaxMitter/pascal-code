(* HashProbing:                               SWa, modified by MM 2020-03-11 *)
(* ------------                                                              *)
(* Fun with hashing and linear probing.                                      *)
(* ========================================================================= *)
UNIT HashProbing;

INTERFACE
  CONST
    MAX = 5001;
  
  TYPE
    NodePtr = ^Node;
    Node = RECORD
      val: STRING;
      count: INTEGER;
      del: BOOLEAN;
    END; (* Node *)
    HashTable = ARRAY [0 .. MAX - 1] OF NodePtr;

  PROCEDURE InitHashTable(VAR table: HashTable);
  PROCEDURE Insert(VAR table: HashTable; val: STRING);
  FUNCTION GetHighestCount(table: HashTable): NodePtr;
  FUNCTION Lookup(table: HashTable; val: STRING): INTEGER;

IMPLEMENTATION

  FUNCTION NewNode(val: STRING): NodePtr;
    VAR
      n: NodePtr;
    BEGIN (* NewNode *)
      New(n);
      n^.val := val;
      n^.count := 1;
      n^.del := FALSE;
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

  FUNCTION GetHashCode(val: STRING): INTEGER;
    var i: INTEGER;
        h: INTEGER;
    BEGIN (* GetHashCode *)
      IF (Length(val) = 0) THEN BEGIN
        GetHashCode := 0;
      END ELSE IF (Length(val) = 1) THEN BEGIN
        GetHashCode := Ord(val[1]) MOD MAX;
      END ELSE BEGIN
        h := 0;
        FOR i := 1 TO Length(val) DO BEGIN
          h := (h * 256 + Ord(val[i])) MOD MAX;
        END; (* FOR *)
        GetHashCode := h;
      END; (* IF *)
  END; (* GetHashCode *)

  PROCEDURE Insert(VAR table: HashTable; val: STRING);
    VAR
      hashcode: INTEGER;
    BEGIN (* Insert *)
      hashcode := Lookup(table, val);
      IF hashcode <> -1 THEN BEGIN
        IF NOT (table[hashcode]^.del) THEN
          Inc(table[hashcode]^.count);
      END ELSE BEGIN
        hashcode := GetHashCode(val);
        table[hashcode] := NewNode(val);
      END; (* IF *)
  END; (* Insert *)

  FUNCTION Lookup(table: HashTable; val: STRING): INTEGER;
    VAR
      hashcode: LONGINT;
    BEGIN (* Lookup *)
      hashcode := GetHashCode(val);
      WHILE ((table[hashcode] <> NIL) AND ((table[hashcode]^.val <> val)
            OR (table[hashcode]^.del))) DO BEGIN

        hashcode := (hashcode + 1) MOD MAX;
        IF (hashcode = GetHashCode(val)) THEN BEGIN
          WriteLn('ERROR: Hashtable is full');
          HALT;
        END; (* IF *)

      END; (* WHILE *)

      IF (table[hashcode] <> NIL) THEN BEGIN
        Lookup := hashcode;
      END ELSE BEGIN
        Lookup := -1;
      END; (* IF *)
  END; (* Lookup *)

  FUNCTION Contains(table: HashTable; val: STRING): BOOLEAN;
    BEGIN (* Contains *)
      Contains := Lookup(table, val) <> -1;
  END; (* Contains *)

  PROCEDURE Remove(VAR table: HashTable; val: STRING);
    VAR
      i: INTEGER;
    BEGIN (* Remove *)
      i := Lookup(table, val);
      IF (i <> -1) THEN BEGIN
        table[i]^.del := TRUE;
      END; (* IF *)
  END; (* Remove *)

  FUNCTION GetHighestCount(table: HashTable): NodePtr;
    var highest: NodePtr;
        i: INTEGER;
    BEGIN (* GetHighestCount *)
      highest := table[0];
      FOR i := 1 TO (MAX - 1) DO BEGIN
        IF highest = NIL THEN
          highest := table[i]
        ELSE IF table[i] <> NIL THEN BEGIN
          IF table[i]^.count > highest^.count THEN
            highest := table[i];
        END; (* IF *)
      END; (* FOR *)

    GetHighestCount := highest;
  END; (* GetHighestCount *)

BEGIN (* HashChaining *)
END. (* HashChaining *)







