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

  PROCEDURE Insert(VAR table: HashTable; val: STRING);
  PROCEDURE InitHashTable(VAR table: HashTable);
  FUNCTION Contains(table: HashTable; val: STRING): NodePtr;
  FUNCTION GetHighestCount(table: HashTable): NodePtr;

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

  FUNCTION GetHashCode(val: STRING): INTEGER;
  BEGIN (* GetHashCode *)
    IF (Length(val) = 0) THEN BEGIN
      GetHashCode := 0;
    END ELSE IF (Length(val) = 1) THEN BEGIN
      GetHashCode := (Ord(val[1]) * 7 + 1) * 17;
    END ELSE BEGIN
      GetHashCode := (Ord(val[1]) * 7 + Ord(val[2]) + Length(val)) * 17;
    END; (* IF *)
  END; (* GetHashCode *)

  PROCEDURE Insert(VAR table: HashTable; val: STRING);
    VAR
      hashcode: INTEGER;
      n: NodePtr;
  BEGIN (* Insert *)
    hashcode := GetHashCode(val);
    hashcode := hashcode MOD MAX;

    // prepend new element at index hashcode if not already in list
    n := Contains(table, val);
    if n <> NIL THEN
      Inc(n^.count)
    else
      table[hashcode] := NewNode(val, table[hashcode]);
  END; (* Insert *)

  FUNCTION Contains(table: HashTable; val: STRING): NodePtr;
    VAR
      hashcode: INTEGER;
      n: NodePtr;
  BEGIN (* Contains *)
    hashcode := GetHashCode(val);
    hashcode := hashcode MOD MAX;

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
