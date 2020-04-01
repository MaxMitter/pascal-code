(* Files:                                                     MM, 2020-04-01 *)
(* ------                                                                    *)
(* Fun with Files                                                            *)
(* ========================================================================= *)

PROGRAM Files;

  TYPE
    MoodType = (happy, sad, angry, bored); 
    Person = RECORD
    name: STRING;
    age: INTEGER;
    mood: MoodType;
  END;

  VAR textfile: TEXT;
      intfile: FILE OF INTEGER;
      personfile: FILE OF Person;
      p: Person;
      s: STRING;
      error: INTEGER;
      i: INTEGER;

BEGIN (* Files *)
////// personfile //////////

  Assign(personfile, 'personfile.dat');
  Rewrite(personfile);
  p.name := 'Max Mustermann';
  p.age := 24;
  p.mood := angry;
  Write(personfile, p);
  Close(personfile);

  Reset(personfile);
  Read(personfile, p);
  WriteLn(p.name, ' - ');
  WriteLn(p.age);
  WriteLn(p.mood);
  WriteLn;


  ////// intfile //////////

  Assign(intfile, 'intfile.dat');
  Rewrite(intfile);

  FOR i := 1 TO 10 DO BEGIN
    Write(intfile, i);
  END; (* FOR *)

  Close(intfile);

  Reset(intfile);

  REPEAT
    Read(intfile, i);
    Write(i, ' - ');
  UNTIL Eof(intfile); (* REPEAT *)

  ////// TextFile /////////
  Assign(textfile, 'testfile.txt');
  //Rewrite(textfile); (* Create File to write *)
  {$I-}
  Reset(textfile); (* Open File to read *)
  error := IOResult;
  IF (error <> 0) THEN BEGIN
    WriteLn('ERROR: Cannot open file.');
    WriteLn('Code: ', IOResult); (* Is reset to 0 with each call *)
    WriteLn('Code: ', error);
    HALT;
  END; (* IF *)
  {$I+}
  REPEAT
    ReadLn(textfile, s);
    WriteLn(s);
  UNTIL Eof(textfile); (* REPEAT *)  (* End of file *)
  

  Close(textfile);
  WriteLn('Done!');

END. (* Files *)