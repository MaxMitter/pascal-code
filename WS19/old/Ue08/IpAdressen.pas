PROGRAM IpAdressen;  
USES ZugriffszahlenUnit;
  var l: IPAddrList;
      ip: IpAddr;
      s: string;
BEGIN
  InitList(l);
  
  ReadLn(s);

  while s <> '' do begin
    ReadIp(s, ip);
    NewAccess(l, ip);
    ReadLn(s);
  end; (* WHILE *)

  WriteList(l);
END.