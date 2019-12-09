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
    IPAddrList = IPAddrNodePtr;

  PROCEDURE ReadIP(ipStr: string; var ip: IpAddr);
  PROCEDURE WriteIP(ip: IpAddr);
  FUNCTION IsSorted(l: IpAddrList): boolean;
  PROCEDURE Append(var l: IpAddrList; n: IPAddrNodePtr);
  PROCEDURE Prepend(var l: IpAddrList; n: IPAddrNodePtr);
  FUNCTION FindNode(l: IpAddrList; x: IpAddr): IPAddrNodePtr;
  PROCEDURE InsertSorted(var l: IpAddrList; n: IPAddrNodePtr);
  PROCEDURE InitList(var l: IpAddrList);
  FUNCTION NewNode(x: IpAddr): IPAddrNodePtr;
  PROCEDURE NewAccess(var l: IPAddrList; x: IpAddr);
  PROCEDURE WriteNode(n: IPAddrNodePtr);
  PROCEDURE WriteList(l: IPAddrList);
  FUNCTION IsEqual(a, b: IPAddr): boolean;
IMPLEMENTATION

  FUNCTION IsSmaller(a, b: IPAddr): boolean;
    BEGIN
      if a[1] < b[1] then begin
        IsSmaller := true;
      end else if a[1] = b[1] then begin
        if a[2] < b[2] then begin
          IsSmaller := true;
        end else if a[2] = b[2] then begin
          if a[3] < b[3] then begin
            IsSmaller := true;
          end else if a[3] = b[3] then begin
            if a[4] < b[4] then
              IsSmaller := true
            else
              IsSmaller := false;
          end else begin
            IsSmaller := false;
          end; (* IF [3] *)
        end else begin
          IsSmaller := false;
        end; (* IF [2] *)
      end else begin
        IsSmaller := false;
      end; (* IF [1] *)
    END;

  FUNCTION IsEqual(a, b: IPAddr): boolean;
    BEGIN
      if a[1] = b[1] then begin
        if a[2] = b[2] then begin
          if a[3] = b[3] then begin
            if a[4] = b[4] then
              IsEqual := true
            else
              IsEqual := false;
          end else begin
            IsEqual := false;
          end; (* IF [3] *)
        end else begin
          IsEqual := false;
        end; (* IF [2] *)
      end else begin
        IsEqual := false;
      end; (* IF [1] *)
    END;

  PROCEDURE Append(var l: IPAddrList; n: IPAddrNodePtr);
    BEGIN
      n^.prev := l^.prev;
      n^.next := l;
      l^.prev^.next := n;
      l^.prev := n;
    END;

  PROCEDURE Prepend(var l: IPAddrList; n: IPAddrNodePtr);
    BEGIN
      n^.next := l^.next;
      n^.prev := l;
      l^.next^.prev := n;
      l^.next := n;
    END;

  FUNCTION FindNode(l: IPAddrList; x: IpAddr): IPAddrNodePtr;
    var cur: IPAddrNodePtr;
    BEGIN
      cur := l^.next;
      l^.addr := x;
      
      while ((cur <> l) AND (NOT IsEqual(cur^.addr, x))) do
        cur := cur^.next;
        
      if cur = l then
        FindNode := NIL
      else
        FindNode := cur;
      
    END;

  PROCEDURE InitList(var l: IpAddrList);
    BEGIN
      New(l);
      l^.prev := l;
      l^.next := l;
      ReadIP('0.0.0.0', l^.addr);
      l^.count := 0;
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
      Write(ip[1], '.', ip[2], '.', ip[3], '.', ip[4]);
    END;

  FUNCTION IsSorted(l: IpAddrList): boolean;
    var cur : IPAddrNodePtr;
    BEGIN
      cur := l^.next;
      while (cur <> l) AND (IsSmaller(cur^.prev^.addr, cur^.addr)) do
        cur := cur^.next;
      
      IsSorted := cur <> l;
    END;

  PROCEDURE InsertSorted(var l: IpAddrList; n: IPAddrNodePtr);
    var succ: IPAddrNodePtr;
    BEGIN
      succ := l^.next;
      l^.addr := n^.addr;
      
      while IsSmaller(succ^.addr, n^.addr) do
        succ := succ^.next;

      n^.next := succ;
      n^.prev := succ^.prev;
      succ^.prev := n;
      n^.prev^.next := n;
    END;

  FUNCTION NewNode(x: IpAddr): IPAddrNodePtr;
    var n: IPAddrNodePtr;
    BEGIN
      New(n);
      n^.prev := NIL;
      n^.addr := x;
      n^.count := 1;
      n^.next := NIL;
      NewNode := n;
    END;
  
  PROCEDURE NewAccess(var l: IPAddrList; x: IpAddr);
    var node: IPAddrNodePtr;
    BEGIN
      node := FindNode(l, x);

      if node = NIL then
        InsertSorted(l, NewNode(x))
      else
        Inc(node^.count);
    END;

  PROCEDURE WriteNode(n: IPAddrNodePtr);
    BEGIN
      Write('IP: ');
      WriteIP(n^.addr);
      WriteLn(' Count: ', n^.count);
    END;
  PROCEDURE WriteList(l: IPAddrList);
    var cur: IPAddrNodePtr;
    BEGIN
      cur := l^.next;

      while cur <> l do begin
        Write('->');
        WriteIp(cur^.addr);
        Write(', ', cur^.count, ' Times');
        cur := cur^.next;
      end;
      Write('-|');
    END;
BEGIN
END.