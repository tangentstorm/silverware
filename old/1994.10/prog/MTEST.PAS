program mtest;
uses moustuff,crtstuff,crt;

procedure putpixel( x, y : integer; c  :  byte );
 begin
  mem[ $a000: 320 * y + x ] := c;
 end;

var
 quit : boolean;
 s, x, y, c : integer;

begin
 quit := false;
 if mousethere then writeln( 'mouse is here!' )
 else begin writeln('no mousie'); halt(0); end;
 setmode( $13 );
 mouseon;
 setmwin( 0, 0, 638, 199 );
 for s := 1 to 50 do putpixel( 1, s,  35 );
 repeat
  getmpos( s, x, y );
  if keypressed or (s and $02 <> 0) then quit := true;
  if s and $01 <> 0 then putpixel( x div 2, y, 15 );
 until quit;
end.