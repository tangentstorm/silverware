Program Plotter;
{ Graphics Plotter (c) 1992 MJW }
Uses CrtStuff, Math, Graph, Grafx;

Type GridObj = Object
       x0, y0, x1, y1, x2, y2, xMin, xMax, yMin, yMax, xS, yS : Integer;
       begun : boolean;
       Procedure Init( a1, b1, a2, b2, aS, bS : integer ) ;
       Procedure Plot(x,y : real);
       Procedure PlotEq;
       Procedure Draw;
     End;
Var Grid : GridObj;

Procedure GridObj.Init(a1,b1,a2,b2,aS,bS : integer );
  begin
    x1 := a1;
    y1 := b1;
    x2 := a2;
    y2 := b2;
    x0 := (a2-a1) div 2 + a1;
    y0 := (b2-b1) div 2 + b1;
    xS := aS;
    yS := bS;
    xMin := -(x0-x1) div xS;
    xMax :=  (x2-x0) div xS;
    yMin := -(y0-y1) div yS;
    yMax :=  (y2-y0) div yS;
    Draw;
  end;

Procedure GridObj.Plot( x, y : real );
  begin
    setcolor( 4 );
    if ( abs( y * yS ) <= abs( y0 - y1 ) ) and
       ( abs( x * xS ) <= abs( x0 - x1 ) ) then
    begin
      if begun then
        lineTo( x0 + round( xS * x ) , y0 - round( yS * y ) )
      else
        Moveto( x0 + round( xS * x ), y0 - round( yS * y ) );
      begun := true;
    end;
  end;

Procedure GridObj.PlotEq;
 var
   a,a2 : integer;
   x, y : real;
 begin
   begun := False;
   for a := xMin to xMax - 1 do
     for a2 := 0 to xS do
       begin
          x := ( a + ( a2 / xS ) );
          y := ( csc( 2 * ( x + 2 * Pi / 3 ) ) );
          plot( x, y );
       end;
 end;


Procedure GridObj.Draw;
  var
    counter : integer;
  begin
    SetFillStyle( SolidFill, 0 );
    Bar( x1, y1, x2, y2 );
    SetColor( 8 );
    SetLineStyle( DottedLn, 0, Normwidth );
    Counter := 0;
    While counter < y2-y0 do
     begin
      If counter mod yS = 0 then
        begin
          line( x1, y0 + counter, x2, y0 + counter );
          line( x1, y0 - counter, x2, y0 - counter );
        end;
        counter := counter + 1;
     end;
    Counter := 0;
    While counter < x2-x0 do
     begin
      If counter mod xS = 0 then
        begin
          line( x0 + counter, y1, x0 + counter, y2 );
          line( x0 - counter, y1, x0 - counter, y2 );
        end;
        counter := counter + 1;
     end;
    SetLineStyle( 0 , 0 , 1 );
    SetColor( 8 );
    Rectangle( x1, y1, x2, y2 );
    SetColor( 15 );
    Line( x1, y0, x2, y0 );
    Line( x0, y1, x0, y2 );
  end;

Begin
 InitGrafx;
 OutTextXY(1,0,' Graphics Plotter (c)1992 Michal J. Wallace');
 Grid.Init( 0, 20, GetMaxX, GetMaxY, 30, 30 );
 grid.plotEq;
 GetEnter;
End.