{$i xpc }
program zmenu;
uses xpc, ui, fx, cw, num, cx, kvm, cli;

type
  Options = record
    menuText,
    path,
    filename : String;
  end;

Var
  zf         : Text;
  numEntries : Byte;
  userChoice : Byte;       { the byte returned based on the user's choice }
  choice     : ui.zChoice; { just a variable for working with choices }
  i          : Byte;
  data       : array [ 1 .. 20 ] of Options;
  menu       : ui.zMenu;
const  bluebox  = $19B1;
begin

  //  filling the background just makes a mess.
  // probably crt and video conflicting...
  // fillscreen( $3333, '#'); //'▒' );
  // DosCursorOff;
  cwriteln('|$|!k|w');


  numEntries := 0;

  assign( zf, 'zmenu.dat' );
  reset( zf );
  while not eof( zf ) do begin
    inc( numentries, 1 );
    readln( zf, data[ numentries ].MenuText );
    readln( zf, data[ numentries ].Path );
    readln( zf, data[ numentries ].Filename );
  end;
  close( zf );

  fx.button( 13, 4, 33, numEntries + 7 );

  //  fx.greyshadow( 13, 4, 33, numEntries + 7 );
  choice := ui.newChoiceXY( 15, 5,
			   '|!w |b═|B═|C═|b[|Y·|WZMenu|Y·|b]|C═|B═|b═', '',
			   false, ' ', 0, nil );

  menu := ui.newMenu( on, on, choice );

  for i := 1 to numentries do
    menu.add(
      ui.newChoiceXY( 14, i + 5,
		     cpadstr('|!w |r(|W' + N2S( i ) + '|r) |K'
			     + data[ i ].menutext, 20, ' ' ),
		     cpadstr('|!k |R(|W' + N2S( i ) + '|R) |W'
			     + data[ i ].menutext, 20, ' ' ),
		     true, Char( 48 + i ), i, nil ));


  menu.add(
    ui.newChoiceXY( 14, i + 6,
		   cpadstr('|!w |r(|W0|r)|K Quit', 20, ' '),
		   cpadstr('|!k |R(|W0|R)|W Quit', 20, ' '),
		   true, '0', 0, nil ));

  //  mouseOn;
  userChoice := menu.get;
  //  dosCursorOn;
  if userChoice = 0 then halt( 0 );

end.

  { the batch file generator works,
    but isn't actually useful to me anymore :)
    ------------------------------------------
  // chdir( data[ choice ].path );
  assign( zf, 'ztemp.bat' );
  rewrite( zf );
  writeln( zf, '@ECHO OFF' );
  writeln( zf, 'Call ' + data[choice].filename );
  writeln( zf, 'ZMENU' );
  close( zf );
  }
