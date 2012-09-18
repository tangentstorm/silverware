; common file for all asm files

.286P
.model large

SC_INDEX    EQU 03C4H   ;Sequence Controller Index
CRTC_INDEX  EQU 03D4H   ;CRT Controller Index
MISC_OUTPUT EQU 03C2H   ;Miscellaneous Output register
MAP_MASK    EQU 02H     ;index of Map Mask Register
GC_INDEX    EQU 03CEH   ;Graphics Controller Address Register
BIT_MASK    EQU 08H     ;index in GC of Bit Mask Register
READ_MAP    EQU 04H     ;index of Map Mask Register

TRANSPARENT EQU 0FFFFH

LOCALS @@

IDEAL
