program Pablo2;
uses crt, crtstuff, zokstuff,filstuff;

{$I LINES.PAS}

var
 f : file;
 a, b, c, d, col : byte;
 filename : string;
 inp : zinputbox;

begin
 setupcrt;
 inp.init( 5, 5, 'You want to edit|w, |WMan|w?', '|WF|Gi|WL|Ge|Y> ', 12 );
 filename := inp.get;
 if
  fileexists( filename )
 then
  begin
   clrscr;
   filereset( f, filename );
   while not eof( f ) do
    begin
     a := nextbyte( f );
     b := nextbyte( f );
     c := nextbyte( f );
     d := nextbyte( f );
     col := nextbyte( f );
     drawline( a, b, c, d, col );
    end;
  end;
 getenter;
 doscursoron;
end.