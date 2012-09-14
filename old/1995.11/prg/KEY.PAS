uses Crt;
var
  Ch : Char;
begin
   WriteLn('Press a key');
   Ch := ReadKey;
   if Ch = #0 then
     begin
     Ch := ReadKey;
     WriteLn('You hit special key number ', Ord(Ch));
     end
   else
     WriteLn('You hit a key with ASCII ',
             'code ',Ord(Ch));
end.
