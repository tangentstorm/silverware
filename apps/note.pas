program note;
uses cw, fs, dos, mjw;

const
  notefile = '.notes.txt';

var
  f : text;
  s : string;
  i : word;
  notepath : string;

begin
  notepath := dos.getenv( 'HOME' ) + '/' + notefile;
  cwriteln('');
  cwriteln('|WNote.exe |B(|Wc|B)|W1994 '+silverware);
  cwriteln('|b|#─50');
  assign( f, notepath );
  if paramcount > 0 then
  begin
    if fs.exists( notepath ) then append( f )
    else rewrite( f );
    for i := 1 to ParamCount do write(f, ParamStr(i)+' ');
    writeln(f);
    cwriteln('|RGot it|r!');
  end
  else
  begin
    if not fs.exists( notepath ) then
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
