PROGRAM WishListAnalyzer;
  USES WishListUnit;

  var wl: WishList;

  PROCEDURE AddPresentToList(s: string);
    var childName, present: string;
    BEGIN (* AddPresentToList *)
      childName := s;
      Delete(childName, Pos(':', childName), Length(s) - Pos(':', childName) + 1);
      present := s;
      Delete(present, 1, Pos(' ', present));

      AddPresent(wl, childName, present);
    END; (* AddPresentToList *)

  var s: string;
BEGIN (* WishListAnalyzer *)
  NewWishList(wl);
  ReadLn(s);

  while s <> '' do begin
    AddPresentToList(s);
    ReadLn(s);
  end; (* WHILE *)

  WriteWishList(wl);
END. (* WishListAnalyzer *)