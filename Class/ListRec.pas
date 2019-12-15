PROGRAM ListRec;

  TYPE ListNodePtr = ^ListNode;
     ListNode = RECORD
                val: integer;
                next: ListNodePtr;
                END;
     List = ListNodePtr;

  PROCEDURE AppendRec(var l: List; n: ListNodePtr);
  BEGIN (* AppendRec *)
    if l = NIL then
      l := n
    else
      AppendRec(l^.next, n);
  END; (* AppendRec *)

BEGIN (* ListRec *)
  
END. (* ListRec *)