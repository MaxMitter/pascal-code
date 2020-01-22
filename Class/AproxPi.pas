PROGRAM AproxPi;
USES RandUnit;

  FUNCTION ApproximatePi(n: longint): real;
    var
      i: longint;
      nrOfPointsInCircle: longint;
      x, y: real;
    BEGIN (* ApproximatePi *)
      nrOfPointsInCircle := 0;

      for i := 1 to n do begin
        x := RealRand;
        y := RealRand;

        if (x * x + y * y) <= 1.0 then begin
          Inc(nrOfPointsInCircle);
        end; (* IF *)
      end; (* FOR *)

      ApproximatePi := 4 * (nrOfPointsInCircle / n);
    END; (* ApproximatePi *)

BEGIN (* AproxPi *)
  Write(ApproximatePi(10000000):2:8);
END. (* AproxPi *)