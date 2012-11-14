program altered;
uses crtstuff, sndstuff, crt;

var
 ch : char;
 sblast : sbobj;
begin
 sblast.init;
 sblast.pro;
 sblast.setpan( 0, $11 );
 sblast.setpan( 1, $21 );
 sblast.setpan( 2, $01 );
 sblast.setpan( 3, $01 );
 sblast.sound( 0, 200 );
 sblast.sound( 1, 215 );
 sblast.sound( 2, 9000 );
 sblast.sound( 3, 1000 );
 repeat ch := readkey;
 until ch in [ #13, #27 ];
 if ch = #13 then
  begin
   sblast.nosound(0);
   sblast.nosound(1);
   sblast.nosound(2);
   sblast.nosound(3);
  end;
end.


 cwriteln('|!k|W|_Altered State|r... |WFreeware by |b[[|WS|Ca|WBΓ|Ce|WN|b]]');
 cwriteln('|b|#─40|_|WThis program uses the sound blaster|r''|Ws FM Music');
 cwriteln('capabilities to generate tones at 400 and 404 hz in the left and');
 cwriteln('right speakers, respectively|r... |WSupposedly|r, |Wthis should put');
 cwriteln('users in an altered state of consciousness|r...');
 cwriteln('|CNote|r: |CHeadphones might help|r...|_|b|#─40');
 cwriteln('|WPress |w'+ enter + '|W to quit|r, |Wor Esc to play tones in DOS|r..');
