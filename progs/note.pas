program note;
uses crtstuff,filstuff;

var
 f : text;
 s : string;
 i : word;

begin
 cwriteln('');
 cwriteln('|WNote.exe |B(|Wc|B)|W1994 '+silverware);
 cwriteln('|b|#─50');
 assign( f, 'C:\extras\notes.txt' );
 if paramcount > 0 then
  begin
   if fileexists('C:\EXTRAS\NOTES.TXT') then
    append( f )
   else
    rewrite( f );
   for i := 1 to ParamCount do
   write(f, ParamStr(i)+' ');
   writeln(f);
   cwriteln('|RGot it|r!');
  end
 else
  begin
   if not fileexists('C:\EXTRAS\NOTES.TXT') then
    begin
     cwriteln('|GNothing in notepad file|g...');
     cwriteln('|b|#─50');
     exit;
    end;
   reset( f );
   while not eof( f ) do
    begin
    readln( f, s );
    cwriteln( '|w'+s );
   end;
  end;
 cwriteln('|b|#─50');
 close( f );
end.