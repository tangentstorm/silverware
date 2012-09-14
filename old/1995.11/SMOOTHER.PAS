{$G+,S-}                            { 286 instructions, no stack checking   }

program TheReallyCoolSmoothScrollingProgram;

const
    DownKey = $50;                  { Scan code for the down arrow  }
    UpKey   = $48;                  { Scan code for the up arrow    }
    EscKey  = $1;                   { Scan code for the escape key  }

    TextSeg: word = $A000;

    done: boolean = false;

    start: integer = 0;
    velocity: integer = 0;

var
    j: integer;


procedure DoCoppers; assembler;
asm
        cli
        mov     dx,03DAh            { Wait until OUT of vertical retrace    }
    @w: in      al,dx
        test    al,8
        jnz     @w

        mov     cx,0003Bh
        mov     bx,0FF00h
    @NextColor:
        mov     si,7
        inc     ch
    @NextLine:
        dec     bh
        mov     dx,03C8h
        mov     ax,bx
        out     dx,ax
        mov     dx,03DAh
    @I: in      al,dx
        test    al,1
        jz      @I
        mov     dx,03C9h
        mov     al,ch
        out     dx,al
        mov     al,cl
        out     dx,al
        mov     dx,03DAh
    @O: in      al,dx
        test    al,1
        jnz     @O
        dec     si
        jnz     @NextLine

        dec     cx
        cmp     cl,2
        jnz     @NextColor
        sti
end;

 
procedure SetScreenStart(ScanLine:word); assembler;
asm
        mov     bx,[ScanLine]           { bx := (ScanLine div 16)*80    }
        shr     bx,4
        mov     ax,bx
        shl     ax,6
        shl     bx,4
        add     bx,ax

        mov     dx,03D4h                { set start address (in words)  }
        mov     al,0Ch
        mov     ah,bh
        out     dx,ax
        mov     al,0Dh
        mov     ah,bl
        out     dx,ax

        mov     dx,03DAh            { Wait until IN vertical retrace        }
    @w: in      al,dx
        test    al,8
        jz      @w

        mov     dx,03D4h                { set character start scanline  }
        mov     al,8
        mov     ah,byte ptr [ScanLine]
        and     ah,15
        out     dx,ax

        call    DoCoppers
end;


procedure FastWrite(y:integer; attr:byte; s:string); assembler;
asm
        push    ds                      { save data segment             }
        mov     es,[TextSeg]            { es := text video segment      }
        imul    di,[y],160              { di := y*160                   }
        sub     cx,cx                   { cx := 0                       }
        lds     si,[s]                  { ds:si -> string               }
        mov     cl,[si]
        test    cx,cx
        jz      @Done
        inc     si
        mov     ah,[attr]               { ah = text attribute           }
    @CharLoop:
        mov     al,[si]
        mov     es:[di],ax
        inc     si
        add     di,2
        dec     cx
        jnz     @CharLoop
    @Done:
        pop     ds                      { restore data segment          }
end;


function str(num: integer): string;
var
    s: string[3];
begin
    system.str(num:3, s);
    str := s;
end;



begin

    asm
        mov     ax,3                    { Reset text mode               }
        int     $10
        mov     dx,03CEh
        mov     ax,0606h
        out     dx,ax
        in      al,21h                  { Disable keyboard interrupt    }
        push    ax
        or      al,2
        out     21h,al
        mov     ax,0100h
        mov     cx,2000h
        int     10h
    end;

    fillchar(mem[$A000:0], 65535, 15);
    for j := 0 to 408 do
        FastWrite(j, (j mod 15)+1,
            '            Line '+str(j)+' of the really cool smooth scrolling program');

(**************************   M A I N   L O O P   ****************************)

    repeat
        case port[$60] of               { Check for keypress            }
            DownKey : inc(velocity,2);
            UpKey   : dec(velocity,2);
            EscKey  : done := true;
        end;
        inc(start, velocity);           { update screen start position  }
        if word(start) > (408-24)*16 then
            if start < 0 then begin
                start := 0;
                velocity := (-velocity)*3 shr 2;
            end
            else begin
                start := (408-24)*16;
                velocity := -(velocity*3 shr 2);
            end;
        if velocity > 0 then dec(velocity)
        else if velocity < 0 then inc(velocity);
        SetScreenStart(start);          { set the screen start          }
    until done;

(*****************************************************************************)
    asm
        pop     ax                      { Re-enable keyboard interrupt  }
        out     21h,al
        mov     ax,3                    { Reset text mode               }
        int     $10
    end;

end.
