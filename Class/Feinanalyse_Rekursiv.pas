PROCEDURE Reverse;
  var ch: char;
  BEGIN (* Reverse *)
    Read(ch);
    if ch <> '' then begin
      Reverse;
      Write(ch);
    end;
  END; (* Reverse *)