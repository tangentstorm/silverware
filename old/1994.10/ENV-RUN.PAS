{$M $2000,0,0 }  {4K stack, no heap}
program env_run;
uses Dos, crtstuff, zokstuff;
var
  I: Integer;
  is : string[79];
  new : zinput;
  t : text;
begin
 if paramcount = 0 then
  begin
   cwriteln('|!k|W');
   cwriteln('ENV |B(|WC|B)|W1993 '+silverware );
   for i := 1 to envcount do
    cwriteln('|C'+normaltext(EnvStr(i)));
   cwriteln('|WAll done|w.');
  end
 else
  begin
   is := getenv( paramstr(1 ));
   cwrite('|GENV|Y>');
   new.init( txpos, typos, 78, 78, $0B, $00, is );
   is := new.get;
   assign( t, 'ENV-BAT.BAT');
   rewrite( t );
   write( t, 'SET ' + Paramstr(1)+'='+is );
   close( t );
   cwriteln('');
   if ioresult <> 0 then
    cwriteln('|RSomething screwed up|Y! |GDos Error #'+n2s(doserror));
  end;
 doscursoron;
end.
