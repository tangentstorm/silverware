program view;
uses crtstuff,filstuff,vuestuff;

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

type
 viewerwithcounter = object(listviewer)
  procedure show; virtual;
 end;

procedure viewerwithcounter.show;
 begin
  cwritexy(65,1, '|B[|C'+flushrt(n2s(thisline),6,'.')+
                 '|w/|c'+nlstring+'|B]' );
  listviewer.show;
 end;

var
 viewer : viewerwithcounter;
 i : byte;
 t : file;
 s,c : string;
 done: boolean;

begin
 randseed := 193;
 doscursoroff;
 colorxy(1,1,1,chntimes('─',80));
 fillbox( 1, 2, 80, 24, $0F20 );
 colorxyc( 40, 12, 7, 'Loading...');
 colorxy(1,25,1,chntimes('─',80));
 viewer.init;
 filereset(t, paramstr(1));
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
 doscursoron;
end.