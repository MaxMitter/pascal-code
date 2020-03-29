(* StringRotation:                                            MM, 2020-03-20 *)
(* ------                                                                    *)
(* A Program to rotate find rotations in certain strings                     *)
(* ========================================================================= *)

PROGRAM StringRotation;

  FUNCTION KnutMorrisPratt2(s, p: STRING): INTEGER;
    VAR next: ARRAY[1..255] OF INTEGER;
        sLen, pLen: INTEGER;
        i, j: INTEGER;

    PROCEDURE InitNext;
      BEGIN (* InitNext *)
        i := 1;
        j := 0;
        next[1] := 0;

        WHILE (i < pLen) DO BEGIN
          IF ((j = 0) OR (p[i] = p[j])) THEN BEGIN
            Inc(i);
            Inc(j);
            IF (NOT (p[i] = p[j])) THEN
              next[i] := j
            ELSE
              next[i] := next[j];
          END ELSE BEGIN
            j := next[j];
          END; (* IF *)
        END; (* WHILE *)
    END; (* InitNext *)

    BEGIN (* KnutMorrisPratt2 *)
      sLen := Length(s);
      pLen := Length(p);

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        KnutMorrisPratt2 := 0;
      END ELSE BEGIN
        InitNext;
        i := 1;
        j := 1;

        REPEAT
          IF (j = 0) OR (s[i] = p[j]) THEN BEGIN
            Inc(i);
            Inc(j);
          END ELSE BEGIN
            j := next[j];
          END; (* IF *)  
        UNTIL ((j > pLen) OR (i > sLen)); (* REPEAT *)

        IF (j > pLen) THEN BEGIN
          KnutMorrisPratt2 := i - pLen;
        END ELSE BEGIN
          KnutMorrisPratt2 := 0;
        END; (* IF *)
      END; (* IF *)
  END; (* KnutMorrisPratt2 *)

  FUNCTION ConcatRotation(a, b: STRING): BOOLEAN;
    BEGIN (* ConcatRotation *)
      IF (Length(a) = Length(b)) THEN BEGIN
        a := a + a;
        ConcatRotation := KnutMorrisPratt2(a, b) <> 0;
      END ELSE BEGIN
        ConcatRotation := FALSE;
      END; (* IF *)
  END; (* ConcatRotation *)

  FUNCTION IsRotation(a, b: STRING): BOOLEAN;
    VAR aLen, bLen: INTEGER;
        initialB: STRING;
    BEGIN (* IsRotation *)
      aLen := Length(a);
      bLen := Length(b);
      initialB := b;
      IF (aLen = bLen) THEN BEGIN
        Repeat
          b := b + b[1];
          Delete(b, 1, 1);
        UNTIL ((a = b) OR (b = initialB))
      END; (* IF *)
      IsRotation := (a = b);
  END; (* IsRotation *)

  VAR a, b: STRING;

BEGIN (* StringRotation *)
  REPEAT
    Write('Enter a > ');
    ReadLn(a);
    Write('Enter b > ');
    ReadLn(b);

    WriteLn('Is ', b, ' a rotation of ', a, '? ', ConcatRotation(a, b), ' (Concat-Rotation)');
    WriteLn('Is ', b, ' a rotation of ', a, '? ', IsRotation(a, b), ' (Rotation)');
  UNTIL ((a = '') OR (b = '')); (* REPEAT *)
END. (* StringRotation *)