(* OOPIntro:                                                  MM, 2020-05-13 *)
(* ------                                                                    *)
(* Introduction to OOP                                                       *)
(* ========================================================================= *)

PROGRAM OOPIntro;

  USES PersonUnit;

  VAR p: Person;

BEGIN (* OOPIntro *)
  New(p, Init('Test'));

  WriteLn(p^.ToString);
  p^.SaySomething;
  Dispose(p);
END. (* OOPIntro *)