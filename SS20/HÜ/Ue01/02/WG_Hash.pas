(* WG_Hash:                      HDO, 1995-09-11; GHO 2010-05-28, HDO 2011, MM 2020
   -------
   Program to display Hashfunctions using Windows graphics based on unit WinGraph.
==========================================================================*)
PROGRAM WG_Test;
  USES
  {$IFDEF FPC}
    Windows,
  {$ELSE}
    WinTypes, WinProcs,
  {$ENDIF}
    Strings, WinCrt,
    WinGraph, WordReader, HashChaining;

  PROCEDURE DrawHistoCode(dc: HDC; wnd: HWnd; r: TRect);
    CONST
      BORDER = 20;
      SIZE = 5;
      MAX = 211;
    VAR
      h: ARRAY[0..MAX] OF INTEGER;
      x, y, i: INTEGER;
      width, height: INTEGER;
      maxPerVal, val: INTEGER;
      w: WORD;
      t: HashTable;
    BEGIN
      width := r.right - r.left - 2 * BORDER;
      height := r.bottom - r.top - 2 * BORDER;
      maxPerVal := height DIV SIZE;

      for i := 0 to max do
        h[i] := 0;

      OpenFile('Kafka.txt', toLower);
      ReadWord(w);
      InitHashTable(t);
      while (w <> '') do BEGIN
        (*If value x in Contains(t, w, x), Insert(t, w, x) and GetHashCodex(w)
          is changed, different Hashfunctions will be used *)
        IF Contains(t, w, 3) = NIL THEN BEGIN
          val := GetHashCode3(w);
          Inc(h[val]);
          x := BORDER + val * SIZE;
          y := BORDER + height - h[val] * SIZE;

          Ellipse(dc, x, y, x + SIZE, y + SIZE);

          if h[val] >= maxPerVal then Exit;
        END; (* IF *)
        Insert(t, w, 3);
        ReadWord(w);
      end; (* WHILE *)
      CloseFile;
  END; (*DrawHistoCode*)

BEGIN (*WG_Test*)
  redrawProc := DrawHistoCode;
  WGMain;
END. (*WG_Test*)
