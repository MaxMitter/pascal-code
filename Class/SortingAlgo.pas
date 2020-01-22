PROGRAM Sorting;

  var numComp, numAssign: longint;

  type IntArray = array [1..100] of integer;

  FUNCTION LT(a, b: integer): boolean;
    BEGIN (* LT *)
      Inc(numComp);
      LT := a < b;
    END; (* LT *)

  PROCEDURE Swap(var a, b: integer);
    var x: integer;
    BEGIN (* Swap *)
      x := a;
      a := b; 
      b := x;
      Inc(numAssign, 3);
    END; (* Swap *)

PROCEDURE MergeSort(var arr: IntArray; lft, rgt: integer);
  var i, j, k: integer;
      m: IntArray;
  BEGIN (* MergeSort *)
    if lft < rgt then begin
      i := lft;
      j := lft + (rgt - lft) DIV 2;

      for i := lft to rgt do begin
        m[i] := arr[i];
      end; (* FOR *)

      MergeSort(m, lft, (rgt - lft)DIV 2 + lft - 1);
      MergeSort(m, (rgt - lft)DIV 2 + lft, rgt);

      i := lft;
      j := lft + (rgt - lft)Div 2;
      k := lft;
      while k <= rgt do begin
        if (j > rgt) OR LT(m[i], m[j]) then begin
          if LT(m[i], m[j]) then begin
            arr[k] := m[i];
            Inc(i);
            Inc(numAssign);
          end else begin
            arr[k] := m[j];
            Inc(j);
            Inc(numAssign);
          end; (* IF *)
        end; (* IF *)
        Inc(k);
      end; (* WHILE *)
    end; (* IF *)
  END; (* MergeSort *)

PROCEDURE CombSort(var arr: IntArray; lft, rgt: integer);
  var h, i: integer;
      isChanged: boolean;
  BEGIN (* CombSort *)
    h := (rgt - lft) DIV 2;

    while h > 0 do begin
      isChanged := TRUE;
      while isChanged do begin
        isChanged := FALSE;
        for i := lft to rgt - h do begin
          if LT(arr[i + h], arr[i]) then begin
            Swap(arr[i], arr[i + h]);
            isChanged := TRUE;
          end; (* IF *)
        end; (* FOR *)
      end; (* WHILE *)
      h := h * 10 DIV 13;
    end; (* WHILE *)
  END; (* CombSort *)

PROCEDURE SelectionSort(VAR arr: IntArray; lft, rgt: integer);
    var i, j: integer;
        minIndex: integer;
    BEGIN (* SelectionSort *)
      for i := lft to rgt - 1 do begin
        minIndex := i;
        for j := i + 1 to rgt do begin
          if LT(arr[j], arr[minIndex]) then
            minIndex := j;
        end; (* FOR *)

        if (i <> minIndex) then
          Swap(arr[i], arr[minIndex]);
      end; (* FOR *)
    END; (* SelectionSort *)

PROCEDURE ShellSort(var arr: IntArray; lft, rgt: integer);
  var i, j, h, t: integer;
  BEGIN (* ShellSort *)
    h := (rgt - lft) DIV 2;
    while h > 0 do begin
      for i := lft + h to rgt do begin
        t := arr[i]; Inc(numAssign);
        j := i - h;

        while (j >= lft) AND LT(t, arr[j]) do begin
          arr[j + h] := arr[j];
          j := j - h; Inc(numAssign);
        end; (* while *)
        arr[j + h] := t;
      end; (* for *)
      h := h DIV 2;
    end; (* while *)
  END; (* ShellSort *)

PROCEDURE QuickSort(var arr: IntArray; lft, rgt: integer);
  var p, i, j: integer;
  BEGIN (* QuickSort *)
    if lft < rgt then begin
      p := arr[lft+(rgt-lft+1) DIV 2];
      i := lft;
      j := rgt;
      repeat
        while LT(arr[i], p) do Inc(i);

        while LT(p, arr[j]) do Dec(j);

        if i <= j then begin
          if i <> j then
            Swap(arr[i], arr[j]);
          Inc(i);
          Dec(j);
        end; (* IF *)
      until j < i;

      QuickSort(arr, lft, j);
      QuickSort(arr, i, rgt);
    end; (* IF *)
  END; (* QuickSort *)

PROCEDURE BubbleSort(VAR arr: IntArray; left, right: INTEGER);
  VAR i: INTEGER;
    isChanged: BOOLEAN;
  BEGIN (* BubbleSort *)
    isChanged := TRUE;
    WHILE isChanged DO BEGIN
      isChanged := FALSE;
      FOR i := left TO right - 1 DO
        IF LT(arr[i+1], arr[i]) THEN BEGIN
          Swap(arr[i], arr[i+1]);
          isCHanged := TRUE;
        END; (* IF *)
    END; (* WHILE *)
  END; (* BubbleSort *)

PROCEDURE InsertionSort(VAR arr: IntArray; left, right: INTEGER);
  VAR i, j, t: INTEGER;
  BEGIN (* InsertionSort *)
    FOR i := left + 1 TO right DO BEGIN
      t := arr[i];
      Inc(numAssign);
      j := i - 1;
      WHILE (j >= left) AND (LT(t, arr[j])) DO BEGIN
        arr[j+1] := arr[j];
        Inc(numAssign);
        Dec(j);
      END; (* WHILE *)
      IF(j + 1) <> i THEN BEGIN
        arr[j+1] := t;
        Inc(numAssign);
      END; (* IF *)
    END; (* FOR *)
  END; (* InsertionSort *)

var arr: IntArray;
    i, j: integer;

BEGIN (* Sorting *)
  numAssign := 0;
  numComp := 0;

  for i := 1 to 100 do begin
    arr[i] := Random(100);
  end;

  for j := 1 to 100 do begin
    Write(arr[j], ', ');
  end;
  WriteLn();
  MergeSort(arr, 1, 100);

  for j := 1 to 100 do begin
    Write(arr[j], ', ');
  end;

  WriteLn();
  WriteLn(numComp);
  WriteLn(numAssign);
END. (* Sorting *)