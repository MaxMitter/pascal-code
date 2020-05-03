(* SynTreeUnit:                                       Rittberger, 2020-04-25 *)
(* ------                                                                    *)
(* Unit for the Tree Procedures & for Syntax analisys                        *)
(* ========================================================================= *)
UNIT SynTreeUnit;

INTERFACE

  TYPE  
    kanTree = POINTER;

  PROCEDURE NewTree(VAR t: kanTree);
  PROCEDURE DisposeTree(VAR t: kanTree);
  PROCEDURE WriteTree(t: kanTree);
  PROCEDURE S(VAR t: kanTree);
  PROCEDURE WriteT(t: kanTree);

  VAR
    line: STRING;


IMPLEMENTATION

  TYPE
  NodePtr= ^Node;
  Node = RECORD
    firstChild, sibling: NodePtr;
    val: STRING; (* nonterminal, operator or operand as string*)
  END;(*Node*)
  TreePtr= NodePtr;

//Tree actions
  PROCEDURE NewTree(VAR t: kanTree);
    BEGIN (* NewStrMSet *)
      TreePtr(t) := NIL;
  END; (* NewStrMSet *)

  PROCEDURE DisposeTree(VAR t: kanTree); 
    BEGIN (* DisposeStrMSet *)
      IF (TreePtr(t) <> NIL) THEN BEGIN
        DisposeTree(TreePtr(t)^.firstChild);
        DisposeTree(TreePtr(t)^.sibling);
        Dispose(TreePtr(t));
        TreePtr(t) := NIL;
      END; (* IF *)
  END; (* DisposeStrMSet *)

  FUNCTION NewNode(content: STRING): TreePtr;
      VAR
        n: TreePtr;
    BEGIN (* NewNode *)
      New(n);
      n^.val := content;
      n^.firstChild := NIL;
      n^.sibling := NIL;
      NewNode := n;
  END; (* NewNode *)

  PROCEDURE WriteT(t: kanTree);
    BEGIN
      Write(TreePtr(t)^.sibling^.val);
    END;

  PROCEDURE WriteTree(t: kanTree);
    BEGIN (* WriteTree *)
      IF (TreePtr(t) <> NIL) THEN BEGIN
        Write(TreePtr(t)^.val, ' ');
        WriteTree(TreePtr(t)^.firstChild);           
        WriteTree(TreePtr(t)^.sibling);
      END; (* IF *)
  END; (* WriteTree *)
//--end Tree actions

