FUNCTION Max(arr: IntArray): integer;
  var i: integer; m: integer;
  BEGIN (* Max *)
    i := 1; m := 1;
    while (i <= k) AND (arr[m] < 3) do begin
      if arr[i] > arr[m] then
        m := i;
      i := i + 1;
    end;
    Max := arr[m];
  END; (* Max *)