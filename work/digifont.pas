Program DIGI_FoNT;

const
 header = '[[SaBReN]]''s Digifont'+ #26;
var
 nothing : string;

procedure donothing;
 begin
  nothing := header;
 end;

procedure DigiFont; External;
{$L DIGIFONT.OBJ}

procedure installfont( fontseg, fontofs : word );
 Begin
   fontofs := fontofs + 16;
   Asm;

   push    bp

   mov     si, 40h
   mov     es, si
   mov     ax, es:[ 60h ]
   push    ax                 { save old cursor style on stack }

   mov     ax, fontseg
   mov     es, ax

   mov     ax, 1100h           { Load userdefined charset }
   mov     bx, 1000h           { bh = bytes per char ( 10h ); bl = page ( 0h ) }
   mov     cx, 00FFh           { number of patterns }
   mov     dx, 0001h           { dx = first char }
   mov     bp, fontofs         { es:bp -> new char table }

   int     10h                 { install the new chars }

   mov     ah, 12h
   mov     bh, 20h

   int     10h                 { and set up the printscreen procedure }

   mov     ax,0100h
   pop     cx                  { get the old cursor style }
   int     10h                 { and restore it }

   pop     bp                  { restore bp }
 end; {asm}
End;



begin
 donothing;
 installfont( seg(Digifont), ofs( Digifont) );
end.