//analysis
  CONST
    EOS = Chr(0);

  TYPE
    SymbolCode = (
                  eosSy, noSy,           //eos .... end of string
                  plusSy, minusSy,
                  timesSy, divSy,       //timesSy = *
                  leftParSy, rightParSy,
                  number);

  VAR
    ch: CHAR;
    cnr: INTEGER;   
    sy: SymbolCode;
    success: BOOLEAN;
    numberVal: STRING;
    
  (* ---- SCANNER ----*)
  PROCEDURE NewCh;
    BEGIN (* NewCh *)
      IF (cnr < Length(line)) THEN BEGIN
        Inc(cnr);
        ch := line[cnr];
      END ELSE BEGIN
        ch := EOS;
      END; (* IF *)
  END; (* NewCh *)

  PROCEDURE NewSy;
    BEGIN (* NewSy *)
      CASE ch OF
        EOS: BEGIN 
          sy := eosSy;
        END;

        '+': BEGIN
          sy := plusSy;
          NewCh;
        END;

        '-': BEGIN
          sy := minusSy;
          NewCh;
        END;

        '*': BEGIN
          sy := timesSy;
          NewCh;
        END;

        '/': BEGIN
          sy := divSy;
          NewCh;
        END;

        '(': BEGIN
          sy := leftParSy;
          NewCh;
        END;

        ')': BEGIN
          sy := rightParSy;
          NewCh;
        END;

        '0'..'9': BEGIN
          sy := number;
          numberVal := ch;
          NewCh;
          WHILE ((ch >= '0') AND ( ch <= '9')) DO BEGIN
            numberVal := numberVal + ch;
            NewCh;
          END; (* WHILE *)
          //Write(numberVal, ' ');
        END;
        
      ELSE
        sy := noSy;       //hängt davon ab was ich danach mache
      END; (* CASE *)
  END; (* NewSy *)

  (* ---- Parser ----*)
  //forward declaration
  PROCEDURE Expr(VAR t: TreePtr); FORWARD;
  PROCEDURE Term(VAR i: TreePtr); FORWARD;
  PROCEDURE Fact(VAR f: TreePtr); FORWARD;

  PROCEDURE S(VAR t: kanTree);
    BEGIN (* S *)
      NewCh;
      NewSy;
      t := NewNode('Expr');
      Expr(TreePtr(t)); 
      IF NOT success THEN Exit;
      IF sy <> eosSy THEN BEGIN 
        success := FALSE; 
        Write(success);
        Exit; 
      END;
  END; (* S *)

  PROCEDURE Expr(VAR t: TreePtr);
      VAR
        i: TreePtr;
    BEGIN (* Expr *) 
      i := t;
      i^.firstChild := NewNode('Term');     
      Term(i^.firstChild); 
      IF NOT success THEN Exit;
      WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
        CASE sy OF
          plusSy: BEGIN 
             //sem
              t := t^.firstChild^.sibling;
              t := NewNode('+');
              Write('#', t^.val);
              t := t^.sibling;
            //--end sem 
            NewSy;
            t := NewNode('Term');
            Term(t); IF NOT success THEN Exit;                     
          END;

          minusSy: BEGIN 
            //sem
              t := t^.firstChild^.sibling;
              t := NewNode('-');
              t := t^.sibling;
            //--end sem 
            NewSy; 
            t := NewNode('Term');
            Term(t); IF NOT success THEN Exit;   
          END;                
        END; (*CASE*)    
      END; (*WHILE*)
  END; (* Expr *)
  
  PROCEDURE Term(VAR i: TreePtr);
      VAR
        e: TreePtr;
    BEGIN (* Term *)
      e := i;
      e^.firstChild := NewNode('Fact');
      Fact(e^.firstChild); 
      IF NOT success THEN Exit;
      WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN  
        CASE sy OF 
          timesSy: BEGIN
            //sem
              i := i^.sibling;
              i := NewNode('*');
              i := i^.sibling;
              i := NewNode('Term');
            //--end sem 
            NewSy;
            i^.firstChild := NewNode('Fact');
            Fact(i); IF NOT success THEN Exit;  
          END; 

          divSy: BEGIN 
            //sem
              i := i^.sibling;
              i := NewNode('/');
              i := i^.sibling;
            //--end sem 
            NewSy;
            i^.firstChild := NewNode('Fact');
            Fact(i); IF NOT success THEN Exit;               
          END;      
        END; (*CASE*)    
      END; (*WHILE*)
  END; (* Term *)

  PROCEDURE Fact(VAR f: TreePtr);
    BEGIN (* Fact *)
      CASE sy OF
        number: BEGIN
          //NewSy;
          //sem
            f^.firstChild := NewNode(numberVal);
            numberVal := '';
          //--end sem 
          NewSy;
        END; 

        leftParSy: BEGIN
          NewSy;
          f := NewNode('Expr');
          Expr(f); 
          IF NOT success THEN Exit;
          IF sy <> rightParSy THEN BEGIN success := FALSE; 
            Exit; 
          END; 
          NewSy;
        END; 

        ELSE BEGIN
          success := FALSE;
        END;
      END; (*CASE*)    
  END; (* Fact *)
//--end analysis

BEGIN (* SynTreeUnit *) 
  
END. (* SynTreeUnit *)
