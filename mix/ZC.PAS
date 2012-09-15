program zc;
uses crt,crtstuff;

type
 zcolor = object
  x, y,
  value,
  acol : byte;
  endloop : boolean;
  procedure init( a, b, ac, strt : byte );
  procedure handle( ch : char );
  procedure show;
  function get : byte;
 end;
 ztoggle = object
  x, y,
  tcol  : byte;
  start,
  value,
  endloop : boolean;
  truestr, falsestr : string;
  procedure init( a, b, tc : byte; ts, fs : string; startval : boolean );
  procedure show;
  procedure handle( ch : char );
  function toggle : boolean;
  function get : boolean;
 end;
 zyesno = object( ztoggle )
  procedure init( a, b, tc : byte; startval : boolean );
 end;

procedure zcolor.init( a, b, ac, strt : byte );
 begin
  x := a;
  y := b;
  acol := ac;
  value := strt;
 end;

procedure zcolor.handle( ch : char );
 begin
  case ch of
  end;
 end;

procedure zcolor.show;
 var
  s : string;
 begin
  colorxy( x, y, byte( value > 0 ) * acol, '®' );
  case value of
   $0 : s := 'black';
   $1 : s := 'blue';
   $2 : s := 'green';
   $3 : s := 'cyan';
   $4 : s := 'red';
   $5 : s := 'magenta';
   $6 : s := 'brown';
   $7 : s := 'lightgrey';
   $8 : s := 'darkgrey';
   $9 : s := 'lightblue';
   $A : s := 'lightgreen';
   $B : s := 'lightcyan';
   $C : s := 'brightred';
   $D : s := 'lightmagenta';
   $E : s := 'yellow';
   $F : s := 'white';
  end;
  if
   value = 0
  then
   colorxyc( x + 7, y, $F, s )
  else
   colorxyc( x + 7, y, value, s );
  colorxy( x + 15, y, byte( value < 16 ) * acol, '¯' );
 end;

function zcolor.get : byte;
 begin
  show;
  repeat
   handle( readkey );
  until endloop;
 end;

procedure ztoggle.init( a, b, tc : byte; ts, fs : string; startval : boolean );
 begin
  x := a;
  y := b;
  tcol := tc;
  truestr := ts;
  falsestr := fs;
  start := startval;
  value := startval;
  endloop := false;
 end;

procedure ztoggle.show;
 begin
  if
   value
  then
   colorxy( x, y, tcol, truestr )
  else
   colorxy( x, y, tcol, falsestr );
 end;

procedure ztoggle.handle( ch : char );
 var
  ts, fs : char;
 begin
  ts := upcase(  truestr[ 1 ] );
  fs := upcase( falsestr[ 1 ] );
  ch := upcase( ch );
  if
   ch = ts
  then
   value := true
  else
   if
    ch = fs
   then
    value := false
   else
    case ch of
     #13 : endloop := true;
     #27 : begin
            value := start;
            endloop := true;
           end;
    end;
  show;
 end;

function ztoggle.toggle : boolean;
 begin
  value := not value;
  show;
 end;

function ztoggle.get : boolean;
 var
  ch : char;
 begin
  endloop := false;
  repeat
   show;
   ch := readkey;
   case ch of
    #0  : ch := readkey;
    else handle( ch );
   end;
  until endloop;
  get := value;
 end;

procedure zyesno.init( a, b, tc : byte; startval : boolean );
 begin
  ztoggle.init( a, b, tc, 'Yes', 'No ', startval );
 end;

var
 zcol : zcolor;
 zyn : zyesno;
 x : byte;
begin
 clrscr;
 zcol.init( 5, 5, $08, 12 );
 x := zcol.get;
end.