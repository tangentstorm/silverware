{$N+}
{$E+}
program calc_3d;

uses graph,bgistuff, moustuff, crt,crtstuff;

type int = integer;

var
   max,min,xs,ys,x,xx,y,yy,lx,ly,vt,vt1,hz,hz1,grid,fit,llx,dist:real;
   a,b,c,d,e,f,g,h,i,j,k,l,color:integer;
   za,zmax,zmin,zh,zs,z1,z2,z3,z4:double;

function tan(x:real):real;
 begin
  tan:=sin(x)/cos(x);

 end;

function r2s( x : real ) : string;
 var
  s : string;
 begin
  str( x, s );
  r2s := s;
 end;

function stripvars( s : string; x, y : real ): string;
 var
  p : integer;
  sx : string;
 begin
  while pos( 'x', s ) > 0 do
   begin
    p := pos( 'x', s );
    delete( s, p, 1 );
    sx := r2s( x );
    insert( sx, s, p );
   end;
  while pos( 'y', s ) > 0 do
   begin
    p := pos( 'y', s );
    delete( s, p, 1 );
    sx := r2s( y );
    insert( sx, s, p );
   end;
  stripvars := s;
 end;

const
 func = 'x*y';

function z:real;
 var
  result : real;
  error : integer;
 begin
{  evaluate( stripvars( func, x, y ), result, error );
  if error <> 0 then
  halt;
  z := result;}
  z := x*x-1/y;
 end;

procedure quad( x1, y1, x2, y2, x3, y3, x4, y4: integer );
 var
  qa : array[1..4] of PointType;
 begin
  {setfillstyle( solidfill,color);}
  qa[ 1 ].x := x1; qa[ 1 ].y := y1;
  qa[ 2 ].x := x2; qa[ 2 ].y := y2;
  qa[ 3 ].x := x3; qa[ 3 ].y := y3;
  qa[ 4 ].x := x4; qa[ 4 ].y := y4;
  fillpoly( 4, qa );
 end;


procedure plot;

begin

  color:=0;
  zmax:=0;zmin:=0;
  y:=max;
  repeat
   x:=min;
   repeat
    lx:=x;ly:=y;
    x:=x+0.00001;y:=y+0.00001;
    if z >= zmax then zmax:=z;
    if z <= zmin then zmin:=z;
    x:=lx;y:=ly;
    x:=x+(max/2);
   until x>= max;
   y:=y-(max/2);
  until y<=min;
  zh:=zmax-zmin;
  zs:=zh/5;

  setcolor (8);
  setfillstyle( solidfill, 8 );
  quad(0,0,getmaxx,0,getmaxx,getmaxy,0,getmaxy);
  setcolor(white);
  outtextxy(10,10,'Plotting....');
  setcolor( 7 );

  y:=max;
  repeat
   x:=min;
   repeat 
    lx:=x;ly:=y;
    x:=x+0.00001;y:=y+0.00001;
    if enterpressed then exit;
     a := round(xx*(x + (y * hz)))+320;
     b := -round(yy*((y + (x * -hz)) * vt + (fit * z)))+240;
     z1:=z;
    x := x + grid;
     c := round(xx*(x + (y * hz)))+320;
     d := -round(yy*((y + (x * -hz)) * vt + (fit * z)))+240;
     z2:=z;
    y := y - grid;
     e := round(xx*(x + (y * hz)))+320;
     f := -round(yy*((y + (x * -hz)) * vt + (fit * z)))+240;
     z3:=z;
    x := x - grid;
     g := round(xx*(x + (y * hz)))+320;
     h := -round(yy*((y + (x * -hz)) * vt + (fit * z)))+240;
     z4:=z;
    z4:=z;
    za:=((z1+z2+z3+z4)/4);
    if za>zmin+(zs*0) then color:=0;
    if za>zmin+(zs*1) then color:=1;
    if za>zmin+(zs*2) then color:=9;
    if za>zmin+(zs*3) then color:=11;
    if za>zmin+(zs*4) then color:=15;
    setfillstyle(solidfill,color);
    quad(a,b,c,d,e,f,g,h);
    x := lx;
    y := ly;
    x:=x+grid;
   until x>= max;

   setcolor(10);
   if (0<y ) and (y<1.5*grid) then
    begin
     line(round(xx*max)+320,-round(yy * max * -hz * vt )+240,round(xx*min)+320,-round(yy * min * -hz * vt )+240);
     line(round(xx*max)+320,-round(yy * max * -hz * vt )+241,round(xx*min)+320,-round(yy * min * -hz * vt )+241);
     line(round(xx*max)+320,-round(yy * max * -hz * vt )+239,round(xx*min)+320,-round(yy * min * -hz * vt )+239);
     line(320,round(yy*min)+240,320,round(yy*max)+240);
     line(321,round(yy*min)+240,321,round(yy*max)+240);
     line(319,round(yy*min)+240,319,round(yy*max)+240);
    end;
   line(round(xx * y * hz)+320,-round(yy * y * vt)+240,round(xx * (y-grid) * hz)+320,-round(yy * (y-grid) * vt)+240);
   line(round(xx * y * hz)+321,-round(yy * y * vt)+240,round(xx * (y-grid) * hz)+321,-round(yy * (y-grid) * vt)+240);
   line(round(xx * y * hz)+319,-round(yy * y * vt)+240,round(xx * (y-grid) * hz)+319,-round(yy * (y-grid) * vt)+240);
   setcolor(7);

   y:= y-grid;
  until y <= min;

