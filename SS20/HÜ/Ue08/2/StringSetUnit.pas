(* StringSet:                                                 MM, 2020-05-30 *)
(* ------                                                                    *)
(* A simple class for StringSet Operations                                   *)
(* ========================================================================= *)

UNIT StringSetUnit;

INTERFACE

  TYPE

    StringArray = ARRAY [0..0] OF STRING;

    StringSet = ^StringSetObj;
    StringSetObj = OBJECT
      PUBLIC
        CONSTRUCTOR Init(size: INTEGER);
        DESTRUCTOR Done; VIRTUAL;

        FUNCTION IsFull: BOOLEAN;
        FUNCTION Empty: BOOLEAN;
        FUNCTION Cardinality: INTEGER;
        FUNCTION Contains(x: STRING): BOOLEAN;
        PROCEDURE Add(x: STRING);
        PROCEDURE Remove(x: STRING);
        PROCEDURE Print;
        PROCEDURE Test;

        FUNCTION GetDataAt(x: INTEGER): STRING;

      PRIVATE
        elements: ^StringArray;
        size: INTEGER;
        n: INTEGER;
      END; (* StringSetObj *)

    PROCEDURE Union(s1, s2: StringSet; VAR target: StringSet);
    PROCEDURE Intersect(s1, s2: StringSet; VAR target: StringSet);
    PROCEDURE Difference(s1, s2: StringSet; VAR target: StringSet);

IMPLEMENTATION

  CONSTRUCTOR StringSetObj.Init(size: INTEGER);
    BEGIN
      SELF.n := 0;
      SELF.size := size;
      GetMem(SELF.elements, size * SizeOf(STRING));
  END; (* StringSetObj.Init *)

  DESTRUCTOR StringSetObj.Done;
    BEGIN
      FreeMem(SELF.elements, SELF.size * SizeOf(STRING));
  END; (* StringSetObj.Done *)

  FUNCTION StringSetObj.IsFull: BOOLEAN;
    BEGIN (* StringSetObj.IsFull *)
      IsFull := n > size;
  END; (* StringSetObj.IsFull *)

  FUNCTION StringSetObj.Empty: BOOLEAN;
    BEGIN (* StringSetObj.Empty *)
      Empty := n = 0;
  END; (* StringSetObj.Empty *)

  FUNCTION StringSetObj.Cardinality: INTEGER;
    BEGIN (* StringSetObj.Cardinality *)
      Cardinality := n;
  END; (* StringSetObj.Cardinality *)

  FUNCTION StringSetObj.Contains(x: STRING): BOOLEAN;
    VAR i: INTEGER;
    BEGIN (* StringSetObj.Contains *)
      i := 0;
      WHILE ((i < n) AND ({$R-}elements^[i]{$R+} <> x)) DO BEGIN
        Inc(i);
      END; (* WHILE *)

      Contains := i <> n;
  END; (* StringSetObj.Contains *)

  PROCEDURE StringSetObj.Add(x: STRING);
    BEGIN (* StringSetObj.Add *)
      IF (IsFull) THEN BEGIN
        WriteLn('Error: Set is full, program will be halted.');
        HALT;
      END ELSE BEGIN
        IF (NOT Contains(x)) THEN BEGIN
          {$R-}elements^[n]{$R+} := x;
          Inc(n);
        END; (* IF *)
      END; (* IF *)
  END; (* StringSetObj.Add *)

  PROCEDURE StringSetObj.Remove(x: STRING);
    VAR i: INTEGER;
        found: BOOLEAN;
    BEGIN (* StringSetObj.Remove *)
      IF (Empty) THEN BEGIN
        WriteLn('Set is already empty, programm will be halted.');
        HALT;
      END ELSE IF (NOT Contains(x)) THEN BEGIN
        WriteLn('Info: Cannot remove "', x, '", element not in Set.');
      END ELSE BEGIN
        found := FALSE;
        FOR i := 0 TO n DO BEGIN
          IF (found) THEN BEGIN
            {$R-}elements^[i] := elements^[i+1];{$R+}
          END ELSE BEGIN
            IF ({$R-}elements^[i] = x) THEN BEGIN
              found := TRUE;
              elements^[i] := elements^[i+1];
              Dec(n);
            END; (* IF *)
          END; (* IF *)
        END; (* FOR *)
      END; (* IF *)
  END; (* StringSetObj.Remove *)

  PROCEDURE StringSetObj.Test;
    BEGIN (* StringSetObj.Test *)
      WriteLn('n: ', n);
      WriteLn('Size: ', size);
      SELF.Print;
  END; (* StringSetObj.Test *)

  PROCEDURE StringSetObj.Print;
    VAR i: INTEGER;
    BEGIN (* StringSetObj.Print *)
      FOR i := 0 TO n - 1 DO BEGIN
        WriteLn({$R-}elements^[i]{$R+});
      END; (* FOR *)
  END; (* StringSetObj.Print *)

  FUNCTION StringSetObj.GetDataAt(x: INTEGER): STRING;
    BEGIN (* StringSetObj.GetData *)
      IF (x <= n) THEN
        GetDataAt := {$R-}elements^[x]{$R+}
      ELSE BEGIN
        WriteLn('Invalid position [', x, '] in Set (size: ',n,'), program will be halted.');
        HALT;
      END; (* IF *)
  END; (* StringSetObj.GetData *)

  PROCEDURE Union(s1, s2: StringSet; VAR target: StringSet);
    VAR data: STRING;
        i: INTEGER;
    BEGIN (* Union *)
      New(target, Init(s1^.Cardinality + s2^.Cardinality));

      FOR i := 0 TO s1^.Cardinality - 1 DO BEGIN
        data := s1^.GetDataAt(i);
        target^.Add(data);
      END; (* FOR *)

      FOR i := 0 TO s2^.Cardinality - 1 DO BEGIN
        data := s2^.GetDataAt(i);
        target^.Add(data);
      END; (* FOR *)
  END; (* Union *)

  PROCEDURE Intersect(s1, s2: StringSet; VAR target: StringSet);
    VAR data: STRING;
        i: INTEGER;
    BEGIN (* Intersect *)
      New(target, Init(s1^.Cardinality));

      FOR i := 0 TO s1^.Cardinality - 1 DO BEGIN
        data := s1^.GetDataAt(i);
        target^.Add(data);
      END; (* FOR *)

      FOR i := target^.Cardinality - 1 DOWNTO 0 DO BEGIN
        data := target^.GetDataAt(i);
        IF (NOT s2^.Contains(data)) THEN
          target^.Remove(data);
      END; (* FOR *)
  END; (* Intersect *)

  PROCEDURE Difference(s1, s2: StringSet; VAR target: StringSet);
    VAR temp: StringSet;
        data: STRING;
        i: INTEGER;
    BEGIN (* Difference *)
      Union(s1, s2, target);
      Intersect(s1, s2, temp);

      FOR i := target^.Cardinality - 1 DOWNTO 0 DO BEGIN
          data := target^.GetDataAt(i);
          IF (temp^.Contains(data)) THEN
            target^.Remove(data);
        END; (* FOR *)
      
      Dispose(temp, Done);
  END; (* Difference *)
  
END. (* StringSetUnit *)