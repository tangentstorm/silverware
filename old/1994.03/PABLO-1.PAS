program pablo;

uses crt,crtstuff;

var
 quit:boolean;
 x,y,a,b,c,d : byte;
 v:screentype;

{$I LINES.PAS}

begin
 setupcrt;
 v := screen;
 x := 1;
 y := 1;
 a := 0;
 b := 0;
 quit := False;
 repeat
 
  colorxy(x,y,green,'');
  if keypressed then
  case readkey of
   #0 : begin
         screen := v;
         case readkey of
          #72:begin y := y-1; if y<1 then y:=25;  end;
          #80:begin y := y+1; if y>25 then y:=1; end;
          #75:begin x := x-1; if x<1 then x :=80; end;
          #77:begin x := x+1; if x>80 then x :=1; end;
         end;
        end;

   #13: if
         a=0
        then
         begin
          a := x;
          b := y;
          v := screen;
         end
        else
         begin
          drawline(a,b,x,y, random(15)+1);
          v := screen;
          a := 0;
         end;
   'q','Q',#27: quit := true;
   'c','C' : begin clrscr; v:= screen; end;

  end;  
 until quit;
 doscursoron;


end.