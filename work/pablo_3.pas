program Pablo3;
uses crt, crtstuff, zokstuff,filstuff;

{$I LINES.PAS}

var
 f,f2 : file;
 a, b, c, d, col : byte;
 filename : string;
 inp : zinputbox;

begin
 setupcrt;
 inp.init( 5, 5, 'You wanna edit somethin|w, |WMon|w?', '    |WF|Gi|WL|Ge|Y> ', 8 );
 filename := inp.get + '.wok';
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
   getenter;
  end;
 doscursoron;
end.