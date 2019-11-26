PROGRAM Balkendiagramm;

  FUNCTION Maximum(ni: array of integer): integer;
    var i, max: integer;
  BEGIN (* Maximum *)
    max := 0;
    for i := 0 to Length(ni) - 1 do begin
      if (ni[i] > max) then
        max := ni[i];
    end; (* FOR *)
    Maximum := max;
  END; (* Maximum *)

  PROCEDURE BarChart(ch: char; ni: array of integer);
    var row, col: integer;
  BEGIN (* BarChart *)
    for row := Maximum(ni) downto 1 do begin
      Write(row:2, '|');
      for col := Low(ni) to High(ni) do begin
        if (ni[col] >= row) then begin
          Write(ch:2);
        end else begin
          Write('':2);
        end; (* IF *)
      end; (* FOR col*)
      WriteLn();
    end; (* FOR row*)

    for col := Low(ni) to High(ni) do begin
      if col = Low(ni) then begin
        Write('+':3);
      end else begin
        Write('--':3);
      end; (* IF *)
    end; (* FOR Legende*)
    WriteLn();
    for col := Low(ni) to High(ni) do begin
      if col = Low(ni) then begin
        Write('1':5);
      end else begin
        Write((col - Low(ni) + 1):2);
      end; (* IF *)
    end; (* FOR Beschriftung*)

  END; (* BarChart *)

  var cha: char;
      n, i: integer;
      numbers: array of integer;

BEGIN (* Balkendiagramm *)
  Write('ch: ');
  ReadLn(cha);

  Write('n: ');
  ReadLn(n);
  SetLength(numbers, n);

  Write('numbers: ');

  for i := Low(numbers) to High(numbers) do begin
    Read(numbers[i]);
    if ((numbers[i] > 10) OR (numbers[i] < 1)) then begin
      Write('Wert ungueltig, Programm wird beendet');
      Exit;
    end; (* IF *)
  end; (* FOR *)
  BarChart(cha, numbers);
END. (* Balkendiagramm *)