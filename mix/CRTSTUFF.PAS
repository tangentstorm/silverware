Unit CrtStuff;
Interface
Var
   Count : Integer;
Const
   Enter = #17+'ды';
   Open = 1;   {spread out vertically from center line}
   PullIn =2;  {Pull in vertically to center line}
   Spray =3;   {Spray... Needs to be fixed}
   ScrollDown =4; {Scrolls Down}
   ScrollUp = 5;  {Scrolls Up}
   CloseIn = 6;   {Wipes from top and bottom, vertically}
   WipeOut =7;    {wipes from center, horizontally}
   SlideRight = 8; {scrolls right}
   Yes = TRUE;
   No = FALSE;
   Blank : Word = $0F20;
   type ScreenType = array [0..3999] of Byte;
   var Screen : ScreenType absolute $B800:$0000;
       hour   : byte absolute $0000:$046E;
       minsec : word absolute $0000:$046D;

Procedure SetUpCrt;
Procedure Get_Enter;
Function  EnterPressed : BOOLEAN;
Procedure BigWrite( ch,ch2 : Char );
Procedure OutTextXY(a,b : integer; s: string);
Procedure ColorXY(a,b,c: byte; s: string);
Procedure BigXY(a,b : integer; c: string; ch1,ch2 : char; at1,at2 : Byte);
Procedure Rectangle(a,b,x,y : integer);
Procedure Shadow(X1,Y1,X2,Y2,Attr : Byte);
Procedure Shdow2(X1,Y1,X2,Y2,Attr : Byte);
Procedure Button(A1,B1,A2,B2 : Byte);
Procedure Bar(A,B,X,Y: Integer);
Procedure Cls(ClsWhich : byte);
Procedure Clear(x1,y1,x2,y2,clwhich: byte; back: word);
Procedure BorderCol( Col : word );
Procedure NoCursor;
Procedure RestCursor;
Procedure CursorShape(Top,Bottom : Byte);
Procedure Beep;
Procedure Center( Y : Integer; S : String );
Procedure SplitFileName(F : string;Var Name, Ext : String);
Procedure ClrLn(Y :Byte);
Procedure ANSI(var Addr1; A, B, BlkLen : Integer);
Procedure FillScreen(ook:word); {ATTR then CHAR}
Procedure SlideScreenOff(OffWhat : ScreenType);
Procedure ElDude;
Procedure Elwrite(S: string);
Procedure ElWriteLn(S: string);
Procedure SlingXY(a,b : byte;S:string;var S2:screentype);
Procedure HitAKey;
Procedure Dec2(Var From:byte; amt, min : byte);
Procedure Inc2(Var Goesto : byte;amt,max : byte);
Function  Get_Input(Prompt : String) : String;
Function  N2S(I:Integer) : String;
Function  S2N(S:String)  : Integer;
Function  Wrd2Str(W : Word) : String;
Function  DnCase(Ch : Char) : Char;
Function TodaysDate : String;
Function UpStr(S: String)   : String;
Function DnStr(S: String)   : String;
Function WordInString(S : String; Index : Byte) : String;
Function YesOrNo : Boolean;
Function CurrentDir : String;

Implementation

Uses Crt, Dos;

Var
   CursorTop, CursorBottom : Byte;

Procedure SetUpCrt;
   Begin
      NoCursor;
      TextAttr := $0F;
      ClrScr;
   End;

Procedure BigWrite( ch,ch2 : Char ); { P.428 of MASTERING TURBO PASCAL 5.5 }
   Const
      Pattern = $FA6E;
      Width   = $73;
   Var
      x, y, segment, offset, i, j : Word;
      EightBits : Byte;
   Begin
      If WhereX >= Width
         Then for i := 1 to 9 do writeln;
      x := WhereX; Y:=WhereY;
      GotoXy(x,y);
      Segment := $F000;
      Offset := Pattern + ( Ord(ch) * 8 );
      For i := 0 to 7 do
      Begin
         EightBits := Mem[Segment : Offset + i ];
         For j := 0 to 7 do
            Begin
               If EightBits AND $80 <> 0
                  Then Write(  ch2  )
                  Else Gotoxy( WhereX+1, WhereY );
               EightBits := ( EightBits SHL 1 ) Mod 256;
            End;
         GotoXY( x, WhereY + 1 );
      End;
      GotoXY( X+9, Y );
   End;

