INCLUDE asmcomm.inc

DATASEG
EXTRN RowTable:WORD
EXTRN WritePage:WORD
EXTRN SegA000:WORD

CODESEG
PUBLIC SOLIDVLINEX
PROC SOLIDVLINEX FAR
ARG color:WORD, y2:WORD, y1:WORD, x:WORD = retbytes
    push    bp
    mov     bp, sp
    push    di
    push    si

    mov     bx, [y1]
    shl     bx, 1
    mov     di, [RowTable + bx]
    mov     ax, [x]
    shr     ax, 2
    add     di, ax
    add     di, [WritePage]
    mov     ax, [SegA000]
    mov     es, ax    ; starting address in es:di
    mov     cl, [byte ptr x]
    and     cl, 03H               ;pixels plane
    mov     ax, 0100H + MAP_MASK  ;al=index of Map Mask Register
    shl     ah, cl                ;set enable bit to pixel plane
    mov     dx, SC_INDEX
    out     dx, ax                ;enable writting only to pixels plane

    mov     al, [byte ptr Color]
    mov     cx, [y2]
    sub     cx, [y1]
    inc     cx
@@line_loop:
    mov     [es:di], al           ;draw pixel in selected color
    add     di, 80
    loop    @@line_loop

@@no_line:
    pop     si
    pop     di
    pop     bp
    ret     retbytes
ENDP SOLIDVLINEX

END
