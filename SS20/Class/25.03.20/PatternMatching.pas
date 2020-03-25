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
    BEGIN (* BruteSearchLR2 *)
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

  FUNCTION BruteSearchRL(s, p: STRING): INTEGER;
    VAR sLen, pLen: INTEGER;
        i, j: INTEGER;
    BEGIN (* BruteSearchRL *)
      sLen := Length(s);
      pLen := Length(p);

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        BruteSearchRL := 0;
      END ELSE BEGIN
        i := pLen;
        j := pLen;

        REPEAT
          IF (Equals(s[i], p[j])) THEN BEGIN
            Dec(i);
            Dec(j);
          END ELSE BEGIN
            i := i + pLen - j + 1;
            j := pLen;
          END; (* IF *)
        UNTIL ((j < 1) OR (i > sLen)); (* REPEAT *)

        IF (j < 1) THEN
          BruteSearchRL := i + 1
        ELSE
          BruteSearchRL := 0;
      END; (* IF *)
  END; (* BruteSearchRL *)

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

  FUNCTION BoyerMoore(s, p: STRING): INTEGER;
    VAR skip: ARRAY[CHAR] OF INTEGER;
        sLen, pLen: INTEGER;
        i, j: INTEGER;

    PROCEDURE InitSkip;
      VAR ch: CHAR;
          i: INTEGER;
      BEGIN (* InitSkip *)
        FOR ch := Low(skip) TO High(skip) DO BEGIN
          skip[ch] := pLen;
        END;(* FOR *)

        FOR i := 1 TO pLen DO BEGIN
          skip[p[i]] := pLen - i;
        END; (* FOR *)
    END; (* InitSkip *)

    BEGIN (* BoyerMoore *)
      sLen := Length(s);
      pLen := Length(p);

      InitSkip;

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        BoyerMoore := 0;
      END ELSE BEGIN
        i := pLen;
        j := pLen;

        REPEAT
          IF (Equals(s[i], p[j])) THEN BEGIN
            Dec(i);
            Dec(j);
          END ELSE BEGIN
            IF (pLen - j + 1 > skip[s[i]]) THEN
              i := i + pLen - j + 1
            ELSE
              i := i + skip[s[i]];
            j := pLen;
          END; (* IF *)
        UNTIL ((j < 1) OR (i > sLen)); (* REPEAT *)

        IF (j < 1) THEN
          BoyerMoore := i + 1
        ELSE
          BoyerMoore := 0;
      END; (* IF *)
  END; (* BoyerMoore *)

  FUNCTION RabinKarp(s, p: STRING): INTEGER;
    CONST
      B = 256;     (* base of strings interpreted as number *)
      Q = 8355967; (* large prime number *)
    VAR sLen, pLen: INTEGER;
        hp, hs: LONGINT; (* Hash of p, Hash of s *)
        b_m: LONGINT; (* = B ^ (pLen - 1) *)
        i, j, k: INTEGER;
    BEGIN (* RabinKarp *)
      sLen := Length(s);
      pLen := Length(p);

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        RabinKarp := 0;
      END ELSE BEGIN
        b_m := 1;
        FOR i := 1 TO pLen - 1 DO BEGIN
          b_m := (b_m * B) MOD Q;
        END; (* FOR *)

        hp := 0;
        hs := 0;
        FOR i := 1 TO pLen DO BEGIN
          hp := (hp * B + Ord(p[i])) MOD Q;
          hs := (hs * B + Ord(s[i])) MOD Q;
        END; (* FOR *)

        i := 1;
        j := 1;

        WHILE ((i <= (sLen - pLen + 1)) AND (j <= pLen)) DO BEGIN
          IF (hp = hs) THEN BEGIN
            j := 1;
            k := i;
            WHILE ((j <= pLen) AND (Equals(s[k], p[j]))) DO BEGIN
              Inc(j);
              Inc(k);
            END; (* WHILE *)
          END; (* IF *)

          hs := (hs + B * Q - Ord(s[i]) * b_m) MOD Q;
          hs := (hs * B) MOD Q;
          hs := (hs + Ord(s[i + plen])) MOD Q;
          Inc(i);
        END; (* WHILE *)

        IF (j > pLen) THEN
          RabinKarp := i - 1
        ELSE
          RabinKarp := 0;
      END; (* IF *)
  END; (* RabinKarp *)


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
    Write('Enter s > ');
    ReadLn(s);
    Write('Enter p > ');
    ReadLn(p);

    TestPatternMatcher(BruteSearchLR1, 'BruteSearchLR1', s, p);
    TestPatternMatcher(BruteSearchLR2, 'BruteSearchLR2', s, p);
    TestPatternMatcher(BruteSearchRL, 'BruteSearchRL', s, p);
    TestPatternMatcher(KnutMorrisPratt1, 'KMP1', s, p);
    TestPatternMatcher(KnutMorrisPratt2, 'KMP2', s, p);
    TestPatternMatcher(BoyerMoore, 'BoyerMoore', s, p);
    TestPatternMatcher(RabinKarp, 'RabinKarp', s, p);
  UNTIL (s = ''); (* REPEAT *)
END. (* PatternMatching *)