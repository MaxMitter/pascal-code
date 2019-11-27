PROGRAM PointerExample;

TYPE IntPointer = ^integer;

PROCEDURE Swap(var x, y: integer);
  var aux: integer;
BEGIN (* Swap *)
  aux := x;
  x := y;
  y := aux;
END; (* Swap *)

PROCEDURE SwapPtr(x, y: IntPointer);
  var aux: integer;
BEGIN (* SwapPtr *)
  Writeln('x: ', longint(x));
  WriteLn('aux: ', longint(@aux));
  aux := x^;
  x^ := y^;
  y^ := aux;
END; (* SwapPtr *)

var x, y: integer;
    p, q: IntPointer;

BEGIN (* PointerExample *)
  x := 1; y := 2;
  p := @x; q := @y;

  WriteLn('@x: ', longint(@x));
  WriteLn('@y: ', longint(@y));
  WriteLn('@p: ', longint(@p));
  WriteLn('@q: ', longint(@q));

  Swap(x, y);
  WriteLn(x, ', ', y);

  SwapPtr(@x, @y);
  WriteLn(x, ', ', y);

END. (* PointerExample *)