Procedure Get_Enter;
   var Ch : Char;
   begin
      While KeyPressed do Ch := Readkey;
      Repeat Ch := Readkey until Ch = #13;
   end;

Procedure Button(A1,B1,A2,B2 : byte);
   Begin
      TextAttr := $70;
      Bar(A1,B1,A2,B2);
      TextAttr := $7F;
      For Count := A1 to A2-1 do OutTextXY(Count,B1,'д');
      For Count := B1 to B2-1 do OutTextXY(A1,Count,'Ё');
      TextAttr := $7F;
      OutTextXY(A1,B1,'з');
      OutTextXY(A1,b2,'ю');
   End;


Function EnterPressed : Boolean;
   var
      Ch : Char;
   Begin
      Ch := ' ';
      If KeyPressed then ch := Readkey;
      EnterPressed := Ch = #13;
   End;

Procedure OutTextXY(a,b : integer; s: string);
   Var
      Count : Byte;
   Begin
      For Count := 1 to Length(s) do
       Screen[(2*(A+Count-2))+((B-1)*160)] := Byte(s[count]);
   End;

Procedure ColorXY(a,b,c :byte; s: string);
   Var
     count : word;
   Begin
     for count := 1 to length(s) do
     begin
       Screen[(2*(A+Count-2))+((B-1)*160)  ] := Byte(s[count]);
       Screen[(2*(A+Count-2))+((B-1)*160)+1] := c;
     end;
   End;


Function Get_Input( Prompt : String ) : String;
   Var
      Ch                  : Char;
      Response,
      blank               : String;
      ExitLoop            : Boolean;
      X, X2, Y, Y2, K, C  : Integer;
   Begin;
      C := TextAttr;
      Response := '';
      WriteLn; WriteLn; WriteLn; WriteLn; WriteLn; GotoXy(WhereX,WhereY-4);
      X2:= WhereX;
      Y := WhereY;
      Write('           ');
      X := WhereX;
      TextBackGround(2);
      Bar(X,Y,X+Length(Prompt)+1,Y+3);
      OutTextXY(WhereX+1,WhereY+1,Prompt);
      TextBackGround(7);
      For K := 1 to Length(Prompt) do
      OutTextXY(K+X,Y+2,' ');
      Repeat
         Begin
            GotoXY(X+1+Length(Response),Y+2);
            Ch := Readkey;
            ExitLoop := False;
            Case Ch of
               ' '..'~' : Begin;
                             If Length(Response) < Length(Prompt) then begin
                             OutTextXY(X+1+Length(Response),Y+2,Ch);
                             Response := Response + Ch; End
                             Else Beep;
                          End;
               #8  : Begin
                        Delete(Response,Length(Response),1);
                        OutTextXY(X+1+Length(Response),Y+2,' ');
                     End;
               #13 : ExitLoop := True;
               #27 : Begin
                        TextAttr := $07;
                        OutTextXY(x+1,y+2,Response);
                        Response := '';
                        ExitLoop := True; end;
            Else Beep;
            End;
         End;
      Until ExitLoop;
      Get_Input := Response;
      GotoXY(X2,Y);
      TextAttr := C;
   End;


Procedure BigXY(a,b : integer; c: string; ch1,ch2 : Char;At1,at2 : byte);
   Var X,Y,Atr,count : Byte;
   Begin
      X := WhereX;
      Y := WhereY;
      Atr := TextAttr;
      GotoXY( A , B );
      TextAttr := at1;
      For Count := 1 to Length(c) do BigWrite(c[Count],ch1);
      GotoXY(A+1,B);
      TextAttr := at2;
      For Count := 1 to Length(c) do BigWrite(c[Count],ch2);
      GotoXY(X,Y);
      TextAttr := Atr;
   End;

