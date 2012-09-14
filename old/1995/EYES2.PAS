uses
    graph,bgistuff,moustuff,crt;

var
   xx,yy,xs,ys,x1,y1,px1,px2,py,mx2,my2:integer;



begin

 initgrafx;
 setfillstyle(solidfill,8);
 setcolor(8);
 bar(0,0,getmaxx,getmaxy);
 setfillstyle(solidfill,15);
 setcolor(15);
 mouseon;
 repeat
  getmpos;
  mx2:=mx; my2:=my;

  repeat
   getmpos;
  until (mx<>mx2) or (my<>my2) or keypressed;

  getmpos;
  if my>=20 then
   begin
    y1:=round(my/46);
    ys:=20;
   end
  else
   begin
    y1:=round(my/2);
    ys:=10;
   end;

  if mx<=320 then
   begin
    x1:=round(mx/-32);
    xs:=-1;
    xx:=0;
   end
  else
   begin
    x1:=round(mx/32);
    xs:=1;
    xx:=0;
   end;


    showmouse(false);
    setcolor(8);
    circle(px1,py,1);
    circle(px2,py,1);
    setcolor(15);
    circle(303,20,15); circle(337,20,15);
    circle(293+(x1*xs)+xx,y1+ys,1);
    circle(327+(x1*xs)+xx,y1+ys,1);
    showmouse(true);

    px1:=293+(x1*xs)+xx;
    px2:=327+(x1*xs)+xx;
    py:=y1+ys;

 until keypressed;


end.