PROGRAM MovingAverage;

  var s: real;
      n: integer;

procedure Init;
begin
  s:= 0;
  n:= 0;
end;

function MovAvg(x: REAL):REAL;
begin
  s := s + x;
  n := n + 1;

  MovAvg := s/n;
end;

BEGIN
  Init;
  WriteLn(MovAvg(2));
  WriteLn(MovAvg(4));
END.