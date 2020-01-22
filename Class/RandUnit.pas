UNIT RandUnit;

INTERFACE

  FUNCTION IntRand: integer;
  PROCEDURE InitRandSeed(s: integer);
  FUNCTION RangeRand(n: integer): integer;
  FUNCTION RealRand: real;
IMPLEMENTATION
  const
    M = 32768; (* 2^x *)
  var
    x: longint;

FUNCTION RangeRand(n: INTEGER): INTEGER;
VAR
    z, k: INTEGER;
BEGIN //RangeRand2
    k := m - (m mod n);
    REPEAT
        z := IntRand;
    UNTIL z < k;
    RangeRand := z MOD n;
END; //RangeRand2

  FUNCTION RealRand: real;
    BEGIN (* RealRand *)
      RealRand := IntRand / M;
    END; (* RealRand *)

  PROCEDURE InitRandSeed(s: integer);
    BEGIN (* InitRandSeed *)
      x := s;
    END; (* InitRandSeed *)

  FUNCTION IntRand: integer;
    const
      A = 3421; (* numb + 21, < m *)
      C = 1; (* 0 <= c < m *)

    BEGIN (* IntRand *)
      x := (A * x + C) MOD M;
      IntRand := x;
    END; (* IntRand *)

BEGIN (* RandUnit *)
  x := 0;
END. (* RandUnit *)