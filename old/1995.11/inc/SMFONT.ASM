;
;   Powder River Graphics Tools - Small font Assembly file
;   (c)Copyright 1990, Michael Chapin
;   All Rights Reserved
;

BIT_MAPPED EQU 0
STROKED EQU 1

.MODEL small
.CODE

  db      21, 'Powder River Font File', 0, '  '
  db      10, 'Small Font', 0, '                     '
  ; font header information
PUBLIC smfont
smfont:
  db      BIT_MAPPED             ; font type
  dw      97                     ; number of characters in font
  db      32                     ; first character in font
  db      128                    ; last character in font
  db      5                      ; widest character in pixels
  db      1                      ; font byte width
  db      6                      ; font lines high
  db      ?                      ; width not needed for bit mapped font
  dw      OFFSET fwidth          ; width table
  dw      SEG fwidth
  dd      ?                      ; offset table
  dw      OFFSET fdata           ; font data
  dw      SEG fdata

; Font width data
fwidth:
  db      3         ; #32 space
  db      3         ; #33 !
  db      4         ; #34 "
  db      5         ; #35 #
  db      5         ; #36 $
  db      5         ; #37 %
  db      5         ; #38 &
  db      4         ; #39 '
  db      4         ; #40 (
  db      4         ; #41 )
  db      4         ; #42 *
  db      4         ; #43 +
  db      3         ; #44 ,
  db      4         ; #45 -
  db      3         ; #46 .
  db      4         ; #47 /
  db      5         ; #48 0
  db      4         ; #49 1
  db      5         ; #50 2
  db      5         ; #51 3
  db      5         ; #52 4
  db      5         ; #53 5
  db      5         ; #54 6
  db      5         ; #55 7
  db      5         ; #56 8
  db      5         ; #57 9
  db      3         ; #58 :
  db      4         ; #59 ;
  db      4         ; #60 <
  db      3         ; #61 =
  db      4         ; #62 >
  db      5         ; #63 ?
  db      5         ; #64 @
  db      5         ; #65 A
  db      5         ; #66 B
  db      5         ; #67 C
  db      5         ; #68 D
  db      5         ; #69 E
  db      5         ; #70 F
  db      5         ; #71 G
  db      5         ; #72 H
  db      4         ; #73 I
  db      5         ; #74 J
  db      5         ; #75 K
  db      5         ; #76 L
  db      5         ; #77 M
  db      5         ; #78 N
  db      5         ; #79 O
  db      5         ; #80 P
  db      5         ; #81 Q
  db      5         ; #82 R
  db      5         ; #83 S
  db      5         ; #84 T
  db      5         ; #85 U
  db      5         ; #86 V
  db      5         ; #87 W
  db      5         ; #88 X
  db      5         ; #89 Y
  db      5         ; #90 Z
  db      5         ; #91 [
  db      5         ; #92 \
  db      5         ; #93 ]
  db      4         ; #94 ^
  db      5         ; #95 _
  db      3         ; #96 `
  db      5         ; #97 a
  db      5         ; #98 b
  db      5         ; #99 c
  db      5         ; #100 d
  db      5         ; #101 e
  db      5         ; #102 f
  db      5         ; #103 g
  db      5         ; #104 h
  db      4         ; #105 i
  db      5         ; #106 j
  db      5         ; #107 k
  db      4         ; #108 l
  db      5         ; #109 m
  db      5         ; #110 n
  db      5         ; #111 o
  db      5         ; #112 p
  db      5         ; #113 q
  db      5         ; #114 r
  db      5         ; #115 s
  db      4         ; #116 t
  db      5         ; #117 u
  db      5         ; #118 v
  db      5         ; #119 w
  db      5         ; #120 x
  db      5         ; #121 y
  db      5         ; #122 z
  db      5         ; #123 {
  db      2         ; #124 |
  db      5         ; #125 }
  db      4         ; #126 ~
  db      5         ; #127


