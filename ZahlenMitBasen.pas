PROGRAM ZahlenMitBasen;

  type NumbRange = 'A'..'Z';

  FUNCTION ValueOf(digits: string; base: INTEGER): INTEGER;

  var helpChars: array of NumbRange;
  var i: integer;
  var endSum: integer;

  BEGIN (* ValueOf *)
    IF ((base < 2) OR (base > 36)) THEN BEGIN
      Exit(-1);
    END; (* IF *)

    IF (base > 9) THEN BEGIN
      SetLength(helpChars, base - 10);
    END; (* IF *)
    
    endSum := 0;

    FOR i := 0 TO Length(helpChars) - 1 DO BEGIN
      helpChars[i] := Chr(i + Ord('A'));
    END; (* FOR *)

    FOR i := 1 TO Length(digits) DO BEGIN
      IF((digits[i] >= '0') AND ((Ord(digits[i]) - Ord('0')) < base)) THEN BEGIN
        endSum := endSum * base + Ord(digits[i]) - Ord('0');
      END ELSE IF (base > 10) THEN BEGIN
        IF ((digits[i] >= helpChars[0]) AND (digits[i] <= helpChars[Length(helpChars) - 1])) THEN BEGIN
          endSum := endSum * base + Ord(digits[i]) - Ord('A') + 10;
        END; (* IF *)
      END ELSE BEGIN
        Exit(-1);
      END;
    END; (* FOR *)

    ValueOf:= endSum; //For Testing

  END; (* ValueOf *)

  FUNCTION DigitsOf(value: integer; base: integer): string;
    var output, newDigitString: string;
    var newDigitInt: integer;
    var decreaseInteger: boolean;

  BEGIN (* DigitsOf *)
    output := '';

    IF ((base < 2) OR (base > 36)) THEN BEGIN
      Exit('-1');
    END; (* IF *)

    WHILE (value > 0) DO BEGIN

      decreaseInteger := false;

      IF (value < base) THEN BEGIN
        newDigitInt := value;
      END ELSE BEGIN
        newDigitInt := value MOD base;
      END; (* IF *)
      
      IF (newDigitInt < 10) THEN BEGIN
        newDigitString := Chr(newDigitInt + Ord('0'));
      END ELSE BEGIN
        newDigitString := Chr(newDigitInt - 10 + Ord('A'));    
      END; (* IF *)

      output := newDigitString + output;

      IF (Round(value/base) > value/base) THEN BEGIN
        decreaseInteger := true;
      END ELSE BEGIN
        decreaseInteger := false;  
      END; (* IF *)

      value := Round(value/base);

      IF (decreaseInteger) THEN BEGIN
        Dec(value);
      END; (* IF *)

    END; (* WHILE *)

    DigitsOf := output;
  END; (* DigitsOf *)

  FUNCTION Sum(v1: string; b1: integer; v2: string; b2: integer): integer;
    var v1InDecimal, v2InDecimal: integer;
  BEGIN (* Sum *)
    v1InDecimal := ValueOf(v1, b1);
    v2InDecimal := ValueOf(v2, b2);
    Sum := v1InDecimal + v2InDecimal;
  END; (* Sum *)

  FUNCTION Diff(v1: string; b1: integer; v2: string; b2: integer): integer;
    var v1InDecimal, v2InDecimal: integer;
  BEGIN (* Diff *)
    v1InDecimal := ValueOf(v1, b1);
    v2InDecimal := ValueOf(v2, b2);
    
    IF (v1InDecimal > v2InDecimal) THEN BEGIN
      Diff := v1InDecimal - v2InDecimal;
    END ELSE BEGIN
      Diff := v2InDecimal - v1InDecimal;
    END; (* IF *)
  END; (* Diff *)

  FUNCTION Prod(v1: string; b1: integer; v2: string; b2: integer): integer;
    var v1InDecimal, v2InDecimal: integer;
  BEGIN (* Prod *)
    v1InDecimal := ValueOf(v1, b1);
    v2InDecimal := ValueOf(v2, b2);
    Prod := v1InDecimal * v2InDecimal;
  END; (* Prod *)

  FUNCTION Quot(v1: string; b1: integer; v2: string; b2: integer): integer;
    var v1InDecimal, v2InDecimal: integer;
  BEGIN (* Quot *)
    v1InDecimal := ValueOf(v1, b1);
    v2InDecimal := ValueOf(v2, b2);
    
    IF (v1InDecimal > v2InDecimal) THEN BEGIN
      Quot := Round(v1InDecimal / v2InDecimal);
    END ELSE BEGIN
      Quot := Round(v2InDecimal / v1InDecimal);
    END; (* IF *)
  END; (* Quot *)

  var number: string;
  var base: integer;

  var v1, v2: string;
  var b1, b2: integer;

BEGIN (* ZahlenMitBasen *)
  (*Write('Zahl: ');
  ReadLn(number);
  Write('Basis: ');
  ReadLn(base);

  Write(ValueOf(number, base), ', ');
  Write(DigitsOf(ValueOf(number, base), base)); *)

  Write('Zahl 1: ');
  ReadLn(v1);
  Write('Basis 1: ');
  ReadLn(b1);
  Write('Zahl 2: ');
  ReadLn(v2);
  Write('Basis 2: ');
  ReadLn(b2);

  IF (b1 = b2) THEN BEGIN
    Write('Ergebnis: ', DigitsOf(Quot(v1, b1, v2, b2), b1), ' (Basis: ', b1, ')');
  END ELSE BEGIN
      Write('Ergebnis: ', Quot(v1, b1, v2, b2), ' (Basis: 10)');
  END; (* IF *)
  
END. (* ZahlenMitBasen *)