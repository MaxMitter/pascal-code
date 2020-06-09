PROGRAM MapTest;

  USES MapClass;

  VAR m: Map;
      s, c: STRING;
BEGIN (* MapTest *)
  New(m, Init);

  WriteLn('(1) Enter new Value');
  WriteLn('(2) Remove Value');
  WriteLn('(3) Get Value from Key');
  WriteLn('(4) Print Map');
  WriteLn('(5) GetSize');
  WriteLn('(0) End Program');

  REPEAT
    Write('Enter Number > ');
    ReadLn(s);
    IF (s = '1') THEN BEGIN
      Write('Enter new Key > ');
      ReadLn(s);
      Write('Enter new Value > ');
      ReadLn(c);
      m^.Put(s, c);
    END ELSE IF (s = '2') THEN BEGIN
      Write('Enter key to remove > ');
      ReadLn(c);
      m^.Remove(c);
    END ELSE IF (s = '3') THEN BEGIN
      Write('Enter key to get value > ');
      ReadLn(c);
      m^.GetValue(c, s);
      WriteLn('Key: ', c, ', Value: ', s);
    END ELSE IF (s = '4') THEN BEGIN
      m^.WriteMap;
    END ELSE IF (s = '5') THEN BEGIN
      WriteLn('Nr of elements in Map: ', m^.GetSize);
    END; (* IF *)
  UNTIL (s = '0'); (* REPEAT *)

  Dispose(m, Done);
END. (* MapTest *)