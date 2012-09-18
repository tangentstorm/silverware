Unit CrtStuff;
Interface

 WipeOut  = $00;
 SlidRit  = $01;
 BlueLine = $19B3;

Procedure GetEnter;
Function  EnterPressed : BOOLEAN;
Procedure BoNKxy( a, b : byte; s : string );
Procedure Rectangle(a,b,x,y, c : byte);
Procedure Button(A1,B1,A2,B2 : Byte);
Procedure Bar(a,b,x,y,at: byte);
Procedure Clear ( x1,y1,x2,y2,clwhich: byte; back: word);
(*Procedure Scrape( x1,y1,x2,y2,clwhich: byte; back : Screentype );*)
Procedure NoCursor;
Procedure RestCursor;
Procedure CursorShape(Top,Bottom : Byte);
Procedure Center( x1, x2, y, c : byte; S : String );
Procedure SplitFileName(F : string;Var Name, Ext : String);

Procedure SilverWare;

Procedure Elwrite(S: string);
Procedure ElWriteLn(S: string);
Procedure SlingXY(a,b : byte;S:string;var S2:screentype);


Procedure SlideScreenOff(OffWhat : ScreenType);



Function N2S(I:Integer) : String;
Function S2N(S:String)  : Integer;
Function Wrd2Str(W : Word) : String;

Function TodaysDate : String;


Function CurrentDir : String;

Implementation


Var
   CursorTop, CursorBottom : Byte;


Procedure GetEnter;
   var Ch : Char;
   begin
      While KeyPressed do Ch := Readkey;
      Repeat Ch := Readkey until Ch = #13;
   end;



Function EnterPressed : Boolean;
   var
      Ch : Char;
   Begin
      Ch := ' ';
      If KeyPressed then ch := Readkey;
      EnterPressed := Ch = #13;
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
      4: For count := x1-1 to x2-1 do
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


Procedure Center( x1, x2, y, c : byte; S : String );
 Begin
    colorxy( 1, Y, c, '                                                                                ');
    colorxy( 41 - length(s) div 2, y, c, s );
 End;

Function N2S( I : Integer):String;
  Var
    S : String;
  Begin
    Str(I,S);
    N2S := S;
  End;

Function S2N( S: String ):Integer;
  Var
    I,D : Integer;
  Begin
    Val(S,I,D);
    S2N := I;
  End;

Function Wrd2Str(W : Word) : String;
  Var
    S : String;
  Begin
    Str(W,S);
    Wrd2Str := S;
  End;


Procedure BonkXY( a, b : byte; s: string );
 var
   counter : byte;
   c : byte;
 begin
   s := dnstr(s);
   for counter := 1 to Length(S) do
    begin
      case S[counter] of
       'b'..'d', 'f'..'h',
       'j'..'n', 'p'..'t',
       'v'..'x', 'z'  : begin
                         c := $0F;
                         s[ counter ] := Upcase( s[counter] )
                        end;
       'a','e','i','o','u', 'y' : c := $0A;
       '!'..'/' : c := $0E;
       '[',']','(',')','{','}','<','>','"' : c := $09;
       else c := $09;
      end;
      colorxy( a + counter - 1, b, c, s[counter] );
    end;
 end;



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


Function CurrentDir;
   Var
      s : string;
   Begin
      GetDir(0,S);
      Currentdir := s;
   End;

{ $I UNCRUNCH}

Procedure ANSI(var Addr1; A, B, BlkLen : Integer);
  Begin
  {   UNCRUNCH(Addr1,Screen[ (A * 2) + (B * 160) - 162 ], BlkLen); }
  End;


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

Procedure SlideScreen( ss : word );
var
  count, count2 : byte;
  Num   : integer;
begin
  count := 25;
  repeat
    Num := (Count-1)*160;
    Move(Screen[Num],Screen[(count*160)],Sizeof(screen)-(count*160));
    for count2 := 0 to 79 do
      Move(ss,Screen[Num + (count2 * 2)],sizeof(ss));
    dec(count,1);
    delay(0);
  until count = 0;
end;


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
       '∞'..'ﬂ' : TextAttr := $04;
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

Procedure StWriteLn(S: STring);
 begin
   StWRite(S);
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

Function YesOrNo : Boolean;
  var
    ch : char;
  begin
    repeat Ch := Upcase(Readkey) until (Ch = 'Y') or (ch = 'N');
    YesOrNo := No;
    If Ch = 'Y' Then YesOrNo := Yes;
  end;


procedure metalbar( a1, b1, a2, b2 : byte );
 var
  i, w  : byte;
  z : string;
 begin
  w := a2 - a1 - 1;
  z := chntimes( ' ', w );
  cwritexy( a1, b1, '|W~w€' + ( 'ﬂ', w ) + '|K€');
  for i := 1 to b2 - b1 - 1 do
   begin
    colorxy( a1, b1 + i, $7F ,'€' + z );
    colorxy( a2, b1 + i, $78, '€' );
   end;
  cwritexy( a1, b2, '|W~w€|K' + zcharstr( '‹', w ) + '|K€');
  greyshadow(a1,b1,a2,b2);
 end;

procedure metalbox( a1, b1, a2, b2 : byte );
 var
  i, w  : byte;
 begin
  w := a2 - a1 - 1;
  cwritexy( a1, b1, '|W~w€' + chntimes( 'ﬂ', w ) + '|K€');
  for i := 1 to b2 - b1 - 1 do
   begin
    colorxy( a1, b1 + i, $7F ,'€' );
    colorxy( a2, b1 + i, $78, '€' );
   end;
  cwritexy( a1, b2, '|W~w€|K' + chntimes( '‹', w ) + '|K€');
 end;


End.