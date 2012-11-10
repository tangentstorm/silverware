program edit;
{uses pntstuff,crtstuff,crt,filstuff,zokstuff;

type
 listviewer = object( list )
  y1, y2 : integer;
  work : screentype;
  topline, bottomline : pnode;
  constructor init;
  procedure show; virtual;
  procedure arrowup; virtual;
  procedure arrowdown; virtual;
  procedure home; virtual;
  procedure _end; virtual;
  procedure pageup; virtual;
  procedure pagedown; virtual;
  procedure run; virtual;
 end;
 listeditor = object( listviewer )
  lightbar : pnode;
  constructor init;
  procedure show; virtual;
  procedure arrowup; virtual;
  procedure arrowdown; virtual;
  procedure home; virtual;
  procedure _end; virtual;
 end;
}

var
 Thisline, numlines : longint;
 nlstring : string[6];
{
 constructor stringobj.init( st : string );
  begin
   s := st;
  end;

 constructor listviewer.init;
  begin
   list.init;
   y1 := 2;
   y2 := 24;
   work := screen;
   topline := nil;
   bottomline := nil;
   lightbar := nil;
  end;

 procedure listviewer.show;
  begin
   if topline = nil then home;
    cwritexy(65,1, '|B[|C'+flushrt(n2s(thisline),6,'.')+
                   '|w/|c'+nlstring+'|B]' );
    writeto := @screen;
    screen := work;
  end;

 procedure listviewer.arrowup;
  begin
   if topline <> first then
    begin
     dec(thisline);
     topline := topline^.prev;
     bottomline := bottomline^.prev;
     writeto := @work;
     scrolldown1(1,80,y1,y2,nil);
     typos := y1; tcolor := 7;
     cwrite(pstringobj(topline)^.s);
     cwriteln('|%');
     show;
    end;
  end;

 procedure listviewer.arrowdown;
  begin
   if bottomline^.next <> first then
    begin
     inc(thisline);
     bottomline := bottomline^.next;
     topline := topline^.next;
     writeto := @work;
     scrollup1(1,80,y1,y2,nil);
     typos := y2; tcolor := 7;
     cwrite(pstringobj(bottomline)^.s);
     cwriteln('|%');
     show;
    end;
  end;

 procedure listviewer.home;
  var
   c : byte;
  begin
   if first = nil then exit;
   thisline := 1;
   topline := first;
   bottomline := topline;
   writeto := @work;
   fillbox(1,y1,80,y2,$0F20);
   txpos := 1; typos := y1;
   for c := y1 to y2-1 do
    if bottomline^.next <> first then
     begin
      cwriteln('|w'+pstringobj(bottomline)^.s);
      bottomline := bottomline^.next;
     end;
   show;
  end;

 procedure listviewer._end;
  var
   c : byte;
  begin
   if first = nil then exit;
   bottomline := first^.prev;
   topline := bottomline;
   writeto := @work;
   fillbox(1,y1,80,y2,$0F20);
   txpos := 1; typos := y2;
   thisline := numlines;
   for c := y1 to y2-1 do
    if topline^.prev <> bottomline then
     begin
      cwriteln('|w'+pstringobj(topline)^.s);
      dec(thisline);
      dec(typos,2);
      topline := topline^.prev;
     end;
     cwriteln('|w'+pstringobj(topline)^.s);
    show;
  end;

 procedure listviewer.pageup;
  var
   c : byte;
  begin
   for c := y1 to y2-1 do arrowup;
  end;

 procedure listviewer.pagedown;
  var
   c : byte;
  begin
   for c := y1 to y2-1 do arrowdown;
  end;

 procedure listviewer.run;
  var
   alldone : boolean;
  begin
   home;
   alldone := false;
   repeat
    if keypressed then case readkey of
     #27 : alldone := true;
     #0  : case readkey of
            #72: arrowup; // when you press the UP arrow!
            #80: arrowdown; // when you press the DOWN arrow!
            #71: home;
            #79: _end;
            #73: pageup;
            #81: pagedown;
           end;
     end;
   until alldone;
 end;

 constructor listeditor.init;
  begin
   listviewer.init;
   y1 := 1;
   y2 := 12;
  end;

 procedure listeditor.show;
  begin
   if topline = nil then home;
    cwritexy(65,13, '|B[|C'+flushrt(n2s(thisline),6,'.')+
                   '|w/|c'+nlstring+'|B]' );
    writeto := @screen;
    screen := work;
  end;

 procedure listeditor.arrowup;
  begin
   if topline <> first then
    begin
     dec(thisline);
     topline := topline^.prev;
     bottomline := bottomline^.prev;
     writeto := @work;
     scrolldown1(1,80,y1,y2,nil);
     scrolldown1(1,80,14,25,nil);
     typos := y1; tcolor := 7;
     cwrite(pstringobj(topline)^.s);
     cwriteln('|%');
     colorxy(1,14,7,padstr(pstringobj(topline)^.s,80,' '));
     show;
    end;
  end;

 procedure listeditor.arrowdown;
  begin
   if bottomline^.next <> first then
    begin
     inc(thisline);
     bottomline := bottomline^.next;
     topline := topline^.next;
     writeto := @work;
     scrollup1(1,80,y1,y2,nil);
     scrollup1(1,80,14,25,nil);
     typos := y2; tcolor := 7;
     cwrite(pstringobj(bottomline)^.s);
     cwriteln('|%');
     colorxy(1,25,7,padstr(pstringobj(bottomline)^.s,80,' '));
     show;
    end;
  end;

 procedure listeditor.home;
  var
   c : byte;
  begin
   if first = nil then exit;
   thisline := 1;
   topline := first;
   bottomline := topline;
   writeto := @work;
   fillbox(1,y1,80,y2,$0F20);
   txpos := 1; typos := y1;
   for c := y1 to y2-1 do
    if bottomline^.next <> first then
     begin
      cwriteln('|w'+pstringobj(bottomline)^.s);
      bottomline := bottomline^.next;
     end;
   show;
  end;

 procedure listeditor._end;
  var
   c : byte;
  begin
   if first = nil then exit;
   bottomline := first^.prev;
   topline := bottomline;
   writeto := @work;
   fillbox(1,y1,80,y2,$0F20);
   txpos := 1; typos := y2;
   thisline := numlines;
   for c := y1 to y2-1 do
    if topline^.prev <> bottomline then
     begin
      cwriteln('|w'+pstringobj(topline)^.s);
      dec(thisline);
      dec(typos,2);
      topline := topline^.prev;
     end;
     cwriteln('|w'+pstringobj(topline)^.s);
    show;
  end;


procedure prints( n : pnode );
begin
  cwriteln( pstringobj(n)^.s );
end;

}

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

var
// viewer : listeditor;
 i : byte;
 t : text;
 s : string;
 done: boolean;

begin
 randseed := 193;
 Numlines := 0;
{
  doscursoroff;
  setupcrt;
  colorxy(1,13,1,chntimes('Ä',80));
  colorxyc( 40, 6, 7, 'Loading...');
  viewer.init;
}
assign( t, paramstr(1)); reset(t);
 while not eof(t) do
  begin
   readln( t, s ); Inc(Numlines);
   // viewer.append( new( pstringobj, init( s ) ));
  end;
 close( t );
{
  nlstring := flushrt(n2s(numlines),6,'.');
  viewer.run;
  viewer.done;
  doscursoron;
}
end.