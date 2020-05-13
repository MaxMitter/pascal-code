UNIT PersonUnit;

INTERFACE

    TYPE
    MoodType = (happy, excited, funny, angry, tired);
    Person = ^PersonObj;
    PersonObj = OBJECT
      name: STRING;
      age: INTEGER;
      mood: MoodType;
      CONSTRUCTOR Init(name: STRING);
      CONSTRUCTOR Init2(name: STRING; mood: MoodType);
      DESTRUCTOR Done;
      PROCEDURE SaySomething;
      FUNCTION ToString: STRING;
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

  CONSTRUCTOR PersonObj.Init(name: STRING);
  BEGIN (* CONSTRUCTOR *)
    self.name := name;
    age := 0;
    mood := excited;
  END; (* CONSTRUCTOR *)

  CONSTRUCTOR PersonObj.Init2(name: STRING; mood: MoodType);
  BEGIN (* CONSTRUCTOR *)
    self.name := name;
    age := 0;
    self.mood := mood;
  END; (* CONSTRUCTOR *)

  DESTRUCTOR PersonObj.Done;
  BEGIN (* DESTRUCTOR *)
  END; (* DESTRUCTOR *)

  PROCEDURE PersonObj.SaySomething;
  BEGIN (* Person.SaySomething *)
    WriteLn('Hello, my name is ', name);
  END; (* Person.SaySomething *)

  FUNCTION PersonObj.ToString: STRING;
  BEGIN (* Person.ToString *)
    ToString := name + '(' + MoodTypeToString(mood) + ')';
  END; (* Person.ToString *)

BEGIN (* PersonUnit *)
  
END. (* PersonUnit *)
