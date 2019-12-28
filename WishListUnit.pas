UNIT WishListUnit;

INTERFACE

  TYPE
    WishNodePtr = ^WishNode;
    PersonNodePtr = ^PersonNode;

    WishNode = record
      prev, next: WishNodePtr;
      wish: string;
      n: integer; (*number of occurences of the wish*)
      children: PersonNodePtr;
      end; (*RECORD*)
      
    PersonNode = record
      next: PersonNodePtr;
      childName: string;
      end; (* RECORD *)
    WishList = WishNodePtr;
    PersonList = PersonNodePtr;

  PROCEDURE AddPresent(var wl: WishList; childName: string; present: string);
  PROCEDURE WriteWishList(wl: WishList);
  PROCEDURE NewWishList(var wl: WishList);

IMPLEMENTATION

  PROCEDURE WritePersonList(pl: PersonList);
    BEGIN (* WritePersonList *)
      while pl <> NIL do begin
        Write(pl^.childName, ' ');
        pl := pl^.next;
      end;
    END; (* WritePersonList *)

  PROCEDURE WriteWishList(wl: WishList);
    var cur: WishNodePtr;
    BEGIN
      wl^.wish := '';
      cur := wl^.next;
      while cur^.wish <> '' do begin
        Write(cur^.n, '*', cur^.wish, ': ');
        WritePersonList(cur^.children);
        WriteLn();
        cur := cur^.next;
      end; (* WHILE *)
    END;

  PROCEDURE NewWishList(var wl: WishList);
    BEGIN (* NewWishList *)
      New(wl);
      wl^.wish := '';
      wl^.n := 0;
      wl^.children := NIL;
      wl^.next := wl;
      wl^.prev := wl;
    END; (* NewWishList *)
  FUNCTION FindWishNode(l: WishList; present: string): WishNodePtr;
    var node: WishNodePtr;
    BEGIN (* FindWishNode *)
      node := l^.next;
      l^.wish := present;
    if node <> NIL then begin
      while node^.wish <> present do
        node := node^.next;

      if node = l then
        FindWishNode := NIL
      else
        FindWishNode := node;
    end else 
      FindWishNode := NIL;
    END; (* FindWishNode *)

  FUNCTION FindChildNode(l: PersonList; childName: string): PersonNodePtr;
    BEGIN (* FindChildNode *)
      while (l <> NIL) AND (l^.childName <> childName) do
        l := l^.next;
      FindChildNode := l;
    END; (* FindChildNode *)

  PROCEDURE AppendPersonList(var l: PersonList; n: PersonNodePtr);
    var cur: PersonNodePtr;
    BEGIN (* AppendPersonList *)
      if l = NIL then
        l := n
      else begin
        cur := l;
        while cur^.next <> nil do
          cur := cur^.next;
        cur^.next := n;
      end;
    END; (* AppendPersonList *)

  PROCEDURE NewPersonNode(var l: PersonList; childName: string);
    var node: PersonNodePtr;
    BEGIN (* NewPersonNode *)
      New(node);
      node^.childName := childName;
      node^.next := NIL;
      AppendPersonList(l, node);
    END; (* NewPersonNode *)

  PROCEDURE AppendWishList(l: WishList; n: WishNodePtr);
    BEGIN (* AppendWishList *)
      n^.prev := l^.prev;
      n^.next := l;
      l^.prev^.next := n;
      l^.prev := n;
    END; (* AppendWishList *)

  PROCEDURE NewWishNode(l: WishList; present: string);
    var node: WishNodePtr;
    BEGIN (* NewWishNode *)
      New(node);
      node^.wish := present;
      node^.n := 1;
      node^.prev := NIL;
      node^.next := NIL;

      AppendWishList(l, node);
    END; (* NewWishNode *)

  PROCEDURE AddPresent(var wl: WishList; childName: string; present: string);
    var presentNode: WishNodePtr;
        childNode: PersonNodePtr;
    BEGIN
      presentNode := FindWishNode(wl, present);

      if presentNode <> NIL then begin
        Inc(presentNode^.n);
        childNode := FindChildNode(presentNode^.children, childName);
        if childNode = NIL then begin
          NewPersonNode(presentNode^.children, childName);
        end; (* IF *)
      end else begin
        NewWishNode(wl, present);
        presentNode := FindWishNode(wl, present);

        if presentNode <> NIL then begin
          childNode := FindChildNode(presentNode^.children, childName);
          if childNode = NIL then begin
            NewPersonNode(presentNode^.children, childName);
          end; (* IF *)
        end; (* IF *)
      end; (* IF *)
    END;

BEGIN (* WishListUnit *)
  
END. (* WishListUnit *)