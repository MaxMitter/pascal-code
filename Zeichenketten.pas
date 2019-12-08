PROGRAM Zeichenketten;
USES ZeichenkettenUnit;

  var str, s2, s3: CharListPtr;

BEGIN (* Zeichenketten *)
  str := CharListOf('Long Test String of sorts');
  s2 := CharListOf(' this is the second test string.');
  WriteLn(StringOf(str));
  WriteLn(CLLength(str));
  s3 := CLConcat(str, s2);
  WriteLn(StringOf(s3));
  str := CharListOf('This is a new test');
  WriteLn(StringOf(str));
  WriteLn(StringOf(s3)); 
END. (* Zeichenketten *)