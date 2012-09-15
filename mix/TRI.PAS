program tri;

uses crtstuff, vgastuff;

procedure filltri(  x1, y1, x2, y2, x3, y3, c : integer);
 procedure compare( var a, b, c : integer );
  begin
   if (a<b) then b:=a;
   if (a>c) then c:=a;
  end;
 var
  coord : array[ 0..1 , 0..799 ] of integer;
  dx, dxabs,
  dy, dyabs,
  i, k,
  old_sdy,
  minrow, maxrow,
  sdx, sdy, sy0, x, xe, xs, y,
  temp, y_sign, decision, ye, ys : integer;
  xpoint, ypoint : array[ 0..3] of integer;
 begin
  minrow := 800;
  maxrow := 0;
  for i := 0 to 479 do
   begin
    coord[0][i] := 800;
    coord[1][i] := 0;
   end;

  xpoint[ 0 ] := x1;
  ypoint[ 0 ] := y1;
  xpoint[ 1 ] := x2;
  ypoint[ 1 ] := y2;
  xpoint[ 2 ] := x3;
  ypoint[ 2 ] := y3;
  xpoint[ 3 ] := x1;
  ypoint[ 3 ] := y1;

  for i := 0 to 2 do
   begin
    xs := xpoint[ i ];
    ys := ypoint[ i ];
    xe := xpoint[ i + 1 ];
    ye := ypoint[ i + 1 ];
    if (xs > xe) then
     begin
      temp := xs;
      xs := xe;
      xe := temp;
      temp := ys;
      ys := ye;
      ye := temp;
     end;
    compare( xs, coord[0][ys], coord[1][ys] );
    compare( ys, minrow, maxrow );
    dx := abs( xe - xs );
    dy := abs( ye - ys );
    if ((ye - ys) < 0) then y_sign := -1 else y_sign := 1;
    if (dx > dy)
     then
      begin
       y := ys;
       decision := 0;
       for x := xs to xe do
        begin
         if (decision >= dx) then
          begin
           decision := decision - dx;
           y := y + y_sign;
          end;
         compare(x, coord[0][y], coord[1][y]);
         compare(y, minrow, maxrow );
         decision := decision + dy;
        end;
      end
     else
      begin
       x:= xs;
       y:= ys;
       decision := 0;
       repeat
        if (decision >= dy) then
         begin
          decision := decision - dy;
          x := x+1;
         end;
        compare(x, coord[0][y], coord[1][y]);
        compare(y, minrow, maxrow );
        decision := decision + dx;
        y := y + y_sign;
       until y <> ye;
     end;
   end; { for i}
  for i := minrow to maxrow do
   begin
    xs := coord[0][i];
    xe := coord[1][i];
    fillchar( drawto^[ i * 320 + xs ], xs-xe+1, c );
   end;
 end;

procedure fillquad( x1, y1, x2, y2, x3, y3, x4, y4, c : integer );
 begin
  filltri( x1, y1, x2, y2, x3, y3, c );
  filltri( x3, y3, x4, y4, x1, y1, 4 );
 end;


begin
 setmode( $13 );
 filltri( 7, 1,  1, 15,  15, 15,
            32  );
 getenter;
 setmode( 3 );
end.