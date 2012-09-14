Program Wintest;
uses crtstuff,crt;

const
 winyes : boolean = TRUE;

var
 t : text;

begin
 cwriteln('|b~k');
 cwriteln('');
 cwriteln('Ä|BÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|bÄ');
 cwriteln('  |KÄ|WS|w³LVîâWêâî|KÄ |w/ |WWestern Hills');
 cwriteln('|bÄ|BÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|bÄ');
 cwriteln('  |W  Hit |w"|WX|w"|W to Bypass Windows     ');
 cwrite('|bÄ|BÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|bÄ');
 delay( 2000 );
 cwriteln('');
 if (keypressed) and (upcase( readkey ) = 'X') then winyes := false;
 assign( t, 'Winbat.Bat' );
 rewrite( t );
 if
  winyes
 then
  writeln( t, 'WINYES' )
 else
  writeln( t, 'WINNO' );
 close( t );
end.
