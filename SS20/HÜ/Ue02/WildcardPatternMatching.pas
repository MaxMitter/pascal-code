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
      Equals := (a = b);
  END; (* Equals *)

  FUNCTION BruteSearchLR(s, p: STRING): BOOLEAN;
    VAR sLen, pLen: INTEGER;
        i, j: INTEGER;
    BEGIN (* BruteSearchLR *)
      sLen := Length(s);
      pLen := Length(p);

      IF (pLen = 0) OR (sLen = 0) OR (pLen > sLen) THEN BEGIN
        BruteSearchLR := FALSE;
      END ELSE BEGIN
        i := 1;
        j := 1;

        REPEAT
          IF (Equals(s[i], p[j]) OR Equals(p[j], '?')) THEN BEGIN
            Inc(i);
            Inc(j);
          END ELSE BEGIN
            i := i - j + 2;
            j := 1;
          END; (* IF *)  
        UNTIL ((j > pLen) OR (i > sLen)); (* REPEAT *)

        IF (j > pLen) THEN BEGIN
          BruteSearchLR := TRUE;
        END ELSE BEGIN
          BruteSearchLR := FALSE;
        END; (* IF *)
      END; (* IF *)
  END; (* BruteSearchLR *)

  FUNCTION BruteForceWithWildCard(s, p: STRING): BOOLEAN;
    BEGIN (* BruteForceWithWildCard *)
      IF (Equals(s, p)) THEN BEGIN
        BruteForceWithWildCard := TRUE;
      END ELSE BEGIN
        IF (Equals(s[1], p[1])) THEN BEGIN
          Delete(s, 1, 1);
          Delete(p, 1, 1);
          BruteForceWithWildCard := BruteForceWithWildCard(s, p);
        END ELSE IF (Equals('*', p[1])) THEN BEGIN
          IF (Equals(s[1], p[2])) THEN
            Delete(p, 1, 1)
          ELSE IF (Equals('*', p[2])) THEN BEGIN
            REPEAT
              Delete(p, 1, 1);
            UNTIL (NOT Equals('*', p[2]));
          END ELSE
            Delete(s, 1, 1);

          BruteForceWithWildCard := BruteForceWithWildCard(s, p);
        END ELSE BEGIN
          BruteForceWithWildCard := FALSE;
        END; (* IF *)    
      END; (* IF *)
  END; (* BruteForceWithWildCard *)

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
    //TestPatternMatcher(BruteSearchLR, 'BruteSearchLRWith?', s, p);
    TestPatternMatcher(BruteForceWithWildCard, 'BruteSearchWithWildCard', s, p);
  UNTIL ((s = '') AND (p = '')); (* REPEAT *)
END. (* WildCardPatternMatching *)