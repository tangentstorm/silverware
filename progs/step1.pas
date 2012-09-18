{ STEP1 }
program step1;
uses crt, crtstuff;
{$I Stepper1.pas}

var
 stick : byte;
 done  : boolean;

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

procedure setstick( towhat : byte );
 var
  c : byte;
 begin
  stick := towhat;
  for
   c := 1 to 7
  do
   if
    towhat = c
   then
    colorxy( 9 * c + 3, 10, $4C, '±' )
   else
    colorxy( 9 * c + 3, 10, $70, 'Å' )
 end;

procedure moveright( d : byte );
 begin
  send( 1 ); delay( d );
  send( 2 ); delay( d );
  send( 4 ); delay( d );
  send( 8 ); delay( d );
  send( 0 );
 end;

procedure moveleft( d : byte );
 begin
  send( 8 ); delay( d );
  send( 4 ); delay( d );
  send( 2 ); delay( d );
  send( 1 ); delay( d );
  send( 0 );
 end;

procedure dothestepperthing;
 begin
  case stick of
   1 : moveright( 5 );
   2 : moveright( 25 );
   3 : moveright( 100 );
   4 : send( 0 );
   5 : moveleft( 100 );
   6 : moveleft( 25 );
   7 : moveleft( 5 );
  end;
 end;

procedure init;
 begin
  setupcrt;
  done := false;
  stamp( 0, 1, 80, 13, @stepper1 );
  setstick( 4 );
  cwritexy( 9, 4, '|WST|Ge|WPP|Ge|WR M|Go|WT|Go|WR C|Go|WNTR|Go|WLL|Ge|WR '+
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
           #75 {L}: setstick( dec2( stick, 1, 1 ) );
           #77 {R}: setstick( inc2( stick, 1, 7 ) );
          end;
    'A' : setstick( 1 );
    'B' : setstick( 2 );
    'C' : setstick( 3 );
    'D' : setstick( 4 );
    'E' : setstick( 5 );
    'F' : setstick( 6 );
    'G' : setstick( 7 );
    'R' : moveright( 10 );
    'L' : moveleft( 10 );
    'Q',
    #27 : done := true;
   end;
 until done;
 shutdown;
end.