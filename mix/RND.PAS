Program RND;
Uses CrtStuff,zokstuff;
Begin
  SetupCrt;
  While not EnterPressed do
    ColorXY( Random(80) + 1, Random(25) + 1, Random(15)+1, Char(Random(256)));
  RestCursor;
End.