unit num; { ■ number/conversion commands }
interface
  function min( p, q : longint ) : longint;
  function max( p, q : longint ) : longint;
  function inc2( goesto, amt, max : longint ) : longint;
  function dec2( from, amt, min : longint ) : longint;
  function incwrap( goesto, amt, min, max : longint ) : longint;
  function decwrap( from, amt, min, max : longint ) : longint;
  function stepwrap( x, amt, min, max : longint ) : longint;
  function h2s( w : word ) : string;
  function s2h( s : string ) : word;
  function n2s( x : longint ) : string;
  function s2n( s : string ) : longint;
  function truth(p : longint ) : byte;
  function power(a, b : longint ) : longint;
  function sgn( x : longint ) : shortint;

implementation

  function min( p, q : longint ) : longint;
  begin
    if p > q then min := q else min := p;
  end;

  function max( p, q : longint ) : longint;
  begin
    if p < q then max := q else max := p;
  end;

  function inc2( goesto, amt, max : longint ) : longint;
  begin
    if goesto + amt <= max then inc( goesto, amt )
    else goesto := max;
    result := goesto;
  end;

 function dec2( from, amt, min : longint ) : longint;
 begin
   if from - amt >= min then dec( from, amt )
   else from := min;
   result := from;
 end;

  function incwrap( goesto, amt, min, max : longint ) : longint;
  begin
    if goesto + amt <= max then inc( goesto, amt )
    else goesto := min;
    result := goesto;
  end;

  function decwrap( from, amt, min, max : longint ) : longint;
  begin
    if from - amt >= min then dec( from, amt )
    else from := max;
    result := from;
  end;

  function stepwrap( x, amt, min, max : longint ) : longint;
  begin
    if x + amt <= max then
      if x + amt >= min then x := x + amt
      else x := max
    else x := min;
    stepwrap := x;
  end;

  function h2s( w : word ) : string;
    var h : string;
  begin
    h := '0123456789ABCDEF';
    h2s := '$' +
	   h[ w shr 12 and $000F + 1 ] +
	   h[ w shr  8 and $000F + 1 ] +
	   h[ w shr  4 and $000F + 1 ] +
	   h[ w mod 16 + 1 ];
  end;

  function s2h( s : string ) : word;
    var c : byte; v : word;
  begin
    v := 0;
    if s[ 1 ] = '$' then delete( s, 1, 1 );
    for c := 1 to length( s ) do begin
      v := v shl 4;
      case s[ 1 ] of
	'0'..'9' : v := v + ord( s[1] ) - 48;
	'A'..'F' : v := v + ord( s[1] ) - 55;  { ord('A') -55 = 10 }
      end;
      delete( s, 1, 1 );
    end;
    s2h := v;
  end;

  function n2s( x : longint ) : string;
    var s : string;
  begin
    str( x, s );
    n2s := s;
  end;

  function s2n( s : String ) : longint;
    var i, e : Integer;
  begin
    val( s, i, e );
    if e <> 0 then s2n := 0 else s2n := i;
  end;

  function truth( p : longint ) : byte;
  begin
    if boolean( p ) then truth := 1
    else truth := 0;
  end;

  function power( a, b : longint ) : longint;
    var c, d : longint;
  begin
    d := 1;
    if b > 0 then
      for c := 1 to b do
	d := d * a;
    power := d;
  end;

  function sgn( x : longint ) : shortint;
  begin
    if x > 0 then sgn :=  1;
    if x = 0 then sgn :=  0;
    if x < 0 then sgn := -1;
  end;

initialization
end.

