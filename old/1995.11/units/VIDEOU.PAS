Unit VIDEOU;

{ Transcribed and modified by: Steve T. Jones                            }
{                              Indiana University at Kokomo              }
{                              2300 South Washington Street              }
{                              Kokomo, IN 46902                          }
{                              (317) 453-2000                            }
{                              KCDZ100@INDYCMS                           }
{                              June 5, 1989                              }
{                                                                        }
{ Based on O'Brien, S. K. "Turbo Pascal Advanced Programmer's Guide",    }
{            Berkeley, CA: Osborne/McGraw-Hill (1988).                   }
{                                                                        }


(***********************************************************)
Interface
(***********************************************************)

Uses DOS,
     CRT;

Type
  ScreenChars = Record
    ch : Char;
    at : Byte;
    End;

  screens = Record
    position : Array[1..25, 1..80] Of ScreenChars;
    x, y : Byte;
    End;

  ScreenType = (Mono, Color);

Var
  Stype : ScreenType;
  VidSeg : Word;

Procedure ShowScreen(Var Source, Video; Length: Word);

Procedure GetScreen(Var Video, Source; Length: Word);

Procedure XYstring(x, y: Byte; s: String; fg, bg: Byte);

Procedure ReadScr(Var S);

Procedure WriteScr(Var S);

Procedure HorStr(X, Y, Len : Byte; fg,bg: Byte; Ch : Char);

Procedure VerStr(X, Y, Len : Byte; fg,bg: Byte; Ch : Char);

Procedure Box(x1, y1, x2, y2 : Byte; fg,bg : Byte);

Procedure CenterString(y : Byte; st : String; fg, bg : Byte);

Procedure BoxString(y : Byte; st : String; fg, bg : Byte);

Procedure FillScreen(Var sc : screens; s : String;
                       x, y : Byte; fg, bg : Byte);

Procedure CursorOff;

Procedure CursorSmall;

Procedure CursorBig;

(************************************************************)
Implementation
(************************************************************)

Var
  Regs : Registers;
  Vid : Pointer;

(******************************************)

Procedure ShowScreen(Var Source, Video;
                           Length: Word);
{
This procedure writes directly to video memory without snow.
}

Begin
If Stype = Color Then
  Inline($90/$90/$90/$90/
         $1E/$55/$BA/$DA/$03/$C5/$B6/ Source /$C4/$BE/ Video /
         $8B/$8E/ Length /$FC/$AD/$89/$C5/$B4/$09/$EC/$D0/$D8/
         $72/$FB/$FA/$EC/$20/$E0/$74/$FB/$89/$E8/$AB/$FB/$E2/
         $EA/$5D/$1F)
Else
  begin
  length := length * 2;
  Move(Source,Video,Length);
  end;
End;

(**********************************************)

Procedure GetScreen(Var Video , Source;
                         Length: Word);

{
This procedure reads directly from video memory without snow.
}
Begin
If Stype = Color Then
  Inline($1E/$55/$BA/$DA/$03/$C5/$B6/ Video /$C4/$BE/ Source /
         $8B/$8E/Length /$FC/$EC/$D0/$D8/$72/$FB/$FA/$EC/$D0/
         $D8/$73/$FB/$AD/$FB/$AB/$E2/$F0/$FD/$1F)
Else
  begin
  length := length * 2;
  Move(Video,Source,Length);
  end;
End;

(********************************************)

Procedure XYstring(x, y: Byte;
                   s: String;
                   fg, bg: Byte);

{
This procedure writes string s at coordinates x:y using
foreground color fg and background color bg.
}
Var
  SA : Array [1..255] Of Record
    ch : Char;
    at : byte;
    End;

  b, i : Byte;
  offset : Word;

Begin (* XYstring *)
If (Length(s) = 0) Or
   (x > 80) Or
   (x < 1) Or
   (y > 25) Or
   (y < 1) Then Exit;

(* create a single attribute byte. *)
b := (Ord(bg) Shl 4) Or Ord(fg);

(* move thet string characters and *)

(* and attribute byte into SA.   *)

FillChar(SA,SizeOf(SA),b);
For i := 1 To length(s) Do
  SA[i].ch := s[i];

(* calculate the offset into video display memory. *)
offset := (((y-1)*80)+(x-1))*2;

Vid := Ptr(VidSeg,offset);

(* write the string to video display memory. *)
ShowScreen(SA, Vid , length(S));
End; (* XYstring *)
(*********************************************)

Procedure ReadScr(Var S);
{
This procedure reads an entire screen display into S.
}
Begin
Vid := Ptr(VidSeg,0);
GetScreen(Vid^,S,2000);
End;

(**********************************************)

Procedure WriteScr(Var S);
{
This procedure writes an entire screen display from S.
}
Begin
Vid := Ptr(VidSeg,0);
ShowScreen(S, Vid^, 2000);
End;

(************************************************)

Procedure HorStr(x, y, Len : Byte;
                 fg,bg: Byte;
                 ch : Char);
{
This procedure draws a horizontal line.
}
Var
  i : Byte;
Begin
For i := 1 To Len Do
  Begin
  XYstring(x,y,ch,fg,bg);
  x := x + 1;
  End;
End;

(*************************************************)

Procedure VerStr(x, y, Len : Byte;
                 fg,bg: Byte;
                 ch : Char);
{
This procedure draws a vertical line.
} 
Var
  i : Byte;
Begin
  Begin
  XYstring(x,y,ch,fg,bg);
  y := y + 1;
  End;
End;

(************************************************)

Procedure Box(x1, y1, x2, y2 : Byte;
              fg,bg : Byte);
{
This procedure draws a box with upper left corner at x1:y1 and
lower right corner at x2:y2 with foreground color fg and
background color bg.
}
Begin
If (x1 < 1) Or
   (x2 > 80) Or
   (y1 < 1) Or
   (y2 > 25) Or
   ((x2-x1) < 2) Or
   ((y2-y1) < 2) Then exit;

HorStr(x1, y1, 1, fg, bg, #201);
HorStr(x2, y1, 1, fg, bg, #187);
HorStr(x1, y2, 1, fg, bg, #200);
HorStr(x2, y2, 1, fg, bg, #188);
VerStr(x1, y1+1, y2-y1-1, fg, bg, #186);
VerStr(x2, y1+1, y2-y1-1, fg, bg, #186);
HorStr(x1+1, y1, x2-x1-1, fg, bg, #205);
HorStr(x1+1, y2, x2-x1-1, fg, bg, #205);
End;

(***********************************************)

Procedure CenterString(y : Byte;
                 st : String;
                 fg,
                 bg : Byte);
{
This procedure displays string st centered on line y using 
foreground
color fg and background color bg.
}
Var
  x : Byte;

Begin (* Center *)
x := (40-(Length(st) Div 2));
XYstring(x, y, st, fg, bg);
End; (* Center *)

(***********************************************)

Procedure BoxString(y : Byte;
                    st : String;
                    fg, bg : Byte);
{
This procedure displays string st centered on line y surrounded
by a box, all displayed in foreground color fg and background
color bg.
}
Var
  x1, y1, x2, y2 : Byte;

Begin
CenterString(y, St, fg, bg);
x1 := 40-(Length(st) Div 2)-2;
x2 := x1+Length(st)+3;
y1 := y-1;
y2 := y+1;
Box(x1, y1, x2, y2,fg,bg);
End;

(***************************************************)

Procedure FillScreen(Var sc : screens;
                      s : String;
                      x, y : Byte;
                      fg,bg : Byte);
{
FillScreen writes string s to logical screen sc at coordinates
x:y in foreground color fg and background color bg.
}
Var
  i,atx : Byte;
Begin
atx := fg Or (bg Shl 4);

For i := 1 To Length(s) Do
  Begin
  sc.position[y, x].ch := s[i];
  sc.position[y, x].at := atx;
  x := x+1;
  If x > 80 Then
    Begin
    x := 1;
    y := y+1;
    If y > 25 Then
      Exit;
    End;
  End;
End;

(***********************************************)

Procedure CursorOff;
{
Turns cursor off.
}
Begin
FillChar(Regs,sizeof(Regs),0);

With Regs Do
  Begin
  AH := $01;
  CH := $20;
  CL := $20;
  End;

Intr($10, Regs);
End;

(**********************************************)

Procedure CursorSmall;
{
Turns cursor on in small size.
}
Begin
FillChar(Regs,sizeof(Regs),0);
regs.AH := $01;

  Case stype Of
  Mono :
    Begin
    With Regs Do
      begin
      CH := 12;
      CL := 13;
      End;
    End;

  Color :
    Begin
    With Regs Do 
      Begin
      CH := 6;
      CL := 7;
      End;
    End;
  End; (* Of Case *)

Intr($10, Regs);
End;

(******************************************)

Procedure CursorBig;
{
Turns cursor on in large size.
}
Begin
FillChar(Regs,sizeof(Regs),0);
regs.AH := 1;
regs.CH := 0;

  Case stype Of
  Mono  : regs.CL := 13;
  Color : regs.CL := 7;
  End;

Intr($10, Regs);
End;

(******************************************)

Begin
{
Initialization part of unit.  Determines the type of screen
in use and set Stype and VidSeg appropriately.
}
FillChar(regs,sizeof(regs),0);
Regs.AH := $0F;

Intr($10,Regs);
If Regs.AL = 7 Then
  Begin
  Stype := Mono;
  VidSeg := $B000;
  End
Else
  Begin
  Stype := Color;
  VidSeg := $B800;
  End;
End. (* Of Unit *)
