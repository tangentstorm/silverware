Program Wintest;
uses crtstuff,crt;

const
 winyes : boolean = TRUE;

var
 t : text;

begin
 cwriteln('|b~k');
 cwriteln('');
 cwriteln('─|B───────────────────────────────|b─');
 cwriteln('  |K─|WS|w│LVεΓWΩΓε|K─ |w/ |WWestern Hills');
 cwriteln('|b─|B───────────────────────────────|b─');
 cwriteln('  |W  Hit |w"|WX|w"|W to Bypass Windows     ');
 cwrite('|b─|B───────────────────────────────|b─');
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
