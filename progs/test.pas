Program Test;
uses modem, crt;

var
 e : word;

begin
  com_install (2, e);
  if e <> 0 then halt;
  write( #7 );
  repeat
   com_tx_string( 'sdfasdfasdf' );
  until keypressed;
end.