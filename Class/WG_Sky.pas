(* WG_Sky: MM 2020 
  Sky test to evaluate quality of RNG *)
PROGRAM WG_Sky;

  USES
  {$IFDEF FPC}
    Windows,
  {$ELSE}
    WinTypes, WinProcs,
  {$ENDIF}
    Strings, WinCrt,
    WinGraph,
    RandUnit;

  PROCEDURE Skytest(dc: HDC; wnd: HWnd; r: TRect); FAR;
    CONST
      BORDER = 20; (* Padding in pixel *)
    VAR
      x, y, n, i: INTEGER;
      width, height: INTEGER;
  BEGIN
    Randomize;
    width := r.right - r.left - 2 * BORDER;
    height := r.bottom - r.top - 2 * BORDER;

    InitRandSeed(0);
    n := 5000;

    FOR i := 1 to n do begin
      x := Random(width) + BORDER;
      y := Random(height) + BORDER;
      MoveTo(dc, x-2, y);
      LineTo(dc, x+3, y);

      MoveTo(dc, x, y - 2);
      LineTo(dc, x, y + 3);
    end; (* FOR *)
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
  redrawProc := Skytest;
  mousePressedProc := MousePressed_Example;
  WGMain;
END. (*WG_Test*)
