PROGRAM MA;

function MovAvg(x: REAL):REAL;
  const s : REAL = 0;
  const n : INTEGER = 0;
begin
  s := s + x;
  Inc(n);
  MovAvg := s/n;
end;

begin
  WriteLn(MovAvg(2));
  WriteLn(MovAvg(4));
end.