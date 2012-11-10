{ TheDraw Pascal Screen Image }
const
  MUSIC3_WIDTH=80;
  MUSIC3_DEPTH=25;
  MUSIC3_LENGTH=4000;
  MUSIC3 : array [1..4000] of Char = (
    ' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,
    ' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,
    ' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,'M' ,#12 ,
    'A' ,#12 ,'E' ,#12 ,'S' ,#12 ,'T' ,#12 ,'R' ,#12 ,'O' ,#12 ,' ' ,#12 ,
    '(' ,#11 ,'c' ,#15 ,')' ,#11 ,'1' ,#15 ,'9' ,#15 ,'9' ,#15 ,'4' ,#15 ,
    ' ' ,#15 ,'�' ,#8  ,'S' ,#15 ,'�' ,#7  ,'�' ,#7  ,'�' ,#7  ,'L' ,#7  ,
    '�' ,#7  ,'N' ,#7  ,'G' ,#7  ,'�' ,#8  ,'S' ,#15 ,'�' ,#7  ,'L' ,#7  ,
    'V' ,#7  ,'�' ,#7  ,'�' ,#7  ,'W' ,#7  ,'�' ,#7  ,'�' ,#7  ,'�' ,#7  ,
    '�' ,#8  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,
    ' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,
    ' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,
    ' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,' ' ,#112,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#112,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#112,'�' ,#8  ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,' ' ,#112,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#8  ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,' ' ,#112,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#112,'�' ,#8  ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,' ' ,#112,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,' ' ,#112,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,' ' ,#112,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#112,
    '�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#8  ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,
    '�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#112,'�' ,#8  ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,' ' ,#112,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,' ' ,#112,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#112,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,' ' ,#112,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#112,
    '�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    ' ' ,#112,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,
    '-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,' ' ,#120,'-' ,#120,
    ' ' ,#120,'-' ,#120,' ' ,#120,'�' ,#8  ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,'�' ,#8  ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,
    '�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 ,'�' ,#25 );