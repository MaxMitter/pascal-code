Program HashChaining;
  CONST
    MAX = 100;

  TYPE
    NodePtr = ^Node;
    Node = record
      val: string;
      del: boolean;
    end;
    HashTable = array [0..MAX - 1] OF NodePtr;

  FUNCTION NewNode(val: string): NodePtr;
    var n: NodePtr;
    BEGIN
      New(n);
      n^.val := val;
      n^.del := false;
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

      while (table[hashcode] <> NIL) AND (NOT table[hashcode]^.del) do begin
        hashcode := (hashcode + 1) MOD MAX;
        if (hashcode = GetHashCode(val)) then begin
          WriteLn('ERROR: Hashtable is full');
          HALT;
        end;
      end;
        if(table[hashcode] <> NIL) then
          Dispose(table[hashcode]);

        table[hashcode] := NewNode(val);
  END;

  FUNCTION Lookup(table: HashTable; val: string): integer;
      var hashcode: integer;
    BEGIN
      hashcode := GetHashCode(val);
      hashcode := hashcode MOD MAX;

      while ((table[hashcode] <> NIL) AND
            ((table[hashcode]^.val <> val) OR (table[hashcode]^.del))) do begin
        hashcode := (hashcode + 1) MOD MAX;

        if (hashcode = GetHashCode(val)) then begin
          //
        end;
    end;
    if table[hashcode] <> NIL then begin
      Lookup := hashcode;
    end else begin
      Lookup := -1;
    end;
  END;

  FUNCTION Contains(table: HashTable; val: string): boolean;
    BEGIN
      Contains := Lookup(table, val) <> -1;
  END;

  PROCEDURE Remove(var table: HashTable; val: string);
      var i: integer;
    BEGIN
      i := Lookup(table, val);
      if (i <> -1) then begin
        table[i]^.del := true;
      end;
  END;

  PROCEDURE WriteHashTable(table: HashTable);
    var i: integer;
        n: NodePtr;
  BEGIN
    for i := 0 to MAX - 1 do begin
      if(table[i] <> NIL) then begin
        Write(i, ': ', table[i]^.val);
        if(table[i]^.del) then
          Write(' (DEL)');
        WriteLn;
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
  WriteLn;

  Remove(table, 'Gisbert');
  WriteHashTable(table);
  WriteLn(Contains(table, 'Gisbert'));
END.