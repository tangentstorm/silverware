program mtest;
uses crt, crtstuff, moustuff;

procedure SetMode (Mode : word);
begin
  asm
    mov ax,Mode;
    int 10h
  end;
end;


procedure putpixel( x, y : integer; c : byte );
 begin
  mem[ $a000: y * 320 + x ] := c;
 end;


procedure drawline( a, b, c, d : integer; color : byte );
 var
  m : real;
  x,y,lasty : integer;
 procedure drawvertical( a2, b2, d2 : integer );
  var count : integer;
  begin
   for count := min( b2, d2 ) to max( b2, d2 ) do putpixel( a2, count, color );
  end;
 begin
  if min( a, c ) = a then lasty := b else lasty := d;
  if
   ( a - c ) <> 0
  then
   begin
    m := (b-d) / (a-c);
    for x := max( 0, min( a, c )) to min( 319, max( a, c )) do
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
     Putpixel( x, y, color );
    end; { for x.. }
   end { if..then }
  else
   drawvertical( a, b, d );
 end; { procedure }

procedure rectangle( a1, b1, a2, b2 : integer; c: byte );
 var
  l, r, t, b : integer;
 begin
  l := min( a1, a2 );
  r := max( a1, a2 );
  t := min( b1, b2 );
  b := max( b1, b2 );
  drawline( l, t, r, t, c );
  drawline( r, t, r, b, c );
  drawline( r, b, l, b, c );
  drawline( l, b, l, t, c );
 end;

procedure box( a1, b1, a2, b2 : integer; c: byte );
 var
  l, r, t, b, count : integer;
 begin
  l := min( a1, a2 );
  r := max( a1, a2 );
  t := min( b1, b2 );
  b := max( b1, b2 );
  for count := t to b do
   fillchar( mem[ $a000: 320 * count + l ], r - l + 1, c );
 end;


const
 dtlin = 0;
 dtrec = 1;
 dtbox = 2;
 dtdrw = 3;
 dters = 4;

var
 quit : boolean;
 x, y, x1, y1 : integer;
 oc : boolean;
 drawtype, linecolor : byte;

procedure drawmenu;
 var
  col : byte;
 begin
  col := 55;
  showmouse( off );
  drawline( 0, 0, 89, 0, col );
  drawline( 0, 2, 89, 2, col );
  drawline( 0, 4, 89, 4, col );
  drawline( 0, 6, 89, 6, col );
  drawline( 0, 8, 89, 8, col );
  if drawtype = dters then col := 40 else col := 55;
   rectangle( 91, 0, 99, 8, col ); { Eraser Box }
   drawline( 93, 2, 93, 6, col );
   drawline( 93, 2, 97, 2, col );
   drawline( 93, 4, 96, 4, col );
   drawline( 93, 6, 97, 6, col );
  if drawtype = dtdrw then col := 40 else col := 55;
   rectangle( 101, 0, 109, 8, col ); { normal draw }
   putpixel( 105, 4, col );
  if drawtype = dtlin then col := 40 else col := 55;
   rectangle( 111, 0, 119, 8, col ); { draw lines }
   drawline( 113, 4, 117, 4, col );
  if drawtype = dtrec then col := 40 else col := 55;
   rectangle( 121, 0, 129, 8, col ); { draw rects }
   rectangle( 123, 2, 127, 6, col );
  if drawtype = dtbox then col := 40 else col := 55;
   rectangle( 131, 0, 139, 8, col ); { draw boxes }
   box( 133, 2, 137, 6, col );
  col := 55;
  rectangle( 141, 0, 158, 8, col ); { CLS Box }
  drawline( 143, 2, 146, 2, col ); { c }
  drawline( 143, 2, 143, 6, col ); { c }
  drawline( 143, 6, 146, 6, col ); { c }
  drawline( 148, 2, 148, 6, col ); { l }
  drawline( 148, 6, 151, 6, col ); { l }
  drawline( 153, 2, 156, 2, col ); { s }
  drawline( 153, 2, 153, 4, col ); { s }
  drawline( 153, 4, 156, 4, col ); { s }
  drawline( 156, 4, 156, 6, col ); { s }
  drawline( 153, 6, 156, 6, col ); { s }
  rectangle( 160, 0, 169, 8, col ); { black box }
  for x := 1 to 15 do
   box( 161 + x * 10, 0, 169 + x * 10, 8, x );
  drawline( 0, 10, 319, 10, linecolor );
  showmouse( on );
 end;


