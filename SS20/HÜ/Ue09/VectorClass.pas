(* VectorClass:                                               MM, 2020-06-05 *)
(* ------                                                                    *)
(* Simple Class to store Vectors in an IntArray                              *)
(* ========================================================================= *)

UNIT VectorClass;

INTERFACE

  TYPE
    IntArray = ARRAY [0..0] OF INTEGER;

    Vector = ^VectorObj;
    VectorObj = OBJECT
      PUBLIC
        CONSTRUCTOR Init;
        DESTRUCTOR Done; VIRTUAL;

        FUNCTION IsFull: BOOLEAN;
        PROCEDURE Add(value: INTEGER); VIRTUAL;
        PROCEDURE InsertElementAt(pos, value: INTEGER); VIRTUAL;
        PROCEDURE WriteVector;
        PROCEDURE GetElementAt(pos: INTEGER; VAR ok: BOOLEAN; VAR value: INTEGER);
        FUNCTION GetSize: INTEGER;
        FUNCTION GetCapacity: INTEGER;
        PROCEDURE Clear;
      PROTECTED
        data: ^IntArray;
        capacity: INTEGER;
        size: INTEGER;
        PROCEDURE DoubleSize;
    END; (* VectorObj *)

IMPLEMENTATION

  CONSTRUCTOR VectorObj.Init;
    BEGIN (* VectorObj.Init *)
      capacity := 10;
      size := 0;
      GetMem(data, capacity * SizeOf(INTEGER));
  END; (* VectorObj.Init *)

  DESTRUCTOR VectorObj.Done;
    BEGIN (* VectorObj.Done *)
      FreeMem(data, capacity * SizeOf(INTEGER));
  END; (* VectorObj.Done *)
  
  FUNCTION VectorObj.IsFull: BOOLEAN;
    BEGIN (* VectorObj.IsFull *)
      IsFull := size >= capacity;
  END; (* VectorObj.IsFull *)

  PROCEDURE VectorObj.DoubleSize;
    VAR newdata: ^IntArray;
        i: INTEGER;
    BEGIN (* VectorObj.DoubleSize *)
      GetMem(newdata, capacity * 2 * SizeOf(INTEGER));
      FOR i := 0 TO capacity - 1 DO BEGIN
        {$R-}newdata^[i] := data^[i];{$R+}
      END; (* FOR *)
      FreeMem(data, capacity * SizeOf(INTEGER));
      data := newdata;
      capacity := capacity * 2;
  END; (* VectorObj.DoubleSize *)

  PROCEDURE VectorObj.Add(value: INTEGER);
    BEGIN (* VectorObj.Add *)
      IF (IsFull) THEN BEGIN  
        DoubleSize;
      END; (* IF *)

      {$R-}data^[size] := value; {$R+}
      Inc(size);
  END; (* VectorObj.Add *)

  PROCEDURE VectorObj.InsertElementAt(pos, value: INTEGER);
    VAR i: INTEGER;
    BEGIN (* VectorObj.InsertElementAt *)
      IF (IsFull) THEN
        DoubleSize;

      IF (pos <= 0) THEN
        pos := 0;
        
      IF (pos > size) THEN BEGIN
        Add(value);
      END ELSE BEGIN
        FOR i := size DOWNTO pos DO BEGIN
          {$R-}data^[i] := data^[i-1];{$R+}
        END; (* FOR *)
        {$R-}data^[pos] := value;{$R+}
        Inc(size);
      END; (* IF *)
  END; (* VectorObj.InsertElementAt *)

  PROCEDURE VectorObj.WriteVector;
    VAR i: INTEGER;
    BEGIN (* VectorObj.WriteVector *)
      WriteLn('Vector ------------------------------');
      WriteLn('capacity: ', capacity);
      WriteLn('size:     ', size);
      FOR i := 0 TO size - 1 DO BEGIN
        {$R-}WriteLn('data[', i, '] = ', data^[i]);{$R+}
      END; (* FOR *)
      WriteLn('--------------------------------------');
  END; (* VectorObj.WriteVector *)

  PROCEDURE VectorObj.GetElementAt(pos: INTEGER; VAR ok: BOOLEAN; VAR value: INTEGER);
    BEGIN (* VectorObj.GetElementAt *)
      ok := (0 <= pos) AND (pos < size);

      IF (ok) THEN
        {$R-}value := data^[pos];{$R+}
  END; (* VectorObj.GetElementAt *)

  FUNCTION VectorObj.GetSize: INTEGER;
    BEGIN (* VectorObj.GetSize *)
      GetSize := SELF.size;
  END; (* VectorObj.GetSize *)

  FUNCTION VectorObj.GetCapacity: INTEGER;
    BEGIN (* VectorObj.GetCapacity *)
      GetCapacity := SELF.capacity;
  END; (* VectorObj.GetCapacity *)

  PROCEDURE VectorObj.Clear;
    VAR i: INTEGER;
    BEGIN (* VectorObj.Clear *)
      FOR i := 0 TO size - 1 DO BEGIN
        {$R-}data^[i] := 0;{$R+}
      END; (* FOR *)

      size := 0;
  END; (* VectorObj.Clear *)

END. (* Vector *)