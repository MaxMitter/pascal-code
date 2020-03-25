(* WildCardPatternMatching:                                   MM, 2020-03-20 *)
(* ------                                                                    *)
(* Code to use wildcards in pattern matching                                 *)
(* ========================================================================= *)

PROGRAM WildCardPatternMatching;

  VAR charComps: INTEGER;
  TYPE PatternMatcher = FUNCTION(s, p: STRING): BOOLEAN;

  PROCEDURE Init;
    BEGIN (* Init *)
      charComps := 0;
  END; (* Init *)

  PROCEDURE WriteCharComps;
    BEGIN (* WriteCharComps *)
      Write(charComps);
  END; (* WriteCharComps *)

  FUNCTION Equals(a, b: STRING): BOOLEAN;
    BEGIN (* Equals *)
      Inc(charComps);
      Equals := (a = b) OR (b = '?');
  END; (* Equals *)

  FUNCTION BruteSearchLR(s, p: STRING): INTEGER;
    VAR sLen, pLen: INTEGER;
        i, j: INTEGER;
    BEGIN (* BruteSearchLR *)
      sLen := Length(s);
      pLen := Length(p);

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        BruteSearchLR := 0;
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
          BruteSearchLR := i - pLen;
        END ELSE BEGIN
          BruteSearchLR := 0;
        END; (* IF *)
      END; (* IF *)
  END; (* BruteSearchLR *)

  FUNCTION BruteSearchWithWildCard(s, p: STRING): BOOLEAN;
    VAR i: INTEGER;
        hasOnlyStars: BOOLEAN;
        sLen, pLen: INTEGER;
    BEGIN (* BruteSearchWithWildCard *)
      sLen := Length(s);
      pLen := Length(p);
      IF((sLen = 1) AND (pLen = 1)) THEN
        BruteSearchWithWildCard := Equals(s, p)
      ELSE IF (sLen = 1) THEN BEGIN
        hasOnlyStars := TRUE;
        FOR i := 1 TO pLen - 1 DO BEGIN
          IF (NOT Equals(p[i], '*')) THEN
            hasOnlyStars := FALSE;
        END; (* FOR *)
        BruteSearchWithWildCard := hasOnlyStars;
      END ELSE IF (pLen = 1) THEN
        BruteSearchWithWildCard := FALSE
      ELSE BEGIN
        IF (Equals(s[1], p[1]) OR (p[1] = '*')) THEN BEGIN
          IF (p[1] = '*') THEN BEGIN
            IF (Equals(s[1], p[2])) THEN
              Delete(p, 1, 2);
            Delete(s, 1, 1);
            BruteSearchWithWildCard := BruteSearchWithWildCard(s, p);
          END ELSE BEGIN
            Delete(s, 1, 1);
            Delete(p, 1, 1);
            BruteSearchWithWildCard := BruteSearchWithWildCard(s, p);
          END; (* IF *)
        END; (* IF *)
      END; (* IF *)
  END; (* BruteSearchWithWildCard *)

  PROCEDURE TestPatternMatcher(pm: PatternMatcher; pmName: STRING; s, p: STRING);
    BEGIN (* TestPatternMatcher *)
      Init;
      Write(pmName, ': ', pm(s, p), ', comparisons: ');
      WriteCharComps;
      WriteLn();
  END; (* TestPatternMatcher *)

  var s, p: STRING;

BEGIN (* WildCardPatternMatching *)
  REPEAT
    Init;
    Write('Enter s > ');
    ReadLn(s);
    Write('Enter p > ');
    ReadLn(p);

    TestPatternMatcher(BruteSearchWithWildCard, 'BruteSearchWithWildCard', s, p);
  UNTIL ((s = '') AND (p = '')); (* REPEAT *)
END. (* WildCardPatternMatching *)