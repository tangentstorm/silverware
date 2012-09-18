{$G+}
var
    font: array [0..255, 0..15] of byte;
    fseg, fofs: word;
    j: word;
const
    VidSeg: word = $A000;
    NewPalette: array [0..16*3-1] of byte = (
        0, 0, 0,        0, 0,42,        0,42, 0,        0,42,42,
       42, 0, 0,       42, 0,42,       42,42, 0,       42,42,42,
       53,53,53,       53,53,63,       53,63,53,       53,63,63,
       63,53,53,       63,53,63,       63,63,53,       63,63,63);


procedure NormalizePalette; assembler;
asm
        mov     dx,03DAh
        xor     bx,bx
    @wait:
        in      al,dx
        test    al,8
        jz      @wait
        mov     dl,0C0h
    @loop:
        mov     al,bl
        out     dx,al
        jmp     @delay
    @delay:
        out     dx,al
        inc     bx
        cmp     bl,16
        jb      @loop
        in      al,dx
        mov     al,20h
        out     dx,al
end;

{ Write character number CHR at (X,Y) }
procedure WriteChar(x, y, chr: integer); assembler;
asm
        mov     es,[VidSeg]
        mov     si,[chr]
        mov     ax,[y]
        mov     di,[x]
        shl     ax,8
        shl     si,4
        add     di,ax
        shl     ax,2
        add     si,offset font
        add     di,ax

        mov     ax,[si]
        mov     bx,[si+2]
        mov     es:[di+0*80],al
        mov     es:[di+1*80],ah
        mov     es:[di+2*80],bl
        mov     es:[di+3*80],bh

        mov     ax,[si+4]
        mov     bx,[si+6]
        mov     es:[di+4*80],al
        mov     es:[di+5*80],ah
        mov     es:[di+6*80],bl
        mov     es:[di+7*80],bh

        mov     ax,[si+8]
        mov     bx,[si+10]
        mov     es:[di+8*80],al
        mov     es:[di+9*80],ah
        mov     es:[di+10*80],bl
        mov     es:[di+11*80],bh

        mov     ax,[si+12]
        mov     bx,[si+14]
        mov     es:[di+12*80],al
        mov     es:[di+13*80],ah
        mov     es:[di+14*80],bl
        mov     es:[di+15*80],bh
end;



const
    count: longint=0;
var
    timer: longint absolute 0:$46C;
    start, finish: longint;

begin
    asm mov ax,$0E; int $10; end;                   { set 640x200x16 }
    asm mov dx,03D4h; mov ax,4009h; out dx,ax; end; { set 640x400x16 }

    asm mov ax,$1130; mov bh,6; int $10; mov [fseg],es; mov [fofs],bp; end;
    move(mem[fseg:fofs], font, sizeof(font));

    NormalizePalette;                       { fix up palette }
    port[$3C8] := 0;
    for j := 0 to 16*3-1 do
        port[$3C9] := NewPalette[j];

    portw[$3C4] := $0102;                   { randomize bitplanes 1..3 }
    for j := 0 to 80*400-1 do
        mem[$A000:j] := random(256);
    portw[$3C4] := $0202;
    for j := 0 to 80*400-1 do
        mem[$A000:j] := random(256);
    portw[$3C4] := $0402;
    for j := 0 to 80*400-1 do
        mem[$A000:j] := random(256);

    portw[$3C4] := $0802;                   { font on bitplane 4 }
    start := timer;
    repeat
        WriteChar(random(70)+5, random(21)+2, random(256));
        inc(count);
    until mem[0:$41A] <> mem[0:$41C];
    finish := timer;

    asm sub ax,ax; int $16; end;            { wait for keypress }
    asm mov ax,3; int $10; end;             { set text mode }
    writeln(count*18.2/(finish-start):1:1, ' characters per second');
end.
