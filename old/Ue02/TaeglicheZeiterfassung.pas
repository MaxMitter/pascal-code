PROGRAM TaeglicheZeiterfassung;
  var hours, minutes: integer;
  var realHours, ZAHours: real;
  var normHours, maxHours: integer;
BEGIN (* TaeglicheZeiterfassung *)
  
  ZAHours := 0;
  normHours := 8;
  maxHours := 12;
  Read(hours);
  Read(minutes);

  realHours := hours + minutes / 60;

  IF (realHours > maxHours) THEN BEGIN
    Writeln('Taegliche Hoechstarbeitszeit ueberschritten');
    Exit;
  END; (* IF *)

  IF (realHours > 10) THEN BEGIN
    ZAHours := ZAHours + (realHours - 10) * 1.5;
    ZAHours := ZAHours + 2;
    END ELSE BEGIN
      ZAHours := ZAHours + realHours - normHours;
  END; (* IF *)

  Writeln('Anspruch auf Zeitausgleich: ', ZAHours:2:2, ' Stunden');

END. (* TaeglicheZeiterfassung *)