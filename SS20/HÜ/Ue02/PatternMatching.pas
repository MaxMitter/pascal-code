(* PatternMatching:                                           MM, 2020-03-18 *)
(* ------                                                                    *)
(* SImple pattern matching algorithms for strings                            *)
(* ========================================================================= *)

PROGRAM PatternMatching;

  TYPE PatternMatcher = FUNCTION(s, p: STRING): INTEGER;

  VAR charComps: INTEGER;

  PROCEDURE Init;
  BEGIN (* Init *)
    charComps := 0;
  END; (* Init *)

  PROCEDURE WriteCharComps;
  BEGIN (* WriteCharComps *)
    Write(charComps);
  END; (* WriteCharComps *)

  FUNCTION Equals(a, b: CHAR): BOOLEAN;
  BEGIN (* Equals *)
    Inc(charComps);
    Equals := a = b;
  END; (* Equals *)

  FUNCTION BruteSearchLR1(s, p: STRING): INTEGER;
    VAR sLen, pLen: INTEGER;
        i, j: INTEGER;
    BEGIN (* BruteSearchLR1 *)
      sLen := Length(s);
      pLen := Length(p);

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        BruteSearchLR1 := 0;
      END ELSE BEGIN
        i := 1;
        REPEAT
          j := 1;
          WHILE ((j <= pLen) AND (Equals(p[j], s[i + j - 1]))) DO BEGIN
            Inc(j);
          END; (* WHILE *)
          Inc(i);
        UNTIL ((j > pLen) OR (i > sLen - pLen + 1)); (* REPEAT *)
        
        IF (j > pLen) THEN BEGIN
          BruteSearchLR1 := i - 1;
        END ELSE BEGIN
          BruteSearchLR1 := 0;
        END; (* IF *)
      END; (* IF *)
  END; (* BruteSearchLR1 *)

  FUNCTION BruteSearchLR2(s, p: STRING): INTEGER;
    VAR sLen, pLen: INTEGER;
        i, j: INTEGER;
    BEGIN (* BruteSearchLR1 *)
      sLen := Length(s);
      pLen := Length(p);

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        BruteSearchLR2 := 0;
      END ELSE BEGIN
        i := 1;
        j := 1;

        REPEAT
          IF (Equals(s[i], p[j])) THEN BEGIN
            Inc(i);
            Inc(j);
          END ELSE BEGIN
            i := i - j + 2;
            j := 1;
          END; (* IF *)  
        UNTIL ((j > pLen) OR (i > sLen)); (* REPEAT *)

        IF (j > pLen) THEN BEGIN
          BruteSearchLR2 := i - pLen;
        END ELSE BEGIN
          BruteSearchLR2 := 0;
        END; (* IF *)
      END; (* IF *)
  END; (* BruteSearchLR1 *)

  FUNCTION KnutMorrisPratt1(s, p: STRING): INTEGER;
    VAR next: ARRAY[1..255] OF INTEGER;
        sLen, pLen: INTEGER;
        i, j: INTEGER;

    PROCEDURE InitNext;
      BEGIN (* InitNext *)
        i := 1;
        j := 0;
        next[1] := 0;

        WHILE (i < pLen) DO BEGIN
          IF ((j = 0) OR Equals(p[i], p[j])) THEN BEGIN
            Inc(i);
            Inc(j);
            next[i] := j;
          END ELSE BEGIN
            j := next[j];
          END; (* IF *)
        END; (* WHILE *)
    END; (* InitNext *)

    BEGIN (* KnutMorrisPratt1 *)
      sLen := Length(s);
      pLen := Length(p);

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        KnutMorrisPratt1 := 0;
      END ELSE BEGIN
        InitNext;
        i := 1;
        j := 1;

        REPEAT
          IF (j = 0) OR (Equals(s[i], p[j])) THEN BEGIN
            Inc(i);
            Inc(j);
          END ELSE BEGIN
            j := next[j];
          END; (* IF *)  
        UNTIL ((j > pLen) OR (i > sLen)); (* REPEAT *)

        IF (j > pLen) THEN BEGIN
          KnutMorrisPratt1 := i - pLen;
        END ELSE BEGIN
          KnutMorrisPratt1 := 0;
        END; (* IF *)
      END; (* IF *)
  END; (* KnutMorrisPratt2 *)

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
          IF ((j = 0) OR Equals(p[i], p[j])) THEN BEGIN
            Inc(i);
            Inc(j);
            IF (NOT Equals(p[i], p[j])) THEN
              next[i] := j
            ELSE
              next[i] := next[j];
          END ELSE BEGIN
            j := next[j];
          END; (* IF *)
        END; (* WHILE *)
    END; (* InitNext *)

    BEGIN (* KnutMorrisPratt1 *)
      sLen := Length(s);
      pLen := Length(p);

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        KnutMorrisPratt2 := 0;
      END ELSE BEGIN
        InitNext;
        i := 1;
        j := 1;

        REPEAT
          IF (j = 0) OR (Equals(s[i], p[j])) THEN BEGIN
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


  PROCEDURE TestPatternMatcher(pm: PatternMatcher; pmName: STRING; s, p: STRING);
    BEGIN (* TestPatternMatcher *)
      Init;
      Write(pmName, ': ', pm(s, p), ', comparisons: ');
      WriteCharComps;
      WriteLn();
  END; (* TestPatternMatcher *)

  var s, p: STRING;

BEGIN (* PatternMatching *)
  REPEAT
    Init;
    Write('Enter s > ');
    ReadLn(s);
    Write('Enter p > ');
    ReadLn(p);

    TestPatternMatcher(BruteSearchLR1, 'BruteSearchLR1', s, p);
    TestPatternMatcher(BruteSearchLR2, 'BruteSearchLR2', s, p);
    TestPatternMatcher(KnutMorrisPratt1, 'KMP1', s, p);
    TestPatternMatcher(KnutMorrisPratt2, 'KMP2', s, p);
  UNTIL (s = ''); (* REPEAT *)
END. (* PatternMatching *)