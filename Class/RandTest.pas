PROGRAM RandTest;
USES RandUnit;

  var
    i: integer;

BEGIN (* RandTest *)
  InitRandSeed(20);
  for i := 1 to 20 do begin
    Write(RangeRand(20), ', ');
  end;

END. (* RandTest *)