procedure menu( a : integer );
 begin
  showmouse( false );
  x1 := -1;
  case a of
     0.. 89 : quit := true;
    91.. 99 : drawtype := dters;
   101..109 : drawtype := dtdrw;
   111..119 : drawtype := dtlin;
   121..129 : drawtype := dtrec;
   130..139 : drawtype := dtbox;
   140..159 : box( 0, 11, 320, 200, 0 );
   160..319 : linecolor := ( a - 160 ) div 10;
  end;
  drawmenu;
  showmouse( true );
 end;

const
 HPaint : GCursor =
  ( ScreenMask : ( $FFFF, $FFFF, $FEFF, $FC7F,
                   $F83F, $F01F, $E00F, $F01F,
                   $F83F, $C803, $8001, $8001,
                   $8001, $8003, $800F, $C99F);
    CursorMask : ( $0000, $0000, $0000, $0100,
                   $0380, $07C0, $0FE0, $0380,
                   $0380, $0000, $367C, $366C,
                   $3E7C, $3660, $3660, $0000);
    hotx : 7;
    hoty : 2);
 c_hair : GCursor =
  ( ScreenMask : ( $FC7F, $FC7F, $FC7F, $FC7F,
                   $FC7F, $FEFF, $07C1, $0381,
                   $07C1, $FEFF, $FC7F, $FC7F,
                   $FC7F, $FC7F, $FC7F, $FFFF);
    CursorMask : ( $0000, $0100, $0100, $0100,
                   $0100, $0000, $0000, $793C,
                   $0000, $0000, $0100, $0100,
                   $0100, $0100, $0000, $0000);
    hotx : 7;
    hoty : 7);




begin
 if not mousethere then begin cwriteln('|WNo Mousie, Mon...'); halt(1); end;
 setmode( $13 );
 linecolor := 15;
 drawtype := dtlin;
 drawmenu;
 mouseon;
 setgcurs( c_hair );
 setmwin( 0, 0, 638, 199 );
 setmpos( 320, 100 );
 quit := false;
 x1 := -1;
 oc := false;
 repeat
  getmpos;
  if
   (my <= 10) and not oc then begin setgcurs( Hpaint ); oc := true; end
  else
   if (my > 10) and oc then begin setgcurs( c_hair ); oc := false; end;
  mx := mx div 2;
  if
   keypressed and (readkey = #27)
  then
   quit := true
  else
   if
    ms AND $02 <> 0
   then
    x1 := -1
   else
    if
     ( ms and $01 <> 0 )
    then
     if
      (my > 10) and (drawtype in [ dters, dtdrw ])
     then
      begin
       if (( mx <> x1 ) or ( my <> y1 )) and ( x1 <> -1 ) then
        begin
         showmouse( off );
         case drawtype of
          dters : box( max( mx - 5, 0 ), max( my - 5, 10 ),
                       min( mx + 5, 319 ), min( my + 5, 199 ), linecolor );
          dtdrw : drawline( x1, y1, mx, my, linecolor );
         end;
         showmouse( on );
        end;
       x1 := mx;
       y1 := my;
      end
     else
      begin
       repeat getmpos until ms = 0;
       mx := mx div 2;
       if
        x1 = -1
       then
        begin
         if
          my > 10
         then
          begin
           x1 := mx;
           y1 := my;
           showmouse( off );
           putpixel( x1, y1, 55 );
           showmouse( on );
          end
         else
          menu( mx );
        end
       else
        begin
         if
          my <= 10
         then
          menu( mx )
         else
          begin
           showmouse( false );
           case drawtype of
            dtlin : drawline( x1, y1, mx, my, linecolor );
            dtrec : rectangle( x1, y1, mx, my, linecolor );
            dtbox : box( x1, y1, mx, my, linecolor );
           end;
           if
            drawtype <> dtlin
           then
            x1 := -1
           else
            x1 := mx;
           y1 := my;
           showmouse( true );
          end;
        end;
      end;
 until quit;
 setmode( co80 );
end.