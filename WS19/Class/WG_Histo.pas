(* WG_Histo: MM 2020 
  Histo test to evaluate quality of RNG *)
PROGRAM WG_Histo;

  USES
  {$IFDEF FPC}
    Windows,
  {$ELSE}
    WinTypes, WinProcs,
  {$ENDIF}
    Strings, WinCrt,
    WinGraph,
    RandUnit;

  PROCEDURE HistoTest(dc: HDC; wnd: HWnd; r: TRect); FAR;
    CONST
      BORDER = 20; (* Padding in pixel *)
      SIZE = 5;
      MAX = 1000;
    VAR
      h: array[0..MAX] of integer;
      x, y, n, i, randVal: INTEGER;
      width, height: INTEGER;
      diffValues, maxPerVal: integer;
  BEGIN
    Randomize;
    width := r.right - r.left - 2 * BORDER;
    height := r.bottom - r.top - 2 * BORDER;

    diffValues := width DIV SIZE;
    maxPerVal := height DIV SIZE;

    for i := 0 to diffValues do begin
      h[i] := 0;
    end; (* FOR *)

    InitRandSeed(0);
    
    i := 1;
    n := diffValues * maxPerVal;

    while i <= n do begin
      randVal := Random(diffValues);
      Inc(h[randVal]);

      x := BORDER + randVal * SIZE;
      y := BORDER + height - h[randVal] * SIZE;

      Ellipse(dc, x, y, x + SIZE, y + SIZE);

      if h[randVal] >= maxPerVal then Exit;
      Inc(i);
    end; (* WHILE *)
  END; (*Redraw_Example*)

  PROCEDURE Redraw_Example2(dc: HDC; wnd: HWnd; r: TRect); FAR;
  BEGIN
    (*... draw anything ...*)
  END; (*Redraw_Example2*)

  PROCEDURE MousePressed_Example(dc: HDC; wnd: HWnd; x, y: INTEGER); FAR;
  BEGIN
    WriteLn('mouse pressed at: ', x, ', ', y);
    (*InvalidateRect(wnd, NIL, TRUE);*)
  END; (*MousePressed_Exmple*)

BEGIN (*WG_Test*)
  redrawProc := HistoTest;
  mousePressedProc := MousePressed_Example;
  WGMain;
END. (*WG_Test*)
