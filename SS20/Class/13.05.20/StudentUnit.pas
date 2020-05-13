UNIT StudentUnit;

INTERFACE

  USES PersonUnit;

    TYPE
    Student = ^StudentObj;
    StudentObj = OBJECT(PersonObj)
      PUBLIC
        CONSTRUCTOR Init(name: STRING);
        CONSTRUCTOR Init2(name: STRING; mood: MoodType);
        DESTRUCTOR Done;
    END; (* PERSON *)

  

IMPLEMENTATION

  FUNCTION MoodTypeToString(mood: MoodType): STRING;
  BEGIN (* MoodTypeToString *)
    CASE (mood) OF
      happy: MoodTypeToString := 'happy';
      excited: MoodTypeToString := 'excited';
      funny: MoodTypeToString := 'funny';
      angry: MoodTypeToString := 'angry';
      tired: MoodTypeToString := 'tired';
    END;
  END; (* MoodTypeToString *)

  CONSTRUCTOR StudentObj.Init(name: STRING);
  BEGIN (* CONSTRUCTOR *)
    self.name := name;
    age := 18;
    mood := happy;
  END; (* CONSTRUCTOR *)

  CONSTRUCTOR StudentObj.Init2(name: STRING; mood: MoodType);
  BEGIN (* CONSTRUCTOR *)
    self.name := name;
    age := 0;
    self.mood := mood;
  END; (* CONSTRUCTOR *)

  DESTRUCTOR StudentObj.Done;
  BEGIN (* DESTRUCTOR *)
  END; (* DESTRUCTOR *)

BEGIN (* PersonUnit *)
  
END. (* PersonUnit *)