; font pattern data
fdata:
  ; #32 space
  db      00000000b
  db      00000000b
  db      00000000b
  db      00000000b
  db      00000000b
  db      00000000b

  ; #33  !
  db      01000000b
  db      01000000b
  db      01000000b
  db      00000000b
  db      01000000b
  db      00000000b

  ; #34 "
  db      10100000b
  db      10100000b
  db      00000000b
  db      00000000b
  db      00000000b
  db      00000000b

  ; #35 #
  db      01010000b
  db      11111000b
  db      01010000b
  db      11111000b
  db      01010000b
  db      00000000b

  ; #36 $
  db      00100000b
  db      01110000b
  db      10100000b
  db      01110000b
  db      00110000b
  db      01110000b

  ; #37 %
   db      10010000b
   db      00100000b
   db      00100000b
   db      01000000b
   db      10010000b
   db      00000000b

   ; #38 &
   db      00100000b
   db      01110000b
   db      10100000b
   db      01110000b
   db      10100000b
   db      01110000b

   ; char39 '
   db      00100000b
   db      01000000b
   db      00000000b
   db      00000000b
   db      00000000b
   db      00000000b

   ; char40 (
   db      00100000b
   db      01000000b
   db      10000000b
   db      10000000b
   db      01000000b
   db      00100000b

   ; char41 )
   db      10000000b
   db      01000000b
   db      00100000b
   db      00100000b
   db      01000000b
   db      10000000b

   ; char42 *
   db      00000000b
   db      10100000b
   db      01000000b
   db      10100000b
   db      00000000b
   db      00000000b

   ; char43 +
   db      00000000b
   db      01000000b
   db      11100000b
   db      01000000b
   db      00000000b
   db      00000000b

   ; char44 ,
   db      00000000b
   db      00000000b
   db      00000000b
   db      00000000b
   db      01000000b
   db      10000000b

   ; char45 -
   db      00000000b
   db      00000000b
   db      11100000b
   db      00000000b
   db      00000000b
   db      00000000b

   ; char46 .
   db      00000000b
   db      00000000b
   db      00000000b
   db      00000000b
   db      01000000b
   db      00000000b

   ; char47 /
   db      00010000b
   db      00100000b
   db      00100000b
   db      01000000b
   db      10000000b
   db      00000000b

   ; char48 0
   db      01100000b
   db      10010000b
   db      10110000b
   db      10010000b
   db      01100000b
   db      00000000b

   ; char49 1
   db      01000000b
   db      11000000b
   db      01000000b
   db      01000000b
   db      11100000b
   db      00000000b

   ; char50 2
   db      01100000b
   db      10010000b
   db      00010000b
   db      00100000b
   db      11110000b
   db      00000000b

   ; char51 3
   db      01100000b
   db      10010000b
   db      00100000b
   db      10010000b
   db      01100000b
   db      00000000b

   ; char52 4
   db      00100000b
   db      10100000b
   db      10100000b
   db      11110000b
   db      00100000b
   db      00000000b

   ; char53 5
   db      11110000b
   db      10000000b
   db      11100000b
   db      00010000b
   db      11100000b
   db      00000000b

   ; char54 6
   db      01100000b
   db      10000000b
   db      11100000b
   db      10010000b
   db      01100000b
   db      00000000b

   ; char55 7
   db      11110000b
   db      00010000b
   db      00100000b
   db      00100000b
   db      00100000b
   db      00000000b

   ; char56 8
   db      01100000b
   db      10010000b
   db      01100000b
   db      10010000b
   db      01100000b
   db      00000000b

   ; char57 9
   db      01100000b
   db      10010000b
   db      11110000b
   db      00010000b
   db      01110000b
   db      00000000b

   ; char58 :
   db      01000000b
   db      01000000b
   db      00000000b
   db      01000000b
   db      01000000b
   db      00000000b

   ; char59 ;
   db      00000000b
   db      00100000b
   db      00000000b
   db      00100000b
   db      01000000b
   db      00000000b

   ; char60 <
   db      00100000b
   db      01000000b
   db      10000000b
   db      10000000b
   db      01000000b
   db      00100000b

   ; char61 =
   db      00000000b
   db      11100000b
   db      00000000b
   db      11100000b
   db      00000000b
   db      00000000b

   ; char62 >
   db      10000000b
   db      01000000b
   db      00100000b
   db      00100000b
   db      01000000b
   db      10000000b

   ; char63 ?
   db      01100000b
   db      10010000b
   db      00010000b
   db      00100000b
   db      00000000b
   db      00100000b

   ; char64 @
   db      01100000b
   db      10010000b
   db      10110000b
   db      10000000b
   db      01100000b
   db      00000000b

   ; char65 A
   db      01100000b
   db      10010000b
   db      10010000b
   db      11110000b
   db      10010000b
   db      00000000b

   ; char66 B
   db      11100000b
   db      10010000b
   db      11100000b
   db      10010000b
   db      11100000b
   db      00000000b

   ; char67 C
   db      01100000b
   db      10010000b
   db      10000000b
   db      10010000b
   db      01100000b
   db      00000000b

   ; char68 D
   db      11100000b
   db      10010000b
   db      10010000b
   db      10010000b
   db      11100000b
   db      00000000b

   ; char69 E
   db      11110000b
   db      10000000b
   db      11100000b
   db      10000000b
   db      11110000b
   db      00000000b

   ; char70 F
   db      11110000b
   db      10000000b
   db      11100000b
   db      10000000b
   db      10000000b
   db      00000000b

   ; char71 G
   db      01110000b
   db      10000000b
   db      10110000b
   db      10010000b
   db      01110000b
   db      00000000b

   ; char72 H
   db      10010000b
   db      10010000b
   db      11110000b
   db      10010000b
   db      10010000b
   db      00000000b

   ; char73 I
   db      11100000b
   db      01000000b
   db      01000000b
   db      01000000b
   db      11100000b
   db      00000000b

   ; char74 J
   db      01110000b
   db      00100000b
   db      00100000b
   db      10100000b
   db      01100000b
   db      00000000b

   ; char75 K
   db      10010000b
   db      10100000b
   db      11000000b
   db      10100000b
   db      10010000b
   db      00000000b

   ; char76 L
   db      10000000b
   db      10000000b
   db      10000000b
   db      10000000b
   db      11110000b
   db      00000000b

   ; char77 M
   db      10010000b
   db      11110000b
   db      10010000b
   db      10010000b
   db      10010000b
   db      00000000b

   ; char78 N
   db      10010000b
   db      11010000b
   db      10110000b
   db      10010000b
   db      10010000b
   db      00000000b

   ; char79 O
   db      01100000b
   db      10010000b
   db      10010000b
   db      10010000b
   db      01100000b
   db      00000000b

   ; char80 P
   db      11100000b
   db      10010000b
   db      10010000b
   db      11100000b
   db      10000000b
   db      00000000b

   ; char81 Q
   db      01100000b
   db      10010000b
   db      10010000b
   db      11010000b
   db      01110000b
   db      00010000b

   ; char82 R
   db      11100000b
   db      10010000b
   db      11100000b
   db      10010000b
   db      10010000b
   db      00000000b

   ; char83  S
   db      01110000b
   db      10000000b
   db      01100000b
   db      00010000b
   db      11100000b
   db      00000000b

   ; char84 T
   db      11100000b
   db      01000000b
   db      01000000b
   db      01000000b
   db      01000000b
   db      00000000b

   ; char85 U
   db      10010000b
   db      10010000b
   db      10010000b
   db      10010000b
   db      01100000b
   db      00000000b

   ; char86 V
   db      10010000b
   db      10010000b
   db      10010000b
   db      10100000b
   db      01000000b
   db      00000000b

   ; char87 W
   db      10010000b
   db      10010000b
   db      10010000b
   db      11110000b
   db      10010000b
   db      00000000b

   ; char88 X
   db      10010000b
   db      10010000b
   db      01100000b
   db      10010000b
   db      10010000b
   db      00000000b

   ; char89 Y
   db      10010000b
   db      10010000b
   db      11110000b
   db      00100000b
   db      00100000b
   db      00000000b

   ; char90 Z
   db      11110000b
   db      00010000b
   db      00100000b
   db      01000000b
   db      11110000b
   db      00000000b

   ; char91 [
   db      01110000b
   db      01000000b
   db      01000000b
   db      01000000b
   db      01110000b
   db      00000000b

   ; char92 \
   db      10000000b
   db      01000000b
   db      01000000b
   db      00100000b
   db      00010000b
   db      00000000b

   ; char93 ]
   db      01110000b
   db      00010000b
   db      00010000b
   db      00010000b
   db      01110000b
   db      00000000b

   ; char94 ^
   db      01000000b
   db      10100000b
   db      00000000b
   db      00000000b
   db      00000000b
   db      00000000b

   ; char95 _
   db      00000000b
   db      00000000b
   db      00000000b
   db      00000000b
   db      00000000b
   db      11111000b

   ; char96 `
   db      10000000b
   db      01000000b
   db      00000000b
   db      00000000b
   db      00000000b
   db      00000000b

   ; char97 a
   db      00000000b
   db      01110000b
   db      10010000b
   db      10110000b
   db      11010000b
   db      00000000b

   ; char98 b
   db      10000000b
   db      11100000b
   db      10010000b
   db      10010000b
   db      11100000b
   db      00000000b

   ; char99 c
   db      00000000b
   db      01110000b
   db      10000000b
   db      10000000b
   db      01110000b
   db      00000000b

   ; char100 d
   db      00010000b
   db      01110000b
   db      10010000b
   db      10010000b
   db      01110000b
   db      00000000b

   ; char101 e
   db      00000000b
   db      01100000b
   db      11110000b
   db      10000000b
   db      01100000b
   db      00000000b

   ; char102 f
   db      01110000b
   db      01000000b
   db      11100000b
   db      01000000b
   db      01000000b
   db      00000000b

   ; char103 g
   db      00000000b
   db      01110000b
   db      10010000b
   db      01110000b
   db      00010000b
   db      11100000b

   ; char104 h
   db      10000000b
   db      11100000b
   db      10010000b
   db      10010000b
   db      10010000b
   db      00000000b

   ; char105 i
   db      01000000b
   db      00000000b
   db      01000000b
   db      01000000b
   db      11100000b
   db      00000000b

   ; char106 j
   db      00010000b
   db      00000000b
   db      00010000b
   db      00010000b
   db      10010000b
   db      01100000b

   ; char107 k
   db      10000000b
   db      10100000b
   db      11000000b
   db      10100000b
   db      10010000b
   db      00000000b

   ; char108 l
   db      11000000b
   db      01000000b
   db      01000000b
   db      01000000b
   db      11100000b
   db      00000000b

   ; char109 m
   db      00000000b
   db      10010000b
   db      11110000b
   db      10010000b
   db      10010000b
   db      00000000b

   ; char110 n
   db      00000000b
   db      10100000b
   db      11010000b
   db      10010000b
   db      10010000b
   db      00000000b

   ; char111 o
   db      00000000b
   db      01100000b
   db      10010000b
   db      10010000b
   db      01100000b
   db      00000000b

   ; char112 p
   db      00000000b
   db      11100000b
   db      10010000b
   db      11100000b
   db      10000000b
   db      10000000b

   ; char113 q
   db      00000000b
   db      01110000b
   db      10010000b
   db      01110000b
   db      00010000b
   db      00010000b

   ; char114 r
   db      00000000b
   db      10100000b
   db      11010000b
   db      10000000b
   db      10000000b
   db      00000000b

   ; char115 s
   db      00000000b
   db      01100000b
   db      11100000b
   db      00010000b
   db      11100000b
   db      00000000b

   ; char116 t
   db      01000000b
   db      11100000b
   db      01000000b
   db      01000000b
   db      00100000b
   db      00000000b

   ; char117 u
   db      00000000b
   db      10010000b
   db      10010000b
   db      10010000b
   db      01100000b
   db      00000000b

   ; char118 v
   db      00000000b
   db      10010000b
   db      10010000b
   db      10100000b
   db      01000000b
   db      00000000b

   ; char119 w
   db      00000000b
   db      10010000b
   db      10010000b
   db      11110000b
   db      10010000b
   db      00000000b

   ; char120 x
   db      00000000b
   db      10010000b
   db      01100000b
   db      01100000b
   db      10010000b
   db      00000000b

   ; char121 y
   db      00000000b
   db      10010000b
   db      10010000b
   db      01110000b
   db      00010000b
   db      11100000b

   ; char122 z
   db      00000000b
   db      11110000b
   db      00100000b
   db      01000000b
   db      11110000b
   db      00000000b

   ; char123 {
   db      00110000b
   db      01000000b
   db      10000000b
   db      01000000b
   db      00110000b
   db      00000000b

   ; char124 |
   db      10000000b
   db      10000000b
   db      00000000b
   db      10000000b
   db      10000000b
   db      00000000b

   ; char125 }
   db      11000000b
   db      00100000b
   db      00010000b
   db      00100000b
   db      11000000b
   db      00000000b

   ; char126 ~
   db      01010000b
   db      10100000b
   db      00000000b
   db      00000000b
   db      00000000b
   db      00000000b

   ; char127
   db      00100000b
   db      01010000b
   db      10001000b
   db      10001000b
   db      11111000b
   db      00000000b

END
