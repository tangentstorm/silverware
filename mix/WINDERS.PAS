program Winders;

uses crtstuff,bgistuff, moustuff,graph;
const
 closebox=$01;
 zoombox=$02;
 resize=$04;
 movable=$08;
 scroll=$10;
 clickout=$20;
 zoomedout=$40;

var
 doredraw : boolean;

const
 black : GCursor =
  ( ScreenMask : ( $3FFF, $1FFF, $0FFF, $07FF,
$03FF, $01FF, $00FF, $007F,
$003F, $003F, $01FF, $10FF,
$30FF, $F87F, $F87F, $FC7F);
    CursorMask : ( $C000, $A000, $9000, $8800,
$8400, $8200, $8100, $8080,
$8040, $83C0, $9200, $A900,
$C900, $0480, $0480, $0380);
    hotx : $0001;
    hoty : $0001);

type
winder=object
attrib,z,id,user:byte;
x1,x2,y1,y2,ox1,ox2,oy1,oy2:integer;
colors:string;

constructor init;

procedure tools;



procedure close;
procedure move;
procedure zoom;
procedure resize;





procedure draw;

end;
constructor winder.init;
begin
attrib := attrib and not zoomedout;
z:=1;x1:=100;x2:=400;y1:=10;y2:=100;
end;

procedure winder.tools;
 begin
  getmpos;
  if
   (ms and $01 <> 0)
   and (mx > x1 ) and (mx < x2 )
   and (my > y1 ) and (my < y2 )
  then
   begin
    doredraw := true;
    if (mx>x1+16) and (mx<x2-16) and (my<y1+16)
     then move else
    if (mx<x1+16) and (my<y1+16)
     then close else
    if (mx>x2-16) and (my<y1+16)
     then zoom else
    if (mx>x2-16) and (my>y2-16)
     then resize else
      begin
       repeat getmpos until ms = 0;
       doredraw := false;
      end;
   end;
end;

procedure winder.move;
 var
  mx2,my2:integer;
  ofx, ofy, h, w : word;
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  setwritemode( xorput );
  setcolor( 15  );
  w := x2 - x1;
  h := y2 - y1;
  ofx := mx-x1;
  ofy := my-y1;
  SetLineStyle(dottedln,0,normwidth);
  while ms and $01 <> 0 do
   begin
    getmpos;
    
    showmouse(false);
    rectangle( mx - ofx, my - ofy, mx-ofx + w, my-ofy + h );

    showmouse(yes);
    mx2:=mx;
    my2:=my;
    repeat
     getmpos;
    until (mx <> mx2 ) or ( my <> my2 ) or (ms=0);
    showmouse(false);

    rectangle( mx2 - ofx, my2 - ofy, mx2-ofx + w, my2-ofy + h );
    showmouse(true);
    {getmpos;}
   end;
  x1 := mx - ofx;
  x2 := x1+w;
  y1 := my - ofy;
  y2 := y1+h;
  SetLineStyle(solidln,0,normwidth);
  setwritemode( normalput );
  showmouse( mv );
 end;

procedure winder.close;
 begin
  z := 0;
 end;

procedure winder.zoom;
 begin
  if attrib and zoomedout <> 0 then
   begin
    x1:=ox1;
    x2:=ox2;
    y1:=oy1;
    y2:=oy2;
   end
  else
   begin
    ox1:=x1;
    ox2:=x2;
    oy1:=y1;
    oy2:=y2;
    x1:=0;
    x2:=640;
    y1:=0;
    y2:=480;
   end;
  attrib := attrib xor zoomedout;
 end;

procedure winder.resize;


 var
    my2,mx2, xs,ys :integer;
    mv : boolean;
 begin
  getmpos;
  xs:=x2-mx; ys:=y2-my;
  mx2:=mx; my2:=my;
  mv := mvisible;
  showmouse( off );
  setwritemode( xorput );
  setcolor( 15  );
  SetLineStyle(dottedln,0,normWidth);

  while ms and $01 <> 0 do
   begin

    getmpos;
    showmouse(false);
    rectangle( x1,y1,mx+xs,my+ys );
    showmouse(true);
    mx2:=mx;
    my2:=my;

    repeat
     getmpos;
    until (mx <> mx2 ) or ( my <> my2 ) or (ms=0);

    if mx < (x1+50) then setmpos(x1+50,my);

    if my < (y1+50) then setmpos(mx,y1+50);

    showmouse(false);
    rectangle( x1,y1,mx2+xs,my2+ys);
    showmouse(true);

   end;

  x2 := mx+xs ;
  y2 := my+ys ;
  SetLineStyle(solidln,0,normwidth);
  setwritemode( normalput );
  showmouse( mv );
 end;




procedure winder.draw;
var mv: boolean;
begin
if z = 0 then exit;
mv := mvisible;
showmouse(off);
whitebox(x1,y1,x2,y2);
setcolor (0);
setfillstyle (1,7);
bar(x1,y1,x2,y1+15);
bar(x2-15,y2-15,x2,y2);
rectangle(x2-15,y2-15,x2,y2);
rectangle(x1,y1,x2,y1+15);
rectangle(x1,y1,x1+15,y1+15);
rectangle(x2,y1,x2-15,y2);
rectangle(x1,y2-15,x2,y2);

showmouse(mv);
end;
var w01,w02:winder;

procedure redraw;
begin
 showmouse(off);
 setfillstyle(1,8);
 bar(0,0,640,480);
 w01.draw;
 w02.draw;
 showmouse(on);
end;


procedure init;
 begin
  initgrafx;
  w01.init;
  w02.init;
  mouseon;
  setgcurs(black);
  redraw;
 end;




procedure mouseloop;
var done:boolean;
begin
done :=false;
repeat
getmpos;
 done:=w01.z = 0;

 if ms and 1 <> 0 then
  begin
   w02.tools;
   w01.tools;
   if doredraw then redraw;
  end;
 until done;
end;


procedure shutdown;
 begin
 closegraph;
 end;






 begin
 init;

 {actual program}

 mouseloop;
 shutdown;

 end.


