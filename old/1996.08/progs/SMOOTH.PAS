{$G+,S-}                            { 286 instructions, no stack checking   }

program TheReallyCoolSmoothScrollingProgram;

const
    DownKey = $50;                  { Scan code for the down arrow  }
    UpKey   = $48;                  { Scan code for the up arrow    }
    EscKey  = $1;                   { Scan code for the escape key  }

    TextSeg: word = $B800;

    done: boolean = false;

    start: integer = 0;
    velocity: integer = 0;

var
    j: integer;


procedure WaitUntilInRetrace; assembler;
asm
        mov     dx,03DAh            { Wait until IN vertical retrace        }
    @w: in      al,dx
        test    al,8
        jz      @w
end;


procedure WaitUntilOutRetrace; assembler;
asm
        mov     dx,03DAh            { Wait until OUT of vertical retrace    }
    @w: in      al,dx
        test    al,8
        jnz     @w
end;

 
procedure SetScreenStart(ScanLine:word); assembler;
asm
        mov     bx,[ScanLine]           { bx := (ScanLine div 16)*80    }
        shr     bx,4
        mov     ax,bx
        shl     ax,6
        shl     bx,4
        add     bx,ax

        call    WaitUntilOutRetrace

        mov     dx,03D4h                { set start address (in words)  }
        mov     al,0Ch
        mov     ah,bh
        out     dx,ax
        mov     al,0Dh
        mov     ah,bl
        out     dx,ax

        call    WaitUntilInRetrace

        mov     dx,03D4h                { set character start scanline  }
        mov     al,8
        mov     ah,byte ptr [ScanLine]
        and     ah,15
        out     dx,ax
end;


procedure FastWrite(y:integer; attr:byte; s:string); assembler;
asm
        push    ds                      { save data segment             }
        mov     es,[TextSeg]            { es := text video segment      }
        imul    di,[y],160              { di := y*160                   }
        sub     cx,cx                   { cx := 0                       }
        lds     si,[s]                  { ds:si -> string               }
        lodsb                           { get length                    }
        mov     cl,al                   { store length in cx            }
        jcxz    @Done                   { if length=0, no string        }
        mov     ah,[attr]               { ah = text attribute           }
    @CharLoop:
        lodsb                           { get character                 }
        stosw                           { store it                      }
        loop    @CharLoop               { loop until finished           }
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
{        mov     ax,3                    { Reset text mode               }
{        int     $10}

    asm
        in      al,21h                  { Disable keyboard interrupt    }
        push    ax
        or      al,2
        out     21h,al
    end;

    randomize;
    for j := 0 downto -444 do
        FastWrite(j, random(16),
            'Line '+str(j)+' of the really cool smooth scrolling program');

(**************************   M A I N   L O O P   ****************************)

    repeat
        case port[$60] of               { Check for keypress            }
            DownKey : inc(velocity);
            UpKey   : dec(velocity);
            EscKey  : done := true;
        end;
        inc(start, velocity);           { update screen start position  }
        if word(start) > (204-24)*16 then begin
            velocity := 0;
            if start < 0 then start := 0
            else start := (204-24)*16;
        end;
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