end;


procedure rotate;

var
   slow,mx2,my2:integer;
   v2,h2:real;

 begin
  setcolor(10);
  mouseon;
  showmouse(false);
  getmpos;
  mx2:=mx; my2:=my;
  repeat
   slow:=1;
   getmpos;
   v2:=vt1+(my2-my)/500;
   h2:=hz1-(mx2-mx)/500;

   if v2<-0.5 then v2:=-0.5;
   if v2>0.5 then v2:=0.5;
   if h2<-0.5 then h2:=-0.5;
   if h2>0.5 then h2:=0.5;

   setcolor (8);
   setfillstyle( solidfill, 8 );
   quad(0,0,getmaxx,0,getmaxx,getmaxy,0,getmaxy);
   setcolor( 10 );
   line(round(xx*max)+320,-round(yy * max * -h2 * v2 )+239,round(xx*min)+320,-round(yy * min * -h2 * v2 )+239);
   line(round(xx*max)+320,-round(yy * max * -h2 * v2 )+240,round(xx*min)+320,-round(yy * min * -h2 * v2 )+240);
   line(round(xx*max)+320,-round(yy * max * -h2 * v2 )+241,round(xx*min)+320,-round(yy * min * -h2 * v2 )+241);
   line(319,round(yy*min)+240,319,round(yy*max)+240);
   line(320,round(yy*min)+240,320,round(yy*max)+240);
   line(321,round(yy*min)+240,321,round(yy*max)+240);
   line(round(xx * min * h2)+319,-round(yy * min * v2)+240,round(xx * max * h2)+319,-round(yy * max * v2)+240);
   line(round(xx * min * h2)+320,-round(yy * min * v2)+240,round(xx * max * h2)+320,-round(yy * max * v2)+240);
   line(round(xx * min * h2)+321,-round(yy * min * v2)+240,round(xx * max * h2)+321,-round(yy * max * v2)+240);
   repeat
    slow:=slow+1;
   until slow=20;


  until ms=1;
  setcolor(7);
  vt:=tan(v2);
  hz:=tan(h2);
  plot;
  showmouse(true);
 end;


begin
 
 cwriteln('                           |RHAPPY |gThree-D |Y Plot!!!!!! |w ');
 write('Min/Max X & Y :');readln( max );
 min := -max;
 writeln(grid);
 {
 write('Vertical      :');readln( vt1);
 write('Horizontal    :');readln( hz1 );
 }
 write('Fit Factor    :');readln( fit);
 {
 max:=10;min:=-10;vt:=0.4;hz:=0.5;fit:=0.001;
 }
 hz1:=0; vt1:=0;


 grid:=(max-min)/50;
 xx:=240/max;
 yy:=xx;

 initgrafx;
 
 vt := TAN(vt1);
 hz := TAN(hz1);
 mouseon;
 showmouse(false);
 plot;
 showmouse(true);

 repeat
  getmpos;
  if (ms=1) then rotate;
 until keypressed;
 closegraph;

end.
