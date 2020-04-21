(* MSTest:                                                    MM, 2020-04-18 *)
(* ------                                                                    *)
(* A small program to test Multiset                                          *)
(* ========================================================================= *)
PROGRAM MSTest;

USES
  Multiset;

VAR
  ms: StrMSet;
  s: STRING;

BEGIN (* MSTest *)
  NewStrMSet(ms);
  WriteLn('IsEmpty? ', IsEmpty(ms));
  REPEAT
    Write('s > ');
    ReadLn(s);
    IF (s <> '') THEN BEGIN
      Insert(ms, s);
    END; (* IF *)
  UNTIL (s = ''); (* REPEAT *)
  WriteLn('IsEmpty? ', IsEmpty(ms));
  WriteTree(ms, 0);
  WriteLn('Cardinality: ', Cardinality(ms));
  WriteLn('CountUnique: ', CountUnique(ms));
  WriteLn('Count "m": ', Count(ms, 'm'));
END. (* MSTest *)