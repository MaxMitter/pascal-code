(* ShapeUnit:                                                 MM, 2020-06-03 *)
(* ------                                                                    *)
(* Unit for simple geometric shapes                                          *)
(* ========================================================================= *)

UNIT ShapeUnit;

INTERFACE

  USES WinGraph, Windows;

  TYPE
    Shape = ^ShapeObj;
    ShapeObj = OBJECT
      PUBLIC
        CONSTRUCTOR Init;
        DESTRUCTOR Done; VIRTUAL;

        PROCEDURE Describe(name: STRING; indent: INTEGER);
        PROCEDURE Draw(dc: HDC); VIRTUAL;
        PROCEDURE Erase(dc: HDC); VIRTUAL;
        PROCEDURE MoveBy(dc: HDC; dx, dy: INTEGER); VIRTUAL;
      PRIVATE
        visible: BOOLEAN;
      END; (* ShapeObj *)

    Line = ^LineObj;
    LineObj = OBJECT(ShapeObj)
      PUBLIC
        CONSTRUCTOR Init(x1, y1, x2, y2: INTEGER);
        DESTRUCTOR Done; VIRTUAL;

        PROCEDURE Describe(name: STRING; indent: INTEGER);
        PROCEDURE Draw(dc: HDC); VIRTUAL;
        PROCEDURE Erase(dc: HDC); VIRTUAL;
        PROCEDURE MoveBy(dc: HDC; dx, dy: INTEGER); VIRTUAL;
      PRIVATE
        x1, y1, x2, y2: INTEGER;
      END; (* LineObj *)

IMPLEMENTATION

  CONSTRUCTOR ShapeObj.Init;
    BEGIN (* ShapeObj.Init *)
      visible := FALSE;
  END;(* ShapeObj.Init *)

  DESTRUCTOR ShapeObj.Done;
    BEGIN (* ShapeObj.Done *)
  END;(* ShapeObj.Done *)

  PROCEDURE ShapeObj.Describe(name: STRING; indent: INTEGER);
    BEGIN (* ShapeObj.Describe *)
      Write('':indent, '''', name, ': ');
      IF (visible) THEN BEGIN
        Write('visible   ');
      END ELSE BEGIN
        Write('invisible ');    
      END; (* IF *)
  END; (* ShapeObj.Describe *)

  PROCEDURE ShapeObj.Draw(dc: HDC);
    BEGIN (* ShapeObj.Draw *)
      visible := TRUE;
  END; (* ShapeObj.Draw *)

  PROCEDURE ShapeObj.Erase(dc: HDC);
    BEGIN (* ShapeObj.Erase *)
      visible := FALSE;
  END; (* ShapeObj.Erase *)

  PROCEDURE ShapeObj.MoveBy(dc: HDC; dx, dy: INTEGER);
    BEGIN (* ShapeObj.MoveBy *)
      WriteLn('ERROR: ShapeObj.MoveBy is abstract.'); HALT;
  END; (* ShapeObj.MoveBy *)

  (* ------ LineObj Methods ------------------------------------- *)

  CONSTRUCTOR LineObj.Init(x1, y1, x2, y2: INTEGER);
    BEGIN (* LineObj.Init *)
      INHERITED Init;
      SELF.x1 := x1;
      SELF.y1 := y1;
      SELF.x2 := x2;
      SELF.y2 := y2;
  END;(* LineObj.Init *)

  DESTRUCTOR LineObj.Done;
    BEGIN (* LineObj.Done *)
  END;(* LineObj.Done *)

  PROCEDURE LineObj.Describe(name: STRING; indent: INTEGER);
    BEGIN (* LineObj.Describe *)
      INHERITED Describe(name, indent);
      WriteLn('Line from (', x1, ', ', y1, ') to (', x2, ', ', y2, ')');
  END; (* LineObj.Describe *)

  PROCEDURE LineObj.Draw(dc: HDC);
    BEGIN (* LineObj.Draw *)
      MoveTo(dc, x1, y1);
      LineTo(dc, x2, y2);
      INHERITED Draw(dc);
  END; (* LineObj.Draw *)

  PROCEDURE LineObj.Erase(dc: HDC);
    BEGIN (* LineObj.Erase *)
      IF (visible) THEN BEGIN
        INHERITED Erase(dc);
        SelectObject(dc, GetStockObject(WHITE_PEN));
        MoveTo(dc, x1, y1);
        LineTo(dc, x2, y2);
        SelectObject(dc, GetStockObject(BLACK_PEN));
      END; (* IF *)
  END; (* LineObj.Erase *)

  PROCEDURE LineObj.MoveBy(dc: HDC; dx, dy: INTEGER);
    VAR vis: BOOLEAN;
    BEGIN (* LineObj.MoveBy *)
      vis := SELF.visible;

      IF (vis) THEN BEGIN
        Erase(dc);
      END;

      x1 := x1 + dx;
      y1 := y1 + dy;
      x2 := x2 + dx;
      y2 := y2 + dy;

      IF (vis) THEN BEGIN
        Draw(dc);
      END;
  END; (* LineObj.MoveBy *)
  
END. (* ShapeUnit *)