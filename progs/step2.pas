{ STEP2 }
program step2;
uses crt, crtstuff;
{$I Stepper2.pas}

var
 stick0,
 stick1,
 point0,
 point1,
 currentstick,
 count           : byte;
 speed0,
 speed1          : shortint;
 done            : boolean;

procedure send( value : byte );
 var
  c : byte;
 begin
  for
   c := 0 to 7
  do
   if
    boolean(truth( value and power( 2, c ) ))
   then
    colorxy( 66 + c, 4, lightred, 'þ' )
   else
    colorxy( 66 + c, 4, darkgray, 'þ' );
  port[ 888 ] := value;
 end;

procedure setstick( whichone, towhat : byte );
 var
  c : byte;
 begin
  if whichone = 0 then
   begin
    stick0 := towhat;
    speed0 := -1 * sgn( stick0 - 4 ) * ( 4 - abs( stick0 - 4) ) * 10;
    currentstick := 0;
    colorxy( 7,  9, $7A, 'ß' );
    colorxy( 7, 15, $70, 'ß' );
    for
     c := 1 to 7
    do
     if
      towhat = c
     then
      colorxy( 9 * c + 3, 10, $4C, '±' )
     else
      colorxy( 9 * c + 3, 10, $70, 'Å' )
   end { if }
  else
   begin
    stick1 := towhat;
    speed1 := -1 * sgn( stick1 - 4 ) * ( 4 - abs( stick1 - 4) ) * 10;
    currentstick := 1;
    colorxy( 7,  9, $70, 'ß' );
    colorxy( 7, 15, $7A, 'ß' );
    for
     c := 1 to 7
    do
     if
      towhat = c
     then
      colorxy( 9 * c + 3, 16, $4C, '±' )
     else
      colorxy( 9 * c + 3, 16, $70, 'Å' )
   end; { if }
 end;

procedure dothestepperthing;
 var
  tosend : byte;
 begin
  tosend := 0;
  count := incwrap( count, 1, 1, 100 );
  if
   (speed0 <> 0)
  then
   begin
    if
     (count mod speed0 = 0)
    then
     point0 := stepwrap( point0, sgn( speed0 ), 1, 4 );
    tosend := tosend or power( 2, point0 -1 );
   end;
  if
   (speed1 <> 0)
  then
   begin
    if
     count mod speed1 = 0
    then
     point1 := stepwrap( point1, sgn( speed1 ), 1, 4 );
    tosend := tosend or power( 2, point1 + 3 );
   end;
  send( tosend );
 end;

procedure init;
 begin
  setupcrt;
  done := false;
  point0 := 1;
  point1 := 1;
  stamp( 0, 1, 80, 19, @stepper2 );
  currentstick := 0;
  setstick( 1, 4 );
  setstick( 0, 4 );
  cwritexy( 7, 4, '|WD|Gua|WL ST|Ge|WPP|Ge|WR M|Go|WT|Go|WR C|Go|WNTR|Go|WLL|Ge|WR '+
                  '|B(|WC|B)|W1993 '+ Silverware );
 end;

procedure shutdown;
 begin
  send( 0 );
  textattr := $0f;
  doscursoron;
  clrscr;
 end;

begin
 init;
 repeat
  dothestepperthing;
  if
   keypressed
  then
   case upcase( readkey ) of
    #0  : case upcase( readkey ) of
           #75 {L}: if
                     currentstick = 0
                    then
                     setstick( 0, dec2( stick0, 1, 1 ) )
                    else
                     setstick( 1, dec2( stick1, 1, 1 ) );
           #77 {R}: if
                     currentstick = 0
                    then
                     setstick( 0, inc2( stick0, 1, 7 ) )
                    else
                     setstick( 1, inc2( stick1, 1, 7 ) );
           #72 {U}: setstick( 0, stick0 );
           #80 {D}: setstick( 1, stick1 );
          end;
    'A' : setstick( 0, 1 );
    'B' : setstick( 0, 2 );
    'C' : setstick( 0, 3 );
    'D' : setstick( 0, 4 );
    'E' : setstick( 0, 5 );
    'F' : setstick( 0, 6 );
    'G' : setstick( 0, 7 );
    'H' : setstick( 1, 1 );
    'I' : setstick( 1, 2 );
    'J' : setstick( 1, 3 );
    'K' : setstick( 1, 4 );
    'L' : setstick( 1, 5 );
    'M' : setstick( 1, 6 );
    'N' : setstick( 1, 7 );
    'Q',
    #27 : done := true;
   end;
 until done;
 shutdown;
end.