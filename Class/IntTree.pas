PROGRAM IntTree;
USES IntTreeUnit;

var t: Tree;
BEGIN (* IntTree *)

  t := TreeOf(21, NewNode(4), NewNode(17));
  WriteTreePreOrder(t);
  Delete(t, 21);
  WriteTreePreOrder(t);
END. (* IntTree *)