program typeconvo;
uses
 crtstuff,crt;
var
 t : text;
 s : string;
begin
 assign( t, 'E:\LOGS\CONVO.TXT');
 reset(t);
 setmode(51);
 window(1,1,80,50);
 while not eof(t) do
  begin
   readln(t,s);
   cwriteln(s);
  end;
 getenter;
end.