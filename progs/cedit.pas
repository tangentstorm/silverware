{$i xpc.inc }
program cedit;
uses xpc, ll, fs, stri, num, cw, crt; {,crtstuff,crt,filstuff,zokstuff; }

  type
    //  duplicated in vuestuff
    pstringobj = ^stringobj;
    stringobj  = class ( node )
      s	: string[ 180 ];
      constructor fromstring( st : string );
    end;
    listviewer = class( list )
      thisline, numlines  : longint;
      y1, y2		  : integer;
      //   work	  : screentype;
      topline, bottomline : pnode;
      constructor init; override;
      procedure show;
      //   procedure arrowup; virtual;
      //   procedure arrowdown; virtual;
      procedure home;
      //   procedure _end; virtual;
      //   procedure pageup; virtual;
      //   procedure pagedown; virtual;
      procedure run;
    end;
    listeditor = class ( listviewer )
      //  lightbar : pnode;
      constructor init; override;
      //  procedure arrowup; virtual;
      //  procedure arrowdown; virtual;
      //  procedure _end; virtual;
    end;

  var nlstring : string[ 6 ];

  constructor stringobj.fromstring( st : string );
  begin self.s := st;
  end;

  constructor listviewer.init;
  begin
    inherited;
    y1 := 2;
    y2 := 24;
    //  work := screen;
    topline := nil;
    bottomline := nil;
    //  lightbar := nil;
  end;

  procedure listviewer.show;
  begin
    if self.topline = nil then home;
    cwritexy( 1, 1,
	     '|B[|C' + flushrt( n2s( self.thisline ), 6, '.') +
	     '|w/|c' + nlstring + '|B]' );
    //  writeto := @screen;
    //  screen := work;
  end;


{
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
}

  procedure listviewer.home;
    var c : byte;
  begin
    if self.first = nil then exit;
    self.thisline := 1;
    self.topline := self.first;
    self.bottomline := self.topline;
    //  writeto := @work;
    //  fillbox(1,y1,80,y2,$0F20);
    //  vt.txpos := 1;
    //  vt.typos := y1;
    for c := y1 to y2-1 do
      if bottomline^.next <> first then begin
	cwriteln( '|w' + pstringobj( bottomline )^.s );
	self.bottomline := self.bottomline^.next;
      end;
    self.show;
  end;

{
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
}

  procedure listviewer.run;
    var done : boolean = false;
  begin
    self.home;
    repeat
      if crt.keypressed then case crt.readkey of
	#27, ^C : done := true;
	#0  : case crt.readkey of
		#72 :; //  arrowup; // when you press the UP arrow!
		#80 :; //  arrowdown; // when you press the DOWN arrow!
		#71 :; //  home;
		#79 :; //  _end;
		#73 :; //  pageup;
		#81 :; //  pagedown;
	      end
      end
    until done;
  end;

  constructor listeditor.init;
  begin
    inherited;
    y1 := 1;
    y2 := 12;
  end;

{
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
}

{
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

//  never used
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
  ed	  : listeditor;
  i	  : byte;
  txt	  : text;
  path, s : string;
  done	  : boolean;

begin
  crt.clrscr;
  randseed := 193;
  //  doscursoroff;
  //  setupcrt;
  colorxy(1,13,1,chntimes('Ä',80));
  colorxyc( 40, 6, 7, 'Loading...');

  ed := listeditor.init;

  path := paramstr( 1 );
  if fs.exists( path ) then begin
    assign( txt, path );
    reset( txt );
    while not eof( txt ) do begin
      readln( txt, s );
      // writeln( s );
      inc( ed.numlines ); //  move to listviewer.append
      ed.append( new( pstringobj, fromstring( s )));
    end;
    close( txt );
  end;

  nlstring := flushrt( n2s( ed.numlines ), 6, '.' ); //  move to listview

  ed.run;
  ed.destroy;
  //  doscursoron;
end.
