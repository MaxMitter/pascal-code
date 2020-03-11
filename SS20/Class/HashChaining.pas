Program HashChaining;
  CONST
    MAX = 100;

  TYPE
    NodePtr = ^Node;
    Node = record
      val: string;
      next: NodePtr;
    end;
    ListPtr = NodePtr;
    HashTable = array [0..MAX - 1] OF ListPtr;

  FUNCTION NewNode(val: string; next: NodePtr): NodePtr;
    var n: NodePtr;
  BEGIN
    New(n);
    n^.val := val;
    n^.next := next;
    NewNode := n;
  END;

  PROCEDURE InitHashTable(var table: HashTable);
    var i: integer;
  BEGIN
    for i := Low(table) to High(table) do begin      
      table[i] := NIL;
    end;
  END;

  FUNCTION GetHashCode(val: string): integer;
  BEGIN
    If (Length(val) = 0) then begin
      GetHashCode := 0;
    end else if Length(val) = 0 then begin
      GetHashCode := (Ord(val[1]) * 7 + 1) * 17;
    end else begin
      GetHashCode := (Ord(val[1]) * 7 + Ord(val[2]) + Length(val)) * 17;
    end;
  END;

  PROCEDURE Insert(var table: HashTable; val: string);
    var hashcode: integer;
  BEGIN
    hashcode := GetHashCode(val);
    hashcode := hashcode MOD MAX;

    table[hashcode] := NewNode(val, table[hashcode]);
  END;

  FUNCTION Contains(table: HashTable; val: string): boolean;
    var hashcode: integer;
        n: NodePtr;
  BEGIN
    hashcode := GetHashCode(val);
    hashcode := hashcode MOD MAX;

    n := table[hashcode];
    while (n <> NIL) AND (n^.val <> val) do begin
      n := n^.next;
    end;

    Contains := (n <> NIL);
  END;

  PROCEDURE WriteHashTable(table: HashTable);
    var i: integer;
        n: NodePtr;
  BEGIN
    for i := 0 to MAX - 1 do begin
      if(table[i] <> NIL) then begin
        Write(i, ': ');
        n := table[i];

        while n <> NIL do begin
          Write(n^.val, ' -> ');
          n := n^.next;
        end;
        WriteLn('|');
      end;
    end;
  END;

  var table: HashTable;
      s: string;

BEGIN
  InitHashTable(table);
  Insert(table, 'Stefan');
  Insert(table, 'Sabine');
  Insert(table, 'Albert');
  Insert(table, 'Alina');
  Insert(table, 'Gisella');
  Insert(table, 'Gisbert');

  WriteLn('Contains(Sabine)? = ', Contains(table, 'Sabine'));
  WriteLn('Contains(Alina)? = ', Contains(table, 'Alina'));
  WriteLn('Contains(Fridolin)? = ', Contains(table, 'Fridolin'));
  WriteLn('Contains(Sebastian)? = ', Contains(table, 'Sebastian'));

  WriteHashTable(table);
END.