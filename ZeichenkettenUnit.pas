UNIT ZeichenkettenUnit;

INTERFACE

type CharNodePtr = ^CharNode;
     CharNode = record
                ch: char;
                next: CharNodePtr;
                end;
     CharListPtr = CharNodePtr;

  FUNCTION NewCharList: CharListPtr;
  (* returns empty CharList *)

  PROCEDURE DisposeCharList(var cl: CharListPtr);
  (* disposes all nodes and sets cl to empty CharList *)

  FUNCTION CLLength(cl: CharListPtr): integer;
  (* returns the number of characters in cl *)

  FUNCTION CLConcat(cl1, cl2: CharListPtr): CharListPtr;
  (* returns concatenation of cl1 and cl2 by copying the nodes of both lists *)

  FUNCTION CharListOf(s: string): CharListPtr;
  (* returns CharList representation of STRING *)

  FUNCTION StringOf(cl: CharListPtr): string;
  (* returns STRING representation of CharList, may result in truncatation *)

IMPLEMENTATION

  FUNCTION NewCharList: CharListPtr;
    var node: CharListPtr;
  BEGIN
    New(node);
    node := NIL;
    NewCharList := node;
  END;

  FUNCTION NewNode(x: Char): CharNodePtr;
    var node: CharNodePtr;
  BEGIN
    New(node);
    node^.ch := x;
    node^.next := NIL;
    NewNode := node;
  END;

  PROCEDURE DisposeCharList(var cl: CharListPtr);
    var next: CharListPtr;
  BEGIN
    while cl <> NIL do begin
      next := cl^.next;
      Dispose(cl);
      cl := next;
    end; (* WHILE *)
  END;

  FUNCTION CLLength(cl: CharListPtr): integer;
    var count: longint;
  BEGIN
    count := 0;
    while cl <> NIL do begin
      Inc(count);
      cl := cl^.next;
    end; (* WHILE *)
    CLLength := count;
  END;

  FUNCTION CopyNode(n: CharNodePtr): CharNodePtr;
    var node: CharNodePtr;
  BEGIN
    node := NewNode(n^.ch);
    node^.next := n^.next;
    CopyNode := node;
  END;

  FUNCTION CopyCharList(cl: CharListPtr): CharListPtr;
    var newCl: CharListPtr;
        currentNode, prevNode: CharNodePtr;
  BEGIN
    newCl := NewCharList;
    currentNode := CopyNode(cl);
    newCl := currentNode;

    while currentNode^.next <> NIL do begin
      prevNode := currentNode;
      currentNode := CopyNode(currentNode^.next);
      prevNode^.next := currentNode;
    end; (* WHILE *)

    CopyCharList := newCl;
  END;

  FUNCTION CLConcat(cl1, cl2: CharListPtr): CharListPtr;
    var cl1New, cl2New, cl3: CharListPtr;
        next: CharNodePtr;
  BEGIN
    cl1New := CopyCharList(cl1);
    cl2New := CopyCharList(cl2);
    cl3 := cl1New;

    next := cl3;
    while next^.next <> NIL do
      next := next^.next;

    next^.next := cl2New;

    CLConcat := cl3;
  END;

  FUNCTION CharListOf(s: string): CharListPtr;
    var list: CharListPtr;
        node, currNode: CharNodePtr;
        i: integer;
  BEGIN
    list := NewCharList;
    for i := 1 to Length(s) do begin
      node := NewNode(s[i]);
      if i = 1 then begin
        list := node;
        currNode := node;
      end else begin
        currNode^.next := node;
        currNode := node;
      end; (* IF *)
    end; (* FOR *)

    CharListOf := list;
  END;

  FUNCTION StringOf(cl: CharListPtr): string;
    var s: string;
        node: CharNodePtr;
  BEGIN
    s := '';
    node := cl;
    
    while node <> NIL do begin
      s := s + node^.ch;
      node := node^.next;
    end; (* WHILE *)

    StringOf := s;
  END;

BEGIN

END.