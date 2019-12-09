PROGRAM IpAdressen;  

  FUNCTION IsSmaller(a, b: IPAddrNode): boolean;
    BEGIN (* IsSmaller *)
      IsSmaller := (a.addr[1] > b.addr[1]) OR ((a.addr[1] = b.addr[1]) AND (a.addr[2] > b.addr[2])) OR ((a.addr[1] = b.addr[1])
                  AND (a.addr[2] = b.addr[2]) AND (a.addr[3] > b.addr[3]));
    END; (* IsSmaller *)


  var ipStr: string;
      ip: IPAddrNode;
BEGIN
  
END.