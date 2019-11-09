PROGRAM Verschluesselung;

  const str1 = 'ABCADEF';
  const str2 = 'SJJSKLM';
  const str3 = 'DIREKTEZUORDNUNGIKOG';
  const str4 = 'EKVCIBCQMLVEHMHTKILT';

FUNCTION IsPossiblePair(s1: string; s2: string): boolean;
  var i, j: integer;
      string1Letter, string2Letter: string;
BEGIN (* IsPossiblePair *)
  IsPossiblePair := true;

  IF (Length(s1) <> Length(s2)) THEN BEGIN
    IsPossiblePair := false;
  END ELSE BEGIN
    FOR i := 1 TO Length(s1) - 1 DO BEGIN
      string1Letter := s1[i];
      string2Letter := s2[i];

      FOR j := i + 1 TO Length(s2) - 1 DO BEGIN
        IF (s1[j] = string1Letter) THEN BEGIN
          IF (s2[j] <> string2Letter) THEN BEGIN
            IsPossiblePair := false;
            break;
          END; (* IF *)
        END ELSE IF (s2[j] = string2Letter) THEN BEGIN
          IF (s1[j] <> string1Letter) THEN BEGIN
            IsPossiblePair := false;
            break;
          END; (* IF *)
        END; (* IF *)
      END; (* FOR *)

    END; (* FOR *)
  END; (* IF *)
END; (* IsPossiblePair *)

BEGIN (* Verschluesselung *)
  Write(IsPossiblePair(str3, str4));
END. (* Verschluesselung *)