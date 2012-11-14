program gprompt;
uses crtstuff, zokstuff, crt;

var
 z : zinput;
 p : zpassword;
 s : string;

const
 prompt1 = #13'|BC:\'#13'|RGUΓU|Y>|W';
 prompt2 = #13'|GWOΓD|Y>|W';

procedure dir;
 begin
  cwriteln('|W'#13);
  cwriteln(' Volume in drive C is GUΓU');
  cwriteln(' Volume Serial Number is 3330-15D2');
  cwriteln(' Directory of C:\');
  cwriteln('');
  cwriteln('File not found');
 end;

begin
 checkbreak := false;
 z.init( 6, 1, 75, 75, $0F, $0F, '' );
 p.init( 6, 1, 75, 75, $09, $0F, '■', '' );
 repeat
  repeat
   cwrite( prompt1 );
   z.y := typos;
   z.back := '';
   z.strg := '';
   s := z.get;
   if
    (upstr(s) <> upstr(paramstr(1)) )
   then
    if
     (upstr(s) <> 'CLS')
    then
     if
      (upstr( s ) <> 'DIR')
     then
      if
       (s <>'')
      then
       cwriteln( #13'|WBad command or file name')
      else
     else
      dir
    else
     begin
      clrscr;
      txpos := 1;
      typos := 1;
     end;
   until upstr(s) = upstr(paramstr(1));
   cwrite( prompt2 );
   p.y := typos;
   p.back := '';
   p.strg := '';
   s := p.get;
   cwriteln('');
  until upstr(s) = upstr(paramstr(2));
  doscursoron;
end.