function min( p, q : byte ) : byte;
 begin
  if p > q then min := q else min := p;
 end;

function max( p, q : byte ) : byte;
 begin
  if p < q then max := q else max := p;
 end;

procedure drawline( a, b, c, d, color : byte );
 var
  m : real;
  x,y,lasty : integer;
 procedure drawvertical( a, b, d : byte );
  var count : byte;
  begin
   for count := min( b, d ) to max( b, d ) do colorxy( a, count, color, 'Û' );
  end;
 begin
  if min( a, c ) = a then lasty := b else lasty := d;
  if
   ( a - c ) <> 0
  then
   begin
    m := (b-d) / (a-c);
    for x := max( 1, min( a, c )) to min( 80, max( a, c )) do
    begin
     y := round (m * ( x - a )) + b;
     if
      abs( y - lasty ) > 1
     then
      if
       min( y, lasty ) = y
      then
       drawvertical( x, lasty-1, y )
      else
       drawvertical( x, lasty+1, y );
     lasty := y;
     colorxy( x, y, color, 'Û' );
    end; { for x.. }
   end { if..then }
  else
   drawvertical( a, b, d );
 end; { procedure }
