 uses vuestuff,crtstuff,filstuff;

 var
  notepad : listviewer;
  temp : screentype;
  s : string;
  f : text;
 begin
  repeat
  temp := screen;
  cwrite('|]|)');
  tymin := 1;
    with notepad do
     begin
      init;
      x1 := 20;
      y1 :=  4;
      x2 := 75;
      y2 := 20;
      tcolorinit := $1e;
     end;
    assign( f, 'C:\extras\notes.txt' );
    if not fileexists('C:\EXTRAS\NOTES.TXT') then
     begin
      notepad.append( new( pstringobj, init( '|b|RNothing in notepad file...') ));
      exit;
     end;
    reset( f );
    while not eof( f ) do
     begin
     readln( f, s );
     notepad.append( new( pstringobj, init( '|b|Y'+s ) ));
    end;
  close(f);
  with notepad do begin
   bar( x1-1, y1-1, x2+1, y2+1, $4F );
   greyshadow( x1-1, y1-1, x2+1, y2+1 );
   ccenterxy( (x1+x2) div 2+1, y1-1, '|W|!b[ |YNotepad|W ]');
   view;
  end;
  screen := temp;
  tymin := 2;
  cwrite('|[|(');
  notepad.done;
  until false;
 end.
