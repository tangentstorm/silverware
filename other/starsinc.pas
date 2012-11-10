{ TheDraw Pascal Screen Image }
const
  STARS_WIDTH=70;
  STARS_DEPTH=20;
  STARS_LENGTH=2800;
  STARS : array [1..2800] of Char = (
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,'.' ,#7  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,'.' ,#1  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    '�' ,#4  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,'�' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,
    ' ' ,#9  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#14 ,'�' ,#14 ,
    '�' ,#14 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,
    ' ' ,#9  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#7  ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#4  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    '�' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#14 ,'�' ,#14 ,'�' ,#14 ,
    '�' ,#14 ,'�' ,#14 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,' ' ,#9  ,
    ' ' ,#9  ,'�' ,#4  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#14 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,'�' ,#4  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#1  ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#15 ,
    '.' ,#7  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,'�' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#1  ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,'�' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,'�' ,#16 ,'�' ,#16 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,
    '�' ,#127,'�' ,#127,'�' ,#127,'�' ,#127,'�' ,#127,'�' ,#127,'�' ,#127,
    ' ' ,#1  ,'�' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    '�' ,#7  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#1  ,
    '�' ,#1  ,' ' ,#16 ,' ' ,#16 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,
    ' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,'�' ,#127,'�' ,#127,'�' ,#127,'�' ,#127,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#4  ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#1  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,'�' ,#7  ,'�' ,#16 ,'�' ,#16 ,' ' ,#16 ,' ' ,#16 ,
    ' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,
    ' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,'�' ,#127,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,'�' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,'�' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#18 ,' ' ,#18 ,
    ' ' ,#18 ,' ' ,#18 ,' ' ,#18 ,' ' ,#18 ,' ' ,#18 ,' ' ,#18 ,' ' ,#31 ,
    ' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,' ' ,#31 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#16 ,
    ' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,
    ' ' ,#16 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,'�' ,#27 ,' ' ,#16 ,
    ' ' ,#16 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#31 ,' ' ,#31 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#1  ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'.' ,#1  ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,'�' ,#32 ,' ' ,#47 ,' ' ,#47 ,
    ' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,
    '�' ,#27 ,'�' ,#27 ,'[' ,#28 ,'�' ,#158,']' ,#28 ,'�' ,#27 ,'�' ,#27 ,
    ' ' ,#16 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,'�' ,#96 ,' ' ,#96 ,'�' ,#98 ,' ' ,#47 ,' ' ,#47 ,
    ' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,
    ' ' ,#47 ,'�' ,#43 ,'�' ,#43 ,'�' ,#43 ,'�' ,#43 ,'�' ,#27 ,' ' ,#16 ,
    ' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    '.' ,#7  ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,'�' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#96 ,' ' ,#96 ,' ' ,#96 ,' ' ,#98 ,'�' ,#98 ,' ' ,#47 ,
    ' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,
    ' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#47 ,' ' ,#16 ,' ' ,#16 ,
    ' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#47 ,' ' ,#47 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,' ' ,#15 ,
    ' ' ,#96 ,' ' ,#96 ,' ' ,#96 ,' ' ,#96 ,' ' ,#96 ,' ' ,#96 ,' ' ,#96 ,
    ' ' ,#96 ,'�' ,#98 ,'�' ,#98 ,'T' ,#47 ,'A' ,#47 ,'R' ,#47 ,'G' ,#47 ,
    'E' ,#47 ,'T' ,#47 ,':' ,#47 ,' ' ,#47 ,'�' ,#98 ,'E' ,#47 ,'A' ,#47 ,
    'R' ,#31 ,'T' ,#31 ,'H' ,#31 ,' ' ,#16 ,' ' ,#16 ,' ' ,#16 ,' ' ,#16 );