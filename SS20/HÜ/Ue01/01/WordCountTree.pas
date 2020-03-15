(* Wordcount:                                         Max Mitter, 2020-03-13 *)
(* ------                                                                    *)
(* A Program that counts how often a word is contained in a certain text using Binary Trees *)
(* ========================================================================= *)
PROGRAM Wordcount;

  USES WinCrt, Timer, WordReader, TreeUnit;

  var w: Word;
    n: longint;
    t: Tree;
    c: NodePtr;

BEGIN (* Wordcount *)
  WriteLn('Starting Wordcounter with Binary Tree...');
  OpenFile('Kafka.txt', toLower);
  StartTimer;
  n := 0;
  ReadWord(w);

  while w <> '' do begin
    n := n + 1;
    (* INSERT *)
    Insert(t, w);
    ReadWord(w);
  end;

  StopTimer;
  CloseFile;
  WriteLn('Ending Wordcounter with Binary Tree.');
  WriteLn('Number of words read: ', n);
  WriteLn('Elapsed Time: ', ElapsedTime);
  c := GetHighestCount(t);
  WriteLn('Most Common Word: ', c^.val, ', ', c^.count, ' times.');
  DisposeTree(t);
END. (* Wordcount *)