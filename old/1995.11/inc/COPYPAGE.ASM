INCLUDE asmcomm.inc

DATASEG
EXTRN PageSize:WORD
EXTRN PageTable:WORD
EXTRN SegA000:WORD

CODESEG
PUBLIC COPYPAGE
; void copypage(int sourcepage,int dest_page)
PROC COPYPAGE FAR
ARG dest_page:WORD, sourcepage:WORD = retbytes
  push   bp
  mov    bp, sp

  push   ds
  push   di
  push   si

  mov    bx, [sourcepage]
  shl    bx, 1
  and    bl, 3
  mov    si, [PageTable + bx]  ; Find the source page address
  mov    bx, [dest_page]
  and    bl, 3
  shl    bx, 1
  mov    di, [PageTable + bx]  ; Find the destination page address

  mov    dx, 3CEH
  mov    ax, 0008H  ; Set the bitmask to use the latch data.
  out    dx, ax
  mov    dx, SC_INDEX
  mov    ax, 0F02H  ; Use all four planes.
  out    dx, ax
  mov    ax, [SegA000]
  mov    es, ax
  mov    ds, ax
  mov    cx, [PageSize] ; Get size of each plane in bytes
  cld
  rep    movsb      ; Load the latches from source, and write them to dest

  mov    dx, 3CEH
  mov    ax, 0FF08H ; Set the bitmask for only CPU data
  out    dx, ax

  pop    si
  pop    di
  pop    ds
  pop    bp
  ret    retbytes
ENDP COPYPAGE

END
