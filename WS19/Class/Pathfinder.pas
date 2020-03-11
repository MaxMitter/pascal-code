PROGRAM PathFinder;

  FUNCTION W(m, n: integer): integer;
  BEGIN (* W *)
    if (n = 1) OR (m = 1) then
      W := m + n
    else
      W := W(m - 1, n) + W(m, n - 1);
  END; (* W *)

  const MAX = 100;

  TYPE StackRecord = RECORD
                      n, m: integer;
                      w: longint;
                      s: integer;
                    END;
      Stack = array [1..MAX] of StackRecord;
  
  var s: Stack;
      top: integer;

  PROCEDURE InitStack;
  BEGIN (* InitStack *)
    top := 0;
  END; (* InitStack *)

  PROCEDURE Push(state: integer; n, m: integer; w: longint);
  BEGIN (* Push *)
    Inc(top);
    if top > max then Halt;

    s[top].s := state;
    s[top].m := m;
    s[top].n := n;
    s[top].w := w;
  END; (* Push *)

  PROCEDURE Pop(var state, m, n: integer; var w: longint);
  BEGIN (* Pop *)
    if top = 0 then Halt;

    state := s[top].s;
    m := s[top].m;
    n := s[top].n;
    w := s[top].w;
    Dec(top);
  END; (* Pop *)

BEGIN (* PathFinder *)
  WriteLn(w(2,3));
  WriteLn(w(2,2));

END. (* PathFinder *)