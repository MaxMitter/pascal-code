(* WordCountHashProbing:                              Max Mitter, 2020-03-13 *)
(* ------                                                                    *)
(* A Program that counts how often a word is contained in a certain text using Hash-Probing *)
(* ========================================================================= *)
PROGRAM WordCountHashProbing;

  USES WinCrt, Timer, WordReader, HashProbing;

  var w: Word;
      n: longint;
      table: HashTable;
      c: NodePtr;

BEGIN (* WordCountHashProbing *)

  WriteLn('Starting Wordcounter with Hash Probing...');
  OpenFile('Kafka.txt', toLower);
  StartTimer;
  n := 0;
  ReadWord(w);
  InitHashTable(table);
  while w <> '' do begin
    n := n + 1;
    (* INSERT *)
    Insert(table, w);
    ReadWord(w);
  end;

  StopTimer;
  CloseFile;
  WriteLn('Ending Wordcounter with Hash Probing.');
  WriteLn('Number of words read: ', n);
  WriteLn('Elapsed Time: ', ElapsedTime);
  c := GetHighestCount(table);
  WriteLn('Most Common Word: ', c^.val, ', ', c^.count, ' times.');
END. (* WordCountHashProbing *)