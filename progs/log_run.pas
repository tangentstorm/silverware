{$M $2000,0,0 }  {4K stack, no heap}
program env_run;
uses Dos, crtstuff, zokstuff;
var
  I: Integer;
  is : string[79];
  new : zinput;
  t : text;
begin
 cwriteln('|!k|W');
  begin
   is := 'default';
   cwrite('|GLOGIN|Y>');
   new.init( txpos, typos, 78, 78, $0F, $00, is );
   is := upstr(new.get);
   assign( t, 'LOG-BAT.BAT');
   rewrite( t );
   write( t, 'SET Login='+is );
   close( t );
   if ioresult <> 0 then
    cwriteln('|RSomething screwed up|Y! |GDos Error #'+n2s(doserror));
  end;
 doscursoron;
end.
