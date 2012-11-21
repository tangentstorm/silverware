Unit SSWStuff;

INTERFACE Uses cw,Crt,CrtStuff,Dos,SSWSound,fx;

Type Input = Object
       x,y,tcol,ccol,len : byte;
       crs : char;
       s : string;
       soundon : boolean;
       Procedure Init(a,b,lngth,tc,cc : byte; cursr: char);
       Procedure BackSpace;
       Function Get : String;
     end;
     EndUser = Object
       Accs : byte;
       Name : String[14];
       Procedure Get;
       Function GetName : string;
     end;
Const
 Back  : word = $19B3;
 Back2 : word = $10B3;
Var
 User : EndUser;
Function RepeatingStuff : Boolean;

IMPLEMENTATION

{ $I SSWStuf1.Pic}

Procedure Input.Init(a,b,lngth,tc,cc : byte; cursr: char);
  begin
    x := a;
    y := b;
    len := lngth;
    tcol := tc;
    ccol := cc;
    crs  := cursr;
    s := '';
  end;

Procedure Input.BackSpace;
  begin
    delete(s,length(s),1);
    colorxy(x+succ(length(s)),y,tcol,' ');
    colorxy(x+length(s),y,ccol,crs);
  end;

Function Input.Get : string;
  var
    ch : char;
    ex : boolean;
  begin
    ex := false;
    repeat
     colorxy(x,y,tcol,s);
     if length(s) < len then colorxy(x+length(s),y,ccol,crs);
     ch := readkey;
     if soundon then Spkr.click;
     case ch of
       #13: begin ex := true; get := s; end;
        #8: BackSpace;
        ^X: Repeat BackSpace; spkr.click; until Length(s) = 0;
        #0: ch := readkey;
     else
       begin
         s := s + ch;
         if length(s) > len then s[0] := char(len);
       end;
     end;
    until ex;
  end;

Procedure EndUser.Get;
 var
   NomDeUser : Input;
 begin
   Spkr.Pop;
  (* ANSI(UserIdThing,25,18,UserIdThing_Length); *)
   NomDeUser.Init(37,19,15,$0A,$0E,'þ');
   Name := NomDeUser.Get;
 end;

  Function Enduser.GetName : String;
  begin
    Getname := Name;
  end;

Procedure Shade(a,b,h,v : byte);
 var
  c : byte;
 begin
   for c := (a+1) to (h+1) do
      if Screen[(v*160)+(2*(c))] = $B3 then
         move(Back2,Screen[(v*160)+(2*(c))],SizeOf(Back2));
   for c := (b) to (v) do
      if Screen[(c*160)+(2*(h))] = $B3 then
         move(Back2,Screen[(c*160)+(2*(h))],SizeOf(Back2));
   for c := (b) to (v) do
      if Screen[(c*160)+(2*(h+1))] = $B3 then
         move(Back2,Screen[(c*160)+(2*(h+1))],SizeOf(Back2));
 end;


Function RepeatingStuff : Boolean;
  begin
    RepeatingStuff := True;
  end;


End.