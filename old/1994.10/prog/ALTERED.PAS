program altered;
uses crtstuff, sndstuff, crt;


var
 ch : char;
begin
 cwriteln('|!k|W|_Altered State|r... |WFreeware by |b[[|WS|Ca|WBâ|Ce|WN|b]]');
 cwriteln('|b|#Ä40|_|WThis program uses the sound blaster|r''|Ws FM Music');
 cwriteln('capabilities to generate tones at 400 and 404 hz in the left and');
 cwriteln('right speakers, respectively|r... |WSupposedly|r, |Wthis should put');
 cwriteln('users in an altered state of consciousness|r...');
 cwriteln('|CNote|r: |CHeadphones might help|r...|_|b|#Ä40');
 spkr.init;
 if not spkr.sbpresent then
  begin
   cwriteln('|!K|RError!|!k|Y:|W Can|r''|Wt find a soundblaster|r...');
   halt;
  end;
 cwriteln('|WPress |w'+ enter + '|W to quit|r, |Wor Esc to play tones in DOS|r..');
 spkr.soundleft( 400 );
 spkr.soundright( 404 );
 repeat
  ch := readkey;
 until ch in [ #13, #27 ];
 if ch = #13 then spkr.nosound;
end.