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
  SetLineStyle(solidln,0,ThickWidth);
  while ms and $01 <> 0 do
   begin
    getmpos;
    rectangle( mx - ofx, my - ofy, mx-ofx + w, my-ofy + h );
    rectangle( mx - ofx, my - ofy, mx-ofx + w, my-ofy + h );
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
    mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  setwritemode( xorput );
  setcolor( 15  );
  SetLineStyle(solidln,0,ThickWidth);

  while ms and $01 <> 0 do
   begin
    getmpos;
    rectangle( x1,y1,mx,my );
    showmouse(on);showmouse(off);
    rectangle( x1,y1,mx,my );

    showmouse(on);showmouse(off);
   end;
  
  x2 := mx ;
  y2 := my ;
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
var w01:winder;

procedure redraw;
begin
 showmouse(off);
 setfillstyle(1,9);
 bar(0,0,640,480);
 w01.draw;
 showmouse(on);
end;


procedure init;
 begin
  initgrafx;
  w01.init;
  mouseon;
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


