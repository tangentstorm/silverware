{ The Electronomicon }
{ (c)1993 ÄSÅîâL³NGÄS³LVîâWêâîÄ }

Program Electro;
uses crt, Crtstuff;

var
 username : string[ 30 ];

procedure delay ( x : integer );
 begin
  crt.delay( x div 2 );
 end;

procedure titlescreen;
 var
  c : byte;
  s2 : string;
 const
  s1 = '|b<|wAll Rights Reserved|b>';
  s2d = '|b(|wc|b)|w1993 |KÄ|wS|ÅîâL³NG|KÄ|wS³LVîâWêâî|KÄ';
 begin
  s2 := '|b(|Wc|b)|w1993 '+copy(Sterling,1,length(Sterling)-1)+Silverware;
  for
   c := 1 to 12
  do
   begin
    delay( 75 );
    ccenterxy( 40, 25-c+1, '|W'+chntimes( ' ', clength( s1 ) ));
    ccenterxy( 40, 25-c, s1 );
    ccenterxy( 40, c-1, '|W'+chntimes( ' ', clength( s2 ) ));
    ccenterxy( 40, c, s2 );
   end;
  delay( 3000 );
  ccenterxy( 40, 12, s2d);
  delay( 100 );
  colorxyc( 40, 12, 8, '(c)1993 ÄSÅîâL³NGÄS³LVîâWêâîÄ');
  colorxyc( 40, 13, 8, '<All Rights Reserved>');
  delay( 100 );
  colorxyc( 40, 12, 0, '(c)1993 ÄSÅîâL³NGÄS³LVîâWêâîÄ');
  colorxyc( 40, 13, 0, '<All Rights Reserved>');
  delay( 500 );
  for c := 1 to 80 do
   begin
    delay( 25 );
    colorxyc( 40,  9, 1, chntimes( 'Ä', c ));
    colorxyc( 40, 15, 1, chntimes( 'Ä', c ));
   end;
  colorxyc( 40, 11, 8, 'ÚÄ ³  ÚÄ Ú¿ ÄÄÄ ÚÄ¿ ÚÄ¿ Ú¿³ ÚÄ¿ Ú³¿ ³ Ú¿ ÚÄ¿ Ú¿³');
  colorxyc( 40, 12, 8, 'ÄÄ ³  ÄÄ ³   ³  ³ÄÙ ³ ³ ³³³ ³ ³ ³³³ ³ ³  ³ ³ ³³³');
  colorxyc( 40, 13, 8, 'ÀÄ ÀÄ ÀÄ ÀÙ  ³  ³ ³ ÀÄÙ ³ÀÙ ÀÄÙ ³ ³ ³ ÀÙ ÀÄÙ ³ÀÙ');
  delay( 100 );
  colorxyc( 40, 11, 7, 'ÚÄ ³  ÚÄ Ú¿ ÄÄÄ ÚÄ¿ ÚÄ¿ Ú¿³ ÚÄ¿ Ú³¿ ³ Ú¿ ÚÄ¿ Ú¿³');
  colorxyc( 40, 12, 7, 'ÄÄ ³  ÄÄ ³   ³  ³ÄÙ ³ ³ ³³³ ³ ³ ³³³ ³ ³  ³ ³ ³³³');
  colorxyc( 40, 13, 7, 'ÀÄ ÀÄ ÀÄ ÀÙ  ³  ³ ³ ÀÄÙ ³ÀÙ ÀÄÙ ³ ³ ³ ÀÙ ÀÄÙ ³ÀÙ');
  delay( 100 );
  colorxyc( 40, 11, 14, 'ÚÄ ³  ÚÄ Ú¿ ÄÄÄ ÚÄ¿ ÚÄ¿ Ú¿³ ÚÄ¿ Ú³¿ ³ Ú¿ ÚÄ¿ Ú¿³');
  colorxyc( 40, 12, 14, 'ÄÄ ³  ÄÄ ³   ³  ³ÄÙ ³ ³ ³³³ ³ ³ ³³³ ³ ³  ³ ³ ³³³');
  colorxyc( 40, 13, 14, 'ÀÄ ÀÄ ÀÄ ÀÙ  ³  ³ ³ ÀÄÙ ³ÀÙ ÀÄÙ ³ ³ ³ ÀÙ ÀÄÙ ³ÀÙ');
  delay( 1000 );
  colorxyc( 40, 17, 8, 'Press <Enter> to begin.');
  delay( 100 );
  ccenterxy( 40, 17, '|wPress |b<|wEnter|b>|w to begin|K.');
  delay( 100 );
  ccenterxy( 40, 17, '|WPress |B<|WEnter|B>|W to begin|w.');
  getenter;
 end;

procedure getusername;
 begin
   { shows a list of available accounts, allows user to select one
     or enter a new name }
  username := 'Saber Renault';
 end;

procedure init;
 begin
  setupcrt;
  titlescreen;
  getusername;
 end;

begin
 init;
end.