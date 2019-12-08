PROGRAM ListTest;
USES SingleLinkedIntListUnit;


var l: List;
    i: longint;
BEGIN (* ListTest *)
  { InitList(l);
  Write('Appending');
  for i := 1 to 100000 do
    Append(l, NewNode(0));
  WriteLn('Done');

  Write('Prepend');
  for i := 1 to 100000 do
    Prepand(l, NewNode(0));
  WriteLn('Done');

  WriteLn('NumNodes: ', NumNodes(l)); }

  InitList(l);
  InsertSorted(l, NewNode(0));
  InsertSorted(l, NewNode(1));
  InsertSorted(l, NewNode(5));
  InsertSorted(l, NewNode(4));
  WriteList(l);
END. (* ListTest *)