Program ZMen;

Uses Zokstuff, CrtStuff,crt,moustuff;

Type
 options = record
  MenuText ,
  Path     ,
  Filename : String;
 end;

Var
 zf : text;
 numentries : byte;
 choice : byte;
 counter : byte;
 data : array[ 1 .. 20 ] of options;
 menu : zmenu;


Begin
 fillscreen( bluebox );
 doscursoroff;
 txpos := 1;
 typos := 1;
 numentries := 0;
 menu.init( on );
 assign( zf, 'C:\tp\zmenu.dat');
 reset( zf );
 while
  not eof(zf)
 do
  begin
   inc( numentries, 1 );
   readln( zf, data[numentries].MenuText );
   readln( zf, data[numentries].Path );
   readln( zf, data[numentries].Filename );
  end;
 close( zf );
 button( 13, 4, 33, numentries + 7 );
 greyshadow( 13, 4, 33, numentries + 7 );
 menu.add ( 15, 5, '|!w|b Í|BÍ|CÍ|b[|Yú|WZMenu|Yú|b]|CÍ|BÍ|bÍ', '', false, ' ', 0 );
 for
  counter := 1 to numentries
 do
  menu.add( 14, counter + 5, ' |r(|W' + N2S( Counter ) + '|r) |K' + data[counter].MenuText,
     ' |R(|W' + N2S( Counter ) + '|R) |W' + data[counter].MenuText, true, char( 48 + counter ), counter );
  menu.add( 14, counter + 6, ' |r(|W0|r)|K Quit          ', ' |R(|W0|R)|W Quit          ', true, '0', 0 );
 mouseon;
 choice := menu.get;
 doscursoron;
 if
  choice = 0
 then
  halt(0);
{ chdir( data[ choice ].path );}
 assign( zf, '\ztemp.bat' );
 rewrite( zf );
 writeln( zf, '@ECHO OFF' );
 writeln( zf, 'Call ' + data[choice].filename );
 writeln( zf, 'cd C:\');
 writeln( zf, 'ZMENU');
 close( zf );
End.