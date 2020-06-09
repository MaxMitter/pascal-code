(* MapClass:                                                  MM, 2020-06-05 *)
(* ------                                                                    *)
(* A Unit for Mapping Operations using Hash Chaining                         *)
(* ========================================================================= *)

UNIT MapClass;

INTERFACE

  CONST MAX = 100;

  TYPE
    NodePtr = ^Node;
    Node = RECORD
      key, value: STRING;
      next: NodePtr;
    END; (* Node *)
    HashTable = ARRAY [0..MAX-1] OF NodePtr;

    Map = ^MapObj;
    MapObj = OBJECT
      PUBLIC
        CONSTRUCTOR Init;
        DESTRUCTOR Done; VIRTUAL;
        PROCEDURE Put(key, value: STRING);
        PROCEDURE WriteMap;
        PROCEDURE GetValue(key: STRING; VAR value: STRING);
        PROCEDURE Remove(key: STRING);
        FUNCTION GetSize: INTEGER;
      PRIVATE
        table: HashTable;
        size: INTEGER;
    END; (* MapObj *)

IMPLEMENTATION

  FUNCTION NewNode(key, value: STRING; next: NodePtr): NodePtr;
    VAR n: NodePtr;
    BEGIN (* NewNode *)
      New(n);
      n^.key := key;
      n^.value := value;
      n^.next := next;
      NewNode := n;
  END; (* NewNode *)

  PROCEDURE DisposeList(VAR l: NodePtr);
    BEGIN (* DisposeList *)
      IF (l <> NIL) THEN BEGIN
        DisposeList(l^.next);
        Dispose(l);
      END; (* IF *)
  END; (* DisposeList *)

  FUNCTION GetHashCode(key: STRING): INTEGER;
    BEGIN (* GetHashCode *)
      IF (Length(key) = 0) THEN BEGIN
        GetHashCode := 0;
      END ELSE IF (Length(key) = 1) THEN BEGIN
        GetHashCode := ((Ord(key[1]) * 7 + 1) * 17) MOD MAX;
      END ELSE BEGIN
        GetHashCode := ((Ord(key[1]) * 7 + Ord(key[2]) + Length(key)) * 17) MOD MAX;
      END (* IF *)
  END; (* GetHashCode *)

  CONSTRUCTOR MapObj.Init;
    VAR i: INTEGER;
    BEGIN
      FOR i := Low(table) TO High(table) DO BEGIN
        table[i] := NIL;
      END; (* FOR *)
      size := 0;
  END; (* MapObj.Init *)

  DESTRUCTOR MapObj.Done;
    VAR i: INTEGER;
    BEGIN
      FOR i := Low(table) TO High(table) DO BEGIN
        DisposeList(table[i]);
      END; (* FOR *)
  END; (* MapObj.Done *)

  FUNCTION Contains(table: HashTable; key: STRING): BOOLEAN;
    VAR hashcode: INTEGER;
        n: NodePtr;
    BEGIN (* Contains *)
      hashcode := GetHashCode(key);

      n := table[hashcode];
      WHILE ((n <> NIL) AND (n^.key <> key)) DO BEGIN
        n := n^.next;
      END; (* WHILE *)

      Contains := n <> NIL;
  END; (* Contains *)

  PROCEDURE MapObj.Put(key, value: STRING);
    VAR hashcode: INTEGER;
    BEGIN (* MapObj.Put *)
      hashcode := GetHashCode(key);

      IF (Contains(table, key)) THEN
        WriteLn('ERROR: Key "', key, '" is already mapped, you have to remove it first.')
      ELSE BEGIN
        table[hashcode] := NewNode(key, value, table[hashcode]);
        Inc(size);
      END; (* ELSE *)
  END; (* MapObj.Put *)

  PROCEDURE MapObj.WriteMap;
    VAR i: INTEGER;
        n: NodePtr;
    BEGIN (* MapObj.Write *)
      WriteLn('Map contains: --------------------------');
      FOR i := 0 TO High(table) DO BEGIN
        n := table[i];
        IF (n <> NIL) THEN BEGIN
          Write('Index ', i, ': ');
          WHILE (n <> NIL) DO BEGIN
            Write(n^.key, ' - ', n^.value, ' --> ');
            n := n^.next;
          END; (* WHILE *)
          WriteLn;
        END; (* IF *)
      END; (* FOR *)
      WriteLn('----------------------------------------');
  END; (* MapObj.Write *)

  PROCEDURE MapObj.GetValue(key: STRING; VAR value: STRING);
    VAR hashcode: INTEGER;
        n: NodePtr;
    BEGIN (* MapObj.GetValue *)
      hashcode := GetHashCode(key);

      n := table[hashcode];

      WHILE ((n <> NIL) AND (n^.key <> key)) DO BEGIN
        n := n^.next;
      END; (* WHILE *)

      IF (n <> NIL) THEN
        value := n^.value
      ELSE
        value := 'WARNING: Key not found!';
  END; (* MapObj.GetValue *)

  PROCEDURE MapObj.Remove(key: STRING);
    VAR hashcode: INTEGER;
        n, prev: NodePtr;
    BEGIN (* MapObj.Remove *)
      IF (NOT Contains(table, key)) THEN
        WriteLn('ERROR: Key "', key, '" could not be found, remove unsuccessfull')
      ELSE BEGIN
        hashcode := GetHashCode(key);

        n := table[hashcode];
        prev := NIL;
        WHILE ((n <> NIL) AND (n^.key <> key)) DO BEGIN
          prev := n;
          n := n^.next;
        END; (* WHILE *)

        IF (prev = NIL) THEN
          table[hashcode] := n^.next
        ELSE
          prev^.next := n^.next;

        Dispose(n);
        Dec(size);
      END; (* ELSE *)
  END; (* MapObj.Remove *)

  FUNCTION MapObj.GetSize: INTEGER;
    BEGIN (* MapObj.Size *)
      GetSize := SELF.size;
  END; (* MapObj.Size *)

END. (* MapClass *)