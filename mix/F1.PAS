program f_1_zone;

{

well, here it is! this is just a sample of the game that i plan to write,
but i think its off to a good start. i know some of the procedures may not
be, well, perfect, but they work. if you have suggestions, feel free to
tell me. also, i used setmode(2) to get back to the text screen, but it
does funny things like turning everything black and white when you restart
turbo pascal. fix it! then tell me. thats it! i'm assuming that you
have all the wizard units that you gave me, especially the joystick unit.
of course, you'll have to borrow steven's joystick, and i'm curious if
this will work with another brand - although it should. enjoy! }





uses
    joystick,crtstuff,vgastuff,crt,moustuff;

var color:integer;
    jx,jy,bx,by,cx,cy,maxx,maxy,minx,miny,xjs,yjs:integer;

procedure calibrate;
var
   a,b,c,d:word;
 begin
  showmouse(false);
  setmode(2);
  writeln('Move the joystick to the upper left corner, then press button a.');
  repeat
   positions(word(jx),word(jy),c,d);
   jx:=a;
   jy:=b;
   minx:=jx;
   miny:=jy;
  until buttona1;
  repeat until not buttona1;
  writeln('Move the joystick to the center, then press button a.');
  repeat
   positions(a,b,c,d);
   jx:=a;
   jy:=b;
   cx:=jx;
   cy:=jy;
  until buttona1;
  repeat until buttona1=false;
  writeln('Move the jotstick to the lower right corner, then press button a.');
  repeat
   positions(a,b,c,d);
   jx:=a;
   jy:=b;
   maxx:=jx;
   maxy:=jy;
  until buttona1;
  repeat until buttona1=false;
  minx:=minx-cx;
  maxx:=maxx-cx;
  xjs:=cx;
  cx:=0;
  miny:=miny-cy;
  maxy:=maxy-cy;
  yjs:=cy;
  cy:=0;
  setmode($13);
  loadcel('c:\tp\inc\startup.cel');
  showmouse(true);;
 end;

procedure play;
 begin
  showmouse(false);
  repeat
   loadcel('c:\tp\inc\backgrnd.cel');
   setcolor(3,33,33,33);
   rectangle(150,180,180,190,0);
  until buttona2=true;
  loadcel('c:\tp\inc\startup.cel');
  showmouse(true);
 end;



procedure getjpos;
 var
    a,b,c,d:word;
 begin;
  positions(a,b,c,d);
  jx:=a-xjs;
  jy:=b-yjs;
 end;

function msinbox(a,b,c,d:integer):boolean;
 begin
  if (a<mx) and (mx<c) and (b<my) and (my<d) then
   msinbox:=true;
 end;

begin
 setmode($13);
 calibrate;
 loadcel('c:\tp\inc\startup.cel');
 mouseon;
 repeat
  getmpos;
  getjpos;

  if jx < minx+(xjs/2) then setmpos(mx-10,my);
  if jx > maxx-(xjs/2) then setmpos(mx+10,my);
  if jy < miny+(yjs/2) then setmpos(mx,my-5);
  if jy > maxy-(yjs/2) then setmpos(mx,my+5);




  if (ms=1) or (buttona1=true) then
   begin
    if msinbox(32,140,66,154)=true then play;
    if msinbox(472,137,504,151)=true then calibrate;
   end;
 until ((msinbox(32,166,66,180)=true) and (ms=1)) or ((msinbox(32,166,66,180)=true) and (buttona1=true));
 setmode(2);
 cwriteln('|gThank you for playing!|w');
end.

