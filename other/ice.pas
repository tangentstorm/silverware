{ TheDraw Pascal Screen Image }
const
  ICE_WIDTH=70;
  ICE_DEPTH=20;
  ICE_LENGTH=2800;
  ICE : array [1..2800] of Char = (
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,
    '�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,'�' ,#1  ,' ' ,#31 ,' ' ,#31 ,
    ' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,'�' ,#19 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,
    '�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,
    '�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,
    '�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,
    '�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,
    '�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,
    '�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#127,'�' ,#127,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    ' ' ,#127,'�' ,#127,'�' ,#127,'�' ,#120,'�' ,#120,'�' ,#127,'�' ,#120,
    '�' ,#8  ,'�' ,#8  ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#63 ,'�' ,#63 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,' ' ,#127,
    ' ' ,#127,'�' ,#7  ,'�' ,#127,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#127,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#31 ,' ' ,#31 ,
    '�' ,#31 ,'�' ,#63 ,' ' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,' ' ,#127,'�' ,#7  ,
    '�' ,#7  ,'�' ,#7  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#127,'�' ,#8  ,'�' ,#8  ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#63 ,
    '�' ,#63 ,' ' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#31 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#31 ,'�' ,#31 ,'�' ,#63 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#31 ,' ' ,#127,'�' ,#7  ,'�' ,#7  ,
    '�' ,#7  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#127,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,' ' ,#127,'�' ,#7  ,'�' ,#7  ,
    '�' ,#7  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,' ' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#31 ,'�' ,#25 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,' ' ,#127,'�' ,#7  ,'�' ,#7  ,'�' ,#7  ,'�' ,#7  ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#63 ,' ' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#63 ,' ' ,#127,'�' ,#7  ,'�' ,#7  ,'�' ,#7  ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,' ' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    ' ' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,'�' ,#63 ,
    '�' ,#63 ,'�' ,#63 ,'�' ,#31 ,'�' ,#63 ,'�' ,#63 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#31 ,'�' ,#31 ,'�' ,#63 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,'�' ,#31 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    '�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 );