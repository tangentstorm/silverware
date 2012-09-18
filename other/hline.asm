INCLUDE asmcomm.inc

DATASEG
EXTRN RowTable:WORD
EXTRN LeftMask:BYTE, RightMask:BYTE
EXTRN WritePage:WORD
EXTRN SegA000:WORD

CODESEG
PUBLIC SOLIDHLINEX
PROC SOLIDHLINEX FAR
ARG color:WORD, x2:WORD, x1:WORD, y:WORD = retbytes
    push    bp
    mov     bp, sp
    push    di
    push    si

    mov     bx, [y]
    shl     bx, 1
    mov     di, [RowTable + bx]
    mov     ax, [x1]
    shr     ax, 2
    add     di, ax
    add     di, [WritePage]
    mov     ax, [SegA000]
    mov     es, ax    ; starting address in es:di
    mov     dx, SC_INDEX
    mov     al, MAP_MASK
    out     dx, al          ;set Sequence controller Address Register to Map Mask
    inc     dx              ;dx = Sequence controller Data Register

    mov     si, [x1]
    and     si, 03H         ;plane of start pixel
    mov     bh, [LeftMask + si]
    mov     si, [x2]
    and     si, 03H         ;plane of one past end pixel
    mov     bl, [RightMask + si]  ; bx has clipping masks
    mov     cx, [x2]        ;calculate width of rectangle
    mov     si, [x1]
    cmp     cx, si
    jle     @@line_done     ;exit if 0 or negative width
    and     si, 0FFFCH
    sub     cx, si
    shr     cx, 2           ;cx = # addresses to fill across rect
    jnz     @@do_line      ;more than one address to fill
    and     bh, bl          ;only one address, so combine masks
@@do_line:
    mov     ah, [byte ptr color]
    mov     al, bh     ;al = left edge clip mask
    out     dx, al     ;set Map Mask Register
    mov     al, ah     ;al = color
    stosb              ;draw left edge
    dec     cx
    js      @@line_done      ;only one byte
    jz      @@right_edge     ;only two bytes
    mov     al, 0FH
    out     dx, al           ;do middle 4 pixels at a time
    nop
    mov     al, ah           ;al = color
    rep     stosb            ;draw the middle
@@right_edge:
    mov     al, bl           ;al = right clip mask
    out     dx, al
    mov     al, ah           ;al = color
    stosb                    ;draw right edge
@@line_done:
    pop     si
    pop     di
    pop     bp
    ret     retbytes
ENDP SOLIDHLINEX

END
