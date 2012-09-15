{

|!W okay guys, this is the ultimate text viewer..

  |!Gnote: |KTWO FONTS! |!rF|!RI|!YF|!GT|!BE|!ME|!mN |!wCOLORS!!!

|!B"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz
|!B|K"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz
|!bÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäå|!b|KÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäå

colors: |011|022|033|044|055|066|077|088|099|10A|11B|12C|13D|14E|15F|00

  |!GAlso note: this is 90x25!! (Many thanks to shadowlord!!)

  sometimes I get an extra dot in the far left row of pixels.. I think it's
 the screen mode.. can anyone help me with that?

|!C... |!b[|!B[|!WS|!Ca|!WBR|!Ce|!WN|!B]|!b]

PS: |K|!M Here's the main program listing, so you can check out my scrolling! |k:)

}

program blah;
uses crtstuff, vgastuff,vuestuff,filstuff;

procedure gumrev; external;
{$L Gumrev}

procedure sabrev; external;
{$L sabrev}

type
 viewerwithcounter = object(listviewer)
  constructor init;
  procedure show; virtual;
 end;

constructor viewerwithcounter.init;
 begin
  listviewer.init;
  tcolorinit := $70;
 end;

procedure viewerwithcounter.show;
 begin
  cwritexy(75,1, '|k|!B[|!C'+flushrt(n2s(thisline),6,'.')+
                 '|!w/|!c'+nlstring+'|!B]' );
  listviewer.show;
 end;

var
 viewer : viewerwithcounter;
 i : byte;
 t : file;
 s,c : string;
 done: boolean;

FUNCTION Cipher (St, Passwd: String): String;
VAR
   SPtr, PPtr: Integer;
BEGIN
   IF Length(Passwd) > 0 THEN BEGIN
      PPtr := 1;
      FOR SPtr := 1 TO Length(St) DO BEGIN
         St[SPtr] := CHR(Ord(St[SPtr]) XOR Ord(Passwd[PPtr]) XOR $80);
         INC(PPtr);
         IF PPtr > Length(Passwd) THEN
            PPtr := 1;
      END;
   END;
   Cipher := St;
END;


begin
 setupcrt;
 setwidth90;
 blinking( off );
 setcolor(32,0,0,0);
 setcolor(56,0,0,0);
 setcolor(20,16,16,16); {32 is black, 20 is brown..}
 installfont(seg(gumrev), ofs(gumrev));
 installfont2(seg(sabrev), ofs(sabrev));
 txmax := 90;
  asm
   mov ax, 1103h
   mov bl, 4
   int 10h
  end;
 sw := 180;
 randseed := 193;
 fillchar( screen, 180*28, 0 );
 colorxy(1,1, $10,chntimes('Ä',90));
 colorxyc( 45,12, $70, 'Loading...');
 colorxy(1,25,$10,chntimes('Ä',90));
 viewer.init;
 viewer.x2 := 90;
 {$I-}
 filereset(t, 'BLAH!.FOO');
 {$I+}
 if IOresult <> 0 then
  begin
   setmode( 3 );
   cwriteln('|WSomeone ate |GBLAH!.FOO|k|!w');
   halt;
  end;
 while not eof(t) do
  begin
   s := nextstring(t); Inc(viewer.Numlines);
   c := '';
   for i := 1 to 35 do c := c + char(random(50)+ord('A'));
   viewer.append( new( pstringobj, init( cipher(s,c) )));
  end;
 close( t );
 viewer.nlstring := flushrt(n2s(viewer.numlines),6,'.');
 viewer.view;
 viewer.done;
 setmode( 3 );
end.