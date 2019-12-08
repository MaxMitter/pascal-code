PROGRAM IpAdressen;

  const IP4MAX = 4;

  type
    IPAddrNodePtr = ^IPAddrNode;
    IPAddrNode = record
                  prev, next: IPAddrNodePtr;
                  addr: array [1..IP4MAX] of byte;
                  n: integer;
                 end; (* RECORD *)

  FUNCTION IsSmaller(a, b: IPAddrNode): boolean;
  BEGIN (* IsSmaller *)
    IsSmaller := (a.addr[1] > b.addr[1]) OR ((a.addr[1] = b.addr[1]) AND (a.addr[2] > b.addr[2])) OR ((a.addr[1] = b.addr[1])
                 AND (a.addr[2] = b.addr[2]) AND (a.addr[3] > b.addr[3]));
  END; (* IsSmaller *)

BEGIN
END.