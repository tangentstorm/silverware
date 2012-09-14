program stereo_test;

uses
 vgastuff, crtstuff, crt;

var
 celfile: string;

function virt( color: byte ): integer;
 begin
  virt:= round(((900/256)*color)/30);
 end;

function getpixelvga( x, y : byte ) : byte;
 begin
  getpixelvga := drawto^[320*y+x];
 end;


procedure render;
 var
  x, y, xl, xr, sep: integer;
  color: byte;
 begin
   for x:=0 to 319 do
   begin
    for y:=0 to 199 do
    begin
     vga[ y * 320 + x ]:=round( random( 256 ) );
    end;
   end;
   for y := 0 to 199 do
   begin
    for x := 45 to 319 do
     begin
       color:=tempvga^[ y * 320 + x ];
       if ( color > 0) then
       begin
{         xl:=round(((-(50/virt(color))+2.5))*30);
         xr:=round((-(-(50/virt(color))+2.5))*30);}
         sep:=round(((-(50/virt(color))+2.5))*30);
 {        if ( xl < 0 ) then xl:=0;
         if ( xr > 319 ) then xr:=319;}
         vga[ y * 320 + x ]:= vga[ y * 320 + x + sep ];
       end;
     end;
   end;
 end;

begin
 cwriteln( '' );
 cwrite( '|YCEL |W filename: |B' );
 read( celfile );
 setmode($13);
 if (pos( '.cel' , celfile ) < 1 ) then celfile:= celfile + '.cel';
 drawto:=tempvga;
 loadcel( celfile );
 render;
 repeat until keypressed;
 setmode( 3 );
end.



