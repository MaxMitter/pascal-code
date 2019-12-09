UNIT ZugriffszahlenUnit;

INTERFACE
  const IP4MAX = 4;

  type
    IpAddr = array[1..IP4MAX] of byte;
    IPAddrNodePtr = ^IPAddrNode;
    IPAddrNode = record
                  prev, next: IPAddrNodePtr;
                  addr: IpAddr;
                  count: integer;
                 end; (* RECORD *)
    IpAddrList = record
                  first, last: IPAddrNodePtr;
                  end;

  PROCEDURE ReadIP(ipStr: string; var ip: IpAddr);
  PROCEDURE WriteIP(ip: IpAddr);
  FUNCTION IsSorted(l: IpAddrList): boolean;
  PROCEDURE Append(var l: IpAddrList; n: IPAddrNodePtr);
  PROCEDURE Prepend(var l: IpAddrList; n: IPAddrNodePtr);
  FUNCTION FindNode(l: IpAddrList; x: IpAddr): IPAddrNodePtr;
  PROCEDURE InsertSorted(var l: IpAddrList; n: IPAddrNodePtr);
  PROCEDURE InitList(var l: IpAddrList);

IMPLEMENTATION
  PROCEDURE InitList(var l: IpAddrList);
    BEGIN
      l.first := NIL;
      l.last := NIL;
    END;
  PROCEDURE ReadIP(ipStr: string; var ip: IpAddr);
    var i: integer;
        endIdx: integer;
    BEGIN
      endIdx := Pos('.', ipStr);
      for i := 1 to 4 do begin
        Val(Copy(ipStr, 1, endIdx-1), ip[i]);
        Delete(ipStr, 1, endIdx);
        endIdx := Pos('.', ipStr);
        if endIdx <= 0 then endIdx := Length(ipStr) + 1;  
      end; (* FOR *)
    END; (* READIP *)

  PROCEDURE WriteIP(ip: IpAddr);
    BEGIN
      WriteLn(ip[1], '.', ip[2], '.', ip[3], '.', ip[4]);
    END;


BEGIN
END.