{
  Questions v1.0

    This program will demonstrate a binary tree by asking the
   user yes or no questions concerning the properties of a certain
   object. The computer starts at the root of the tree and works its
   way down, traveling either left or right along the tree according
   to the user's responses.

    This program will also serve to demonstrate Turbo Pascal's Turbo
   Vision Package, which includes such things as mouse support, a
   fully integrated menu, and other neat stuff that I probably won't
   remember until later.

}

Program Questions;
Uses Crt, App, Menus, Views;

Type
 QApp = object ( TApplication )
  Procedure InitMenuBar; Virtual;
 end;

Procedure QApp.InitMenuBar;
 begin
  TApplication.InitMenuBar;
 end;

Var Q : QApp;

Begin
 Q.Init;
 Q.Run;
 Q.Done;
End.