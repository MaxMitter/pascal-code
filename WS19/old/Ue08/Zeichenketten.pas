PROGRAM Zeichenketten;
USES ZeichenkettenUnit;

  var s1, s2, s3: CharListPtr;
  var st1, st2: string;
BEGIN (* Zeichenketten *)
  ReadLn(st1);
  s1 := CharListOf(st1);
  ReadLn(st2);
  s2 := CharListOf(st2);
  { WriteLn(StringOf(s1));
  WriteLn(CLLength(s1)); }
  s3 := CLConcat(s1, s2);
  WriteLn(StringOf(s3));
  ReadLn(st1);
  s1 := CharListOf(st1);
  WriteLn(StringOf(s1));
  WriteLn(StringOf(s3)); 
END. (* Zeichenketten *)