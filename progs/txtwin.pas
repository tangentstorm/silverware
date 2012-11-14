Program Textwindows;
uses crtstuff, crt;

procedure txtwin; external;
{$L txtwin}

const
 up = true;
 down = false;
 left = true;
 right = false;

type
 map = array[ 0..maxint ] of byte;
 viewer = object
  buffer : ^map;
  bufx, bufy,
  scrx1, scry1,
  scrx2, scry2,
  ofsx, ofsy : integer;
  constructor init( sx1, sy1, sx2, sy2, ox, oy : integer; buf : pointer;
                    bx, by : integer );
  procedure winsize( sx1, sy1, sx2, sy2: integer ); virtual;
  procedure setofs( ox, oy : integer ); virtual;
  procedure display; virtual;
  procedure scrollh( lr : boolean ); virtual;
  procedure scrollv( ud : boolean ); virtual;
 end;

 constructor viewer.init; { sx1, sy1, sx2, sy2, ox, oy, buf, bx, by }
  begin
   winsize( sx1, sy1, sx2, sy2 );
   setofs( ox, oy );
   buffer := buf;
   bufx := bx;
   bufy := by;
  end;

 procedure viewer.winsize; { sx1, sy1, sx2, sy2 }
  begin
   scrx1 := sx1;
   scry1 := sy1;
   scrx2 := sx2;
   scry2 := sy2;
  end;

 procedure viewer. setofs; { ox, oy }
  begin
   ofsx := ox;
   ofsy := oy;
  end;

 procedure viewer.display;
  var
   i, j : integer;
  begin
   for i := scry1 to scry2 do
    if
     ofsy + i-scry1 < bufy
    then
     for j := scrx1 to scrx2 do
      if
       ofsx + j-scrx1 < bufx
      then
       colorxy( j, i, $0F, char(buffer^[(ofsy+(i-scry1)) * (bufx+1) + ofsx + j -scrx1+1]))
      else
       colorxy( j, i, $0A, '■' )
    else
     colorxy( scrx1, i, $0A, chntimes( '■', scrx2-scrx1+1 ));
  end;

 procedure viewer.scrollh; { lr }
  begin
   if lr then ofsx := dec2( ofsx, 1, 0 ) else ofsx := inc2( ofsx, 1, bufx );
   display;
  end;

 procedure viewer.scrollv; { ud }
  begin
   if ud then ofsy := dec2( ofsy, 1, 0 ) else ofsy := inc2( ofsy, 1, bufy );
   display;
  end;

var
 v : viewer;
 ch : char;
 temp : screentype;
 f : file;
 s : string;
 i : byte;
 blah : array[ 1..$f ] of string[ 60 ];
begin
 blah[ $1 ] := '\23456789012345678901234567890';
 blah[ $2 ] := '2\ ...........                ' + blah[1];
 blah[ $3 ] := '3 \ ...........      ||||     ' + blah[1];
 blah[ $4 ] := '4  \ ...........     OO o     ' + blah[1];
 blah[ $5 ] := '5   \ ...........   (<  )     ' + blah[1];
 blah[ $6 ] := '6    \ ...........   \_/      ' + blah[1];
 blah[ $7 ] := '7     \ ...........           ' + blah[1];
 blah[ $8 ] := '8      >............          ' + blah[1];
 blah[ $9 ] := '9     / .............         ' + blah[1];
 blah[ $a ] := 'A    / .......                ' + blah[1];
 blah[ $b ] := 'B   / .........               ' + blah[1];
 blah[ $c ] := 'C  /         blah!            ' + blah[1];
 blah[ $d ] := 'D /          blah!            ' + blah[1];
 blah[ $e ] := 'E/           blah!            ' + blah[1];
 blah[ $f ] := '/                             ' + blah[1];
 textattr := $44;
 clrscr;
 colorxy( 5, 5, $4C, 'X' );
 colorxy( 5, 23, $4C, 'X' );
 colorxy( 60, 5, $4C, 'X' );
 colorxy( 60, 23, $4C, 'X' );
 colorxy( 4, 4, $4E, '■' );
 colorxy( 4, 24, $4E, '■' );
 colorxy( 61, 4, $4E, '■' );
 colorxy( 61, 24, $4E, '■' );
 v.init( 1, 1, 80, 25, 0, 0, @blah, 60, 15 );
 v.display;
 ch := #0;
 while ch <> #27 do
  begin
   ch := readkey;
   case ch of
    '8' : v.scrollv( up );
    '4' : v.scrollh( left );
    '6' : v.scrollh( right );
    '2' : v.scrollv( down );
   end;
   colorxy( 31+5, 15+5, $0E, '■' );
  end;
end.