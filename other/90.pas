{$G+}
uses vgastuff,crtstuff;
const
    Vga90: array [1..9] of word = (
        $6B00,$5901,$5A02,$8E03,$6004,$8D05,$2D13,$0101,$0800);

procedure gumbella; external;
  {$L Gumbella}



procedure SetWidth90; assembler;
asm
        mov     dx,03D4h
        mov     ax,02E11h
        out     dx,ax
        lea     si,[Vga90]
        mov     dx,03D4h
        mov     cx,7
        rep     outsw
        mov     dx,03C4h
        outsw
        lodsw
        mov     dx,03DAh
        in      al,dx
        mov     dx,03C0h
        mov     al,13h
        out     dx,al
        mov     al,ah
        out     dx,al
        mov     al,20h
        out     dx,al
        out     dx,al
end;


var
    j: word;
begin
 {   asm mov ax,3; int $10; end;     { set normal text mode to clear screen }


    SetWidth90;
{    for j := 0 to 89 do begin
        mem[$B800:j*2] := (j mod 10)+$30;
        mem[$B800:180+j*2] := (j div 10)+$30;
    end;
}
    setcolor(32,0,0,0);
    mem[0:$44A] := 90;
    installfont(seg(gumbella), ofs(gumbella));
    settextheight( 14 );
    mem[0:$484] := 25;
end.
    asm mov ax,3; int $10; end;     { return to normal text mode }
end.
