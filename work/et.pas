Program ElType;
uses crt,CrtStuff,Dos;

Var B     : byte;
    S     : String;
    T     : Text;

Procedure Title;
 Begin
   WriteLn; WriteLn;
   cWriteln('|rε|R└|Y┼|GY|BP|M≡ |Wv2|Y.|W0 |G(|Wc|G)|W1993 ' + Silverware + '|W all rights reserved.');
 End;


Procedure Ending;
  begin
    WriteLn;
    cwriteln( 'Thanks for using '+ Silverware );
  end;

Procedure NoFile;
 Begin
  cwriteln('|!K|rE|RR|YR|RO|rR|!k|Y: |WYou must specify a file to type|w...');
  Halt(0);
 End;

Procedure FileError;
  Begin
    cwrite('|!K|rE|RR|YR|RO|rR|!k|Y: ');
    cWriteLn('|W The file|w, |B"|W'+Paramstr(1)+'|B"|Wwasn|w''|Wt found|w...');
    WriteLn;
    Halt(0);
  End;

Procedure Getfile;
  Var DirInfo : Searchrec;
      Str     : String;
  Begin
     Str := Paramstr(1);
     Findfirst(Str,Anyfile,DirInfo);
     If DosError <> 0 then FileError;
     Assign(T,Paramstr(1));
     Reset(T);
  End;

Procedure TypeFile;
  begin
     WriteLn;
     Repeat
       For B := 0 to 21 do
        If not EOF(T) then
         begin
           Readln(T,S);
           cwriteLn(S);
         end;
       HitAKey;
     Until Eof(T);
  end;

begin
 Title;
 If Paramcount < 1 then nofile else GetFile;
 TypeFile;
 Ending;
end.