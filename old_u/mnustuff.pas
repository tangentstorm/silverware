Unit MnuStuff;
Interface

 Type Matrix = Array[0..0] of byte;
      MenuPtr = ^MenuObj;
      MenuObj = Object
        Next, Last : MenuPtr;
        Name : String;
        Value : Byte;
      end;
      Menu = Object
        Top,High:MenuPtr;
        Background : ^Matrix;
        X,Y,Width, Height,BCol,MCol,HCol : byte;
        Constructor Init(a,b,bc,mc,hc : byte);
        Procedure DrawTop; virtual;
        Procedure DrawAChoice(Index:MenuPtr; i : byte); virtual;
        Procedure DrawMiddle;
        Procedure DrawBottom; virtual;
        Function StringFix(s : string): string;
        Procedure Add(s : string;v: byte);
        Procedure Show;
        Function Get : byte;
      end;

Implementation
uses Crt,CrtStuff;

 Constructor Menu.Init(a,b,bc,mc,hc : byte);
   begin
     x := a;
     y := b;
     height := 1;
     width  := 1;
     BCol := bc;
     MCol := mc;
     HCol := hc;
     New(Top);
     New(High);
     Top^.Last := Top;
     Top^.Next := Top;
     Top^.Name := '-=>TOP<=-';
     High := Top;
   end;

 Procedure Menu.DrawTop;
   var
     c : byte;
   begin
     ColorXY(x,y,BCol,'Ú');
     for c := 1 to width-1 do ColorXY(x+c,y,BCol,'Ä');
     ColorXY(x+Width,y,BCol,'¿');
   end;

 Procedure Menu.DrawAChoice(Index:MenuPtr; i : byte);
   Begin
     ColorXY( x, y+i, BCol, '³');
     if Index = High then
       ColorXY( x+1, y+i, HCol, Index^.Name )
     else
       ColorXY( x+1, y+i, MCol, Index^.Name );
     ColorXY( x+width, y+i, BCol, '³' );
   End;

 Procedure Menu.DrawMiddle;
   var
     Index : MenuPtr;
     i     : byte;
   begin
     i := 1;
     New(Index);
     Index := Top^.Next;
     While Index <> top do
       begin
         DrawAChoice(Index,i);
         Index := Index^.Next;
         inc2(i,1,25);
       end;
   end;

 Procedure Menu.DrawBottom;
   var
      c : byte;
   begin
     ColorXY(x,y+height,BCol,'À');
     for c := 1 to width-1 do ColorXY(x+c,y+height,BCol,'Ä');
     ColorXY(x+Width,y+height,BCol,'Ù');
   end;

 Function Menu.StringFix(s : string): string;
   begin
     If length(s) > (width - 2) then Width := (length(s) + 2);
     While NOT (length(s) > (Width - 2)) do s := s + ' ';
     StringFix := S;
   end;

 Procedure Menu.Add(s: string;v: byte);
   var
      newchoice : menuptr;
   begin
     New(NewChoice);
     New(NewChoice^.Next);
     New(NewChoice^.Last);
     NewChoice^.Next := Top;
     NewChoice^.Last := Top^.Last;
     NewChoice^.Name := StringFix(S);
     NewChoice^.Value := V;
     Top^.Last^.Next := NewChoice;
     Top^.Last := NewChoice;
     If Top^.Next = Top then Top^.Next := NewChoice;
     inc(height,1);
     High := Top^.Next;
   end;

 Procedure Menu.Show;
   begin
     DrawTop;
     DrawMiddle;
     DrawBottom;
   end;

 Function Menu.Get : byte;
   var
     ch: char;
     EndLoop : boolean;
   begin
     EndLoop := False;
     Show;
     Repeat
       ch := readkey;
       Case Ch of
         #0: Case Readkey of
               #72,{up}#75{rt} : begin;
                                   High := High^.Last;
                                   If High = Top then High := Top^.Last;
                                   Show;
                                 end;
               #80,{dn}#77{lf} : begin;
                                   High := High^.Next;
                                   If High = Top then High := Top^.Next;
                                   Show;
                                 end;
               end;
         #13: EndLoop := True;
         end;
     Until EndLoop;
     Get := High^.Value;
   end;

End.