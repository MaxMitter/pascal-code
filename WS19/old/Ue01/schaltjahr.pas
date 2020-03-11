PROGRAM Schaltjahr;

var
    istSchaltjahr : boolean;
    jahr : integer;

BEGIN (* Schaltjahr *)
  istSchaltjahr := false;
  jahr := 2400;

  if(jahr>1582) then BEGIN
    IF (jahr mod 4) = 0 THEN BEGIN
      IF (jahr mod 100) = 0 THEN BEGIN
        IF (jahr mod 400) = 0 THEN BEGIN
          istSchaltjahr := true;
        END; (* IF *)
      END ELSE BEGIN
        istSchaltjahr := true;
      END; (* IF *)
    END; (* IF *)
  end;

  Write(istSchaltjahr)

END. (* Schaltjahr *)