(* StringListSet:                                             MM, 2020-05-30 *)
(* ------                                                                    *)
(* A simple class for StringSet Operations using a single linked list        *)
(* ========================================================================= *)

UNIT StringSetListUnit;

INTERFACE

  TYPE

    List = ^NodeElement;
    Node = ^NodeElement;
    NodeElement = RECORD
      value: STRING;
      next: Node;
    END; (* NodeElement *)

    StringSet = ^StringSetObj;
    StringSetObj = OBJECT
      PUBLIC
        CONSTRUCTOR Init;
        DESTRUCTOR Done; VIRTUAL;

        FUNCTION Empty: BOOLEAN;
        FUNCTION Cardinality: INTEGER;
        FUNCTION Contains(x: STRING): BOOLEAN; VIRTUAL;
        PROCEDURE Add(x: STRING); VIRTUAL;
        PROCEDURE Remove(x: STRING); VIRTUAL;
        PROCEDURE Print; VIRTUAL;
        PROCEDURE Test; VIRTUAL;

        FUNCTION GetData: Node;

      PROTECTED
        elements: List;
        n: INTEGER;
      END; (* StringSetObj *)

    PROCEDURE Union(s1, s2: StringSet; VAR t: StringSet);
    PROCEDURE Intersect(s1, s2: StringSet; VAR t: StringSet);
    PROCEDURE Difference(s1, s2: StringSet; VAR target: StringSet);

IMPLEMENTATION

  FUNCTION NewNode(value: STRING): Node;
    VAR n: Node;
    BEGIN (* NewNode *)
      New(n);
      n^.next := NIL;
      n^.value := value;
      NewNode := n;
  END; (* NewNode *)

  CONSTRUCTOR StringSetObj.Init;
    BEGIN
      SELF.n := 0;
      SELF.elements := NIL;
  END; (* StringSetObj.Init *)

  DESTRUCTOR StringSetObj.Done;
    VAR x: Node;
    BEGIN
      WHILE (elements <> NIL) DO BEGIN
        x := elements;
        elements := elements^.next;
        Dispose(x);
      END; (* WHILE *)
  END; (* StringSetObj.Done *)

  FUNCTION StringSetObj.Empty: BOOLEAN;
    BEGIN (* StringSetObj.Empty *)
      Empty := n = 0;
  END; (* StringSetObj.Empty *)

  FUNCTION StringSetObj.Cardinality: INTEGER;
    BEGIN (* StringSetObj.Cardinality *)
      Cardinality := n;
  END; (* StringSetObj.Cardinality *)

  FUNCTION StringSetObj.Contains(x: STRING): BOOLEAN;
    VAR curr: Node;
    BEGIN (* StringSetObj.Contains *)
      curr := elements;
      IF(curr <> NIL) THEN BEGIN
        WHILE (curr^.next <> NIL) AND (curr^.value <> x) DO BEGIN
          curr := curr^.next;
        END; (* WHILE *)
        Contains := curr^.value = x;
      END ELSE BEGIN
        Contains := FALSE;
      END; (* IF *)
  END; (* StringSetObj.Contains *)
  
  PROCEDURE StringSetObj.Add(x: STRING);
    VAR new: Node;
    BEGIN (* StringSetObj.Add *)
      IF (NOT Contains(x)) THEN BEGIN
        new := NewNode(x);
        new^.next := elements;
        elements := new;
        Inc(n);
      END; (* IF *)
  END; (* StringSetObj.Add *)

  PROCEDURE StringSetObj.Remove(x: STRING);
    VAR curr, prev: Node;
    BEGIN (* StringSetObj.Remove *)
      IF (Empty) THEN BEGIN
        WriteLn('Set is already empty, programm will be halted.');
        HALT;
      END ELSE BEGIN
        curr := elements;
        prev := NIL;
        WHILE (curr^.next <> NIL) AND (curr^.value <> x) DO BEGIN
          prev := curr;
          curr := curr^.next;
        END; (* WHILE *)

        IF (curr^.value = x) THEN BEGIN
          IF (prev <> NIL) THEN BEGIN
            prev^.next := curr^.next;
          END ELSE BEGIN
            elements := elements^.next;
          END; (* IF *)
          Dispose(curr);
          Dec(n);
        END; (* IF *)
      END; (* IF *)
  END; (* StringSetObj.Remove *)

  PROCEDURE StringSetObj.Test;
    BEGIN (* StringSetObj.Test *)
      WriteLn('n: ', n);
      SELF.Print;
  END; (* StringSetObj.Test *)

  PROCEDURE StringSetObj.Print;
    VAR curr: Node;
    BEGIN (* StringSetObj.Print *)
      curr := elements;

      WHILE (curr <> NIL) DO BEGIN
        WriteLn(curr^.value);
        curr := curr^.next;
      END; (* WHILE *)
  END; (* StringSetObj.Print *)

  FUNCTION StringSetObj.GetData: Node;
    BEGIN (* StringSetObj.GetNextNode *)
        GetData := elements
  END; (* StringSetObj.GetNextNode *)

  PROCEDURE Union(s1, s2: StringSet; VAR t: StringSet);
    VAR curr: Node;
    BEGIN (* Union *)
      New(t, Init);
      curr := s1^.GetData;
      WHILE (curr <> NIL) DO BEGIN
        t^.Add(curr^.value);
        curr := curr^.next;
      END; (* WHILE *)

      curr := s2^.GetData;
      WHILE (curr <> NIL) DO BEGIN
        IF (NOT t^.Contains(curr^.value)) THEN BEGIN
          t^.Add(curr^.value);
        END; (* IF *)
        curr := curr^.next;
      END; (* WHILE *)
  END; (* Union *)

  PROCEDURE Intersect(s1, s2: StringSet; VAR t: StringSet);
    VAR curr: Node;
    BEGIN (* Intersect *)
      New(t, Init);
      curr := s1^.GetData;
      WHILE (curr <> NIL) DO BEGIN
        t^.Add(curr^.value);
        curr := curr^.next;
      END; (* WHILE *)

      curr := t^.GetData;
      WHILE (curr <> NIL) DO BEGIN
        IF (NOT s2^.Contains(curr^.value)) THEN BEGIN
          t^.Remove(curr^.value);
        END; (* IF *)
        curr := curr^.next;
      END; (* WHILE *)
  END; (* Intersect *)

  PROCEDURE Difference(s1, s2: StringSet; VAR target: StringSet);
    VAR temp: StringSet;
        curr: Node;
    BEGIN (* Difference *)
      Union(s1, s2, target);
      Intersect(s1, s2, temp);

      curr := target^.GetData;
      WHILE (curr <> NIL) DO BEGIN
        IF (temp^.Contains(curr^.value)) THEN
          target^.Remove(curr^.value);

        curr := curr^.next;
      END; (* WHILE *)

      Dispose(temp, Done);
  END; (* Difference *)

END. (* StringSetListUnit *)