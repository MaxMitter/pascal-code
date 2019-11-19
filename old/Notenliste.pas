PROGRAM Notenliste;

  TYPE Uebung = RECORD
                  punkte: real;
                  abgegeben: boolean;
  END; (* Uebung *)

  UebungenArray = ARRAY [1..10] OF Uebung;
  Student = RECORD
                Name: string;
                Uebungen: UebungenArray;
                END;
  StudentArray = ARRAY [1..25] OF Student;

  VAR
    s: StudentArray;

PROCEDURE AddResult(name: string; punkte: real; ue: integer); FORWARD;

PROCEDURE InitStudentArray;
  VAR i, j: integer;
BEGIN (* InitStudentArray *)
  FOR i:= Low(s) TO High(s) DO BEGIN
    s[i].Name := '';
    FOR j := Low(s[i].Uebungen) TO High(s[i].Uebungen) DO BEGIN
      s[i].Uebungen[j].punkte := 0.0;
      s[i].Uebungen[j].abgegeben := false;
    END; (* FOR *)
  END;
END; (* InitStudentArray *)

FUNCTION FindStudentIndexWithName(name: string): integer;
  VAR i: integer;
BEGIN (* FindStudentIndexWithName *)
  i:= 1;
  WHILE ((i <= High(s)) AND (s[i].name <> name) AND (s[i].name <> '')) DO
    Inc(i);
  IF i > High(s) THEN BEGIN
    WriteLn('Too many students!');
    HALT;
  END; (* IF *)
  s[i].name := name;
  FindStudentIndexWithName:= i;
END; (* FindStudentIndexWithName *)

PROCEDURE AddEntry(name: string; ue: integer);

  var idx: integer;

BEGIN (* AddEntry *)
  AddResult(name, -1, ue);
END; (* AddEntry *)

PROCEDURE AddResult(name: string; punkte: REAL; ue: integer);

  var idx: integer;

BEGIN (* AddResult *)
  idx := FindStudentIndexWithName(name);
  s[idx].Uebungen[ue].abgegeben := TRUE;
  s[idx].Uebungen[ue].punkte := punkte;
END; (* AddResult *)

PROCEDURE FindBestTwo(ue: UebungenArray; var p1, p2: real);
  var i: integer;
      p: real;
BEGIN (* FindBestTwo *)
  p1 := -1;
  p2 := -1;

  FOR i := Low(ue) TO High(ue) DO BEGIN
    p:= ue[i].punkte;
    IF ue[i].abgegeben THEN BEGIN
      IF p > p1 THEN BEGIN
        p2 := p1;
        p1 := p;
      END ELSE IF p > p2 THEN BEGIN
        p2 := p;
      END; (* IF *)
    END; (* IF *)

  END; (* FOR *)
END; (* FindBestTwo *)

FUNCTION AvgPunkte(st: student): real;

  var p1, p2: real;

BEGIN (* AvgPunkte *)
  FindBestTwo(st.uebungen, p1, p2);
  IF p1 < 0 THEN BEGIN
    WriteLn('No result for ', st.name);
    HALT;
  END; (* IF *)

  IF p2 >= 0 THEN BEGIN
    AvgPunkte := (p1 + p2) / 2;
  END ELSE BEGIN
    AvgPunkte := p1;
  END;

END; (* AvgPunkte *)

PROCEDURE WriteStudent(st: student);
  var i: integer;
      anzAbgaben: integer;
BEGIN (* WriteStudent *)
  anzAbgaben := 0;
  Write(st.name:20);
  FOR i := Low(st.uebungen) TO High(st.uebungen) DO BEGIN
    IF st.uebungen[i].abgegeben THEN BEGIN
      Write(i:3, ': ', st.uebungen[i].Punkte:5:1);
      Inc(anzAbgaben);
    END; (* IF *)
  END; (* FOR *)
  WriteLn(' Abgaben: ', anzAbgaben, ' Punkteschnitt: ', AvgPunkte(st):5:1);
END; (* WriteStudent *)

PROCEDURE WritePunkteListe;
  var i: integer;
BEGIN (* WritePunkteListe *)
  i := 1;
  WHILE (i <= High(s)) AND (s[i].name <> '') DO BEGIN
    WriteStudent(s[i]);
    Inc(i);
  END; (* WHILE *)

  WriteLn('Number of Students: ', i - 1);
END; (* WritePunkteListe *)

BEGIN (* Notenliste *)

  AddEntry('Haas', 2);
  AddResult('Haas', 24, 1);
  AddEntry('Haas', 3);

  AddResult('Mitter', 24, 2);
  AddEntry('Mitter', 1);
  AddResult('Mitter', 22, 3);

  AddResult('GK', 5, 1);
  AddResult('GK', 6, 2);
  AddResult('GK', 7, 3);

  AddEntry('Student T', 1);
  AddEntry('Student T', 2);
  AddEntry('Student T', 3);

  WritePunkteListe;
END. (* Notenliste *)