Procedure Beep;
   Begin
      Write(#7);
   End;

Procedure Rectangle(a,b,x,y : integer);
   Var C2 : integer;
   Begin;
      For Count := A+1 to X-1 do
         Begin
            OutTextXY(Count,B,'д');
            OutTextXY(Count,Y,'д');
         End;
      For Count := B+1 to Y-1 do
         Begin
            OutTextXY(A,Count,'Ё');
            OutTextXY(X,Count,'Ё');
         End;
      OutTextXY(A,B,'з');
      OutTextXY(A,Y,'ю');
      OutTextXY(X,B,'©');
      OutTextXY(X,Y,'ы');
   End;


Procedure Shadow(X1,Y1,X2,Y2,Attr : Byte);
   Var
      C,
      A : Byte;
   Begin
      A := TextAttr;
      TextAttr := Attr;
      For C := Y1 to Y2-1 do OutTextXY(X2+1,C+1,'ш');
      For C := X1 to X2 do OutTextXY(C+1,Y2+1,'ъ');
      TextAttr := A;
   End;

Procedure Shdow2(X1,Y1,X2,Y2,Attr : Byte);
   Var
      C,
      A : Byte;
   Begin
      A := TextAttr;
      TextAttr := Attr;
      OutTextXY(X2+1,Y1,'ъ');
      For C := Y1 to Y2-1 do OutTextXY(X2+1,C+1,' ');
      For C := X1 to X2 do OutTextXY(C+1,Y2+1,'э');
      TextAttr := A;
   End;

Procedure Cls(ClsWhich: byte);
   Var
      Count,Count2,Count3 : Integer;
   Begin;
      GotoXY(1,1);
      Case CLsWhich of
      Open : Begin
                For Count := 1 to 13 do
                   Begin
                      GotoXY(1,1);
                      DelLine;
                      GotoXY(1,Hi(WindMax)Div 2);
                      InsLine;
                      InsLine;
                      Delay(50);
                   End;
             End;
   PullIn : Begin
            For Count := 1 to 15 do
              Begin
                GotoXY(1,12);
                DelLine;
                GotoXY(1,1);
                InsLine;
                GotoXY(1,12);
                DelLine;
                Delay(25);
              End;
            End;
     Spray : For Count := 1 to 11000 do
                OutTextXY(Random(80),Random(25)+1,' ');
     ScrollDown  : For Count := 1 to 25 do
                Begin;
                   InsLine;
                   Delay(50);
                End;
     ScrollUp : For Count := 1 to 25 do
                Begin;
                   GotoXY(1,1);
                   Delline;
                   Delay(50);
                End;
     CloseIN : For Count := 1 to 13 do
                Begin
                   GotoXY(1,Count);
                   ClrEol;
                   GotoXY(1,26-Count);
                   ClrEol;
                   Delay(50);
                End;
      WipeOut : For Count := 0 to 40 do
                Begin
                   For Count2 := 0 to 26 do
                      Begin
                         Move(blank,Screen[2*(40+Count)+(160*Count2)],sizeof(blank));
                         Move(blank,Screen[2*(40-Count)+(160*Count2)],sizeof(blank));
                      End;
                   Delay(10);
                End;
      End;
   End;

Procedure Clear(x1,y1,x2,y2,clwhich: byte; back: word);
  Var
    Count, Count2 : byte;
    generic : word;
  Begin
    Case clwhich of
      WipeOut : For Count := 1 to (x2-x1) do
        Begin
          generic := (x1+x2) div 2;
          For Count2 := y1+1 to y2+1 do
            Begin
              Move(back,Screen[2*(generic+Count)+(160*Count2)],sizeof(back));
              Move(back,Screen[2*(generic-Count)+(160*Count2)],sizeof(back));
            End;
           Delay(10);
        end;
      SlideRight: For count := x1-1 to x2-1 do
        begin
          for count2 := y1-1 to y2-1 do
            begin
              Generic := (2*count)+(160*count2);
              Move(Screen[Generic],Screen[Generic+2],2*(x2-count-1));
              Move(back,Screen[Generic],sizeof(back));
            end;
          delay(1);
        end;
    end;
  End;

Procedure NoCursor;
   Var regs : registers;
   Begin
      regs.AH := $03;
      regs.BH := $00;
      intr($10,regs);
      CursorTop    :=regs.CH;
      CursorBottom :=regs.CL;
      regs.AH := $01;
      regs.CH := $FF;
      regs.CL := $FF;
      Intr($10,regs);
   End;

Procedure RestCursor;
   Var regs : registers;
   Begin
      regs.AH := $01;
      regs.CH := CursorTop;
      regs.CL := CursorBottom;
      Intr($10,regs);
   End;

Procedure CursorShape(Top, Bottom : Byte);
   Var Regs : Registers;
   Begin
      Regs.AH := $01;
      Regs.CH := Top;
      Regs.CL := Bottom;
      Intr($10,Regs);
   End;

Procedure BorderCol( Col : Word );
   Var regs : registers;
   Begin
      regs.AH := $10;
      regs.AL := $01;
      regs.BH := col;
      Intr($10,regs);
   End;

Procedure Center( Y : Integer; S: String );
   Begin
      GotoXY(1,Y);
      ClrEol;
      Write( S : (Lo(WindMax) div 2)+ ( Length(S) Div 2 ));
   End;

   Function N2S( I : Integer):String;
      Var S : String;
      Begin
         Str(I,S);
         N2S := S;
      End;

   Function S2N( S: String ):Integer;
      Var I,D : Integer;
      Begin
        Val(S,I,D);
        S2N := I;
      End;

   Function Wrd2Str(W : Word) : String;
      Var S : String;
      Begin
         Str(W,S);
         Wrd2Str := S;
      End;

Procedure Bar(a,b,x,y: Integer);
   Var
     cx,cy : byte;
     at : byte;
   Begin
      at := (TextAttr shl 8) + (Blank AND $00FF);
      Rectangle(a,b,x,y);
      For cy := b to y-2 do
        For cx := a to x-2 do
          Move(at, Screen[(cx*2)+(cy*160)], sizeof(at));
   End;


Procedure ClrLn(Y:Byte);
  Var
    C,C2 : Byte;
  Begin
      C2 := Lo(WindMax);
      GotoXY(Y,C2-1);
      ClrEol;
      For C := 1 to (C2 div 2) do
        begin
          OutTextXY(C,Y,' ');
          OutTextXY(C2-C,Y,' ');
          Delay(30);
        end;
  End;


Function DnCase(Ch:Char):Char;
   Begin
      If ('A' <= ch ) AND (ch <= 'Z')
         THEN Dncase := Chr(Ord(ch)+32)
         ELSE DnCase := Ch;
   End;

Function TodaysDate : String;
   Var
      Temp : String;
      Year,Month,Day,DayOfWeek : Word;
   Begin
      GetDate(Year,Month,Day,DayOfWeek);
      TodaysDate := Wrd2Str(Month)+'/'+Wrd2Str(Day)+'/'+Wrd2Str(Year);
   End;

Function UpStr(S : String) : String;
   Var
      Count : Byte;
   Begin
      For Count := 1 to Length(s) do S[Count] := UpCase(S[count]);
      UpStr := S;
   End;

Function DnStr(S : String) : String;
   Var
      Count : Byte;
   Begin
      For Count := 1 to Length(s) do S[Count] := DnCase(S[count]);
      DnStr := S;
   End;

Procedure SplitFileName(F : string;Var Name, Ext : String);
   Var
      i,j : byte;
   Begin
      Name := '';
      Ext  := '';
      i := Pos('.',F);
      Name := Copy(f,1,i-1);
      for j := i to length(F) do ext[j-i] := F[j];
   End;

Function WordInString(S : String; Index:  Byte) : String;
   Var
      C,C2,j : Byte;
   Begin
      While S[1] = ' ' do Delete(s,1,1);
      S := S + ' ';
      If Pos('  ',S) > 0 then delete(s,Pos('  ',s),1);
      for c := 1 to Index -1 do
         begin
            for c2 := 1 to Pos(' ',s) do delete(s,1,1);
         end;
      If Pos(' ',s) > 0 then j := Pos(' ',s) else j := Length(s);
      WordInString := Copy(s,1,j);
   End;

Function CurrentDir;
   Var
      s : string;
   Begin
      GetDir(0,S);
      Currentdir := s;
   End;

{$I UNCRUNCH}

Procedure ANSI(var Addr1; A, B, BlkLen : Integer);
  Begin
     UNCRUNCH(Addr1,Screen[ (A * 2) + (B * 160) - 162 ], BlkLen);
  End;

procedure FillScreen(ook:word); {ATTR then CHAR}
var
  count : word;
begin
 For count := 0 to sizeof(screen) do Move(ook,Screen[count*2], sizeOf(ook));
end;

Procedure SlideScreenOff(OffWhat : ScreenType);
var
  count : byte;
  Num   : integer;
begin
  count := 1;
  repeat
    Num := (Count-1)*160;
    Move(Screen[Num],Screen[(count*160)],Sizeof(screen)-(count*160));
    Move(OffWhat[Num],Screen[Num],160);
    inc(count,1);
    delay(0);
  until count = 26;
end;




Procedure Eldude;
  Begin
    TextAttr := $04; Write('Н');
    TextAttr := $0C; Write('ю');
    TextAttr := $0E; Write('>');
    TextAttr := $0A; Write('U');
    TextAttr := $09; Write('К');
    TextAttr := $0D; Write('П');
  End;

var punk : boolean;
Procedure ElWrite(S: string);
 var
   counter : byte;
 begin
   for counter := 1 to Length(S) do
    begin
      case S[counter] of
       'a'..'z','A'..'Z','0'..'9',' ' : TextAttr := $0F;
       '[',']','(',')','{','}','<','>','"' : Textattr := $09;
       '╟'..'ъ' : TextAttr := $04;
       else begin
              If punk then TextAttr := $0E
              else TextAttr := $0A;
              Punk := NOT punk;
            end;
      end;
      write(s[counter]);
    end;
 end;

Procedure ElWriteLn(S: String);
 begin
   ElWrite(S);
   WriteLn;
 end;

Procedure SlingXY(a,b:byte;S:string;var S2:screentype);
 var
  count: byte;
  chatr: word;
 begin
   for count := 1 to Length(S) do
    begin
      case S[count] of
       'a'..'z','A'..'Z','0'..'9',' ' : Chatr := $0F00;
       else Chatr := $0700;
       end;
       Chatr := Chatr + byte(s[count]);
       Move(Chatr,S2[(2*(a+count-2))+((b-1)*160)],SizeOf(chatr));
    end;
 end;

Procedure HitAKey;
  var
    ch : char;
  begin
    TextAttr := Red; Write('(');
    TextAttr := LightRed; Write('(');
    TextAttr := Yellow; Write('(');
    TextAttr := White; Write(' Hit a Key');
    TextAttr := LightGreen; Write('! ');
    TextAttr := Yellow; Write(')');
    TextAttr := LightRed; Write(')');
    TextAttr := Red; Write(')');
    While Keypressed do Ch := Readkey;
    Ch := Readkey;
    GotoXY(1,WhereY);
    ClrEol;
    TextAttr := $0F;
  end;

Function YesOrNo : Boolean;
  var
    ch : char;
  begin
    repeat Ch := Upcase(Readkey) until (Ch = 'Y') or (ch = 'N');
    YesOrNo := No;
    If Ch = 'Y' Then YesOrNo := Yes;
  end;

Procedure Dec2(Var From:byte; amt, min : byte);
begin
 Dec(from,amt);
 if from < min then from := min;
end;

Procedure Inc2(Var Goesto : byte;amt,max : byte);
begin
  Inc(GoesTo,Amt);
  if GoesTo > max then goesto := Max;
end;


End.