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

    listeditor = class( list )
      lightbar : pnode;
      nlstring : string[ 6 ];
      thisline, numlines  : longint;
      y1, y2		  : integer;
      //   work	  : screentype;
      topline, bottomline : pnode;
      constructor init; override;
      function load( path : string ) : boolean;
      procedure show;
      procedure arrowup;
      procedure arrowdown;
      procedure home;
      procedure _end;
      procedure pageup;
      procedure pagedown;
      procedure run;
    end;


  constructor stringobj.fromstring( st : string );
  begin self.s := st;
  end;

  constructor listeditor.init;
  begin
    inherited;
    y1 := 2;
    y2 := 24;
    //  work := screen;
    topline := nil;
    bottomline := nil;
    lightbar := nil;
  end;

  function listeditor.load( path : string ) : boolean;
    var txt : text; line : string;
  begin
    result := fs.exists( path );
    if result then begin
      //  need to check for io errors in here
      assign( txt, path );
      reset( txt );
      while not eof( txt ) do begin
	readln( txt, line );
	// writeln( s );
	inc( self.numlines );
	self.append( new( pstringobj, fromstring( line )));
      end;
      close( txt );
      self.nlstring := flushrt( n2s( self.numlines ), 6, '.' );
    end;
  end;

  procedure listeditor.show;
  begin
    if self.topline = nil then home;
    cwritexy( 1, 1,
	     '|B[|C' + flushrt( n2s( self.thisline ), 6, '.') +
	     '|w/|c' + nlstring + '|B]' );
    //  writeto := @screen;
    //  screen := work;
  end;


  procedure listeditor.home;
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

  procedure listeditor._end;
    var c : byte;
  begin
    if first = nil then exit;
    bottomline := first^.prev;
    topline := bottomline;
    //  writeto := @work;
    //  fillbox(1,y1,80,y2,$0F20);
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


  procedure listeditor.pageup;
    var c : byte;
  begin for c := y1 to y2-1 do arrowup;
  end;

  procedure listeditor.pagedown;
    var c : byte;
  begin for c := y1 to y2-1 do arrowdown;
  end;


  procedure listeditor.run;
    var done : boolean = false;
  begin
    self.home;
    repeat
      if crt.keypressed then case crt.readkey of
	#27, ^C	: done := true;
	#0	: case crt.readkey of
		#72 : arrowup; // when you press the UP arrow!
		#80 : arrowdown; // when you press the DOWN arrow!
		#71 : home;
		#79 : _end;
		#73 : pageup;
		#81 : pagedown;
	      end
      end
    until done;
  end;

 procedure listeditor.arrowup;
  begin
    if topline <> first then
    begin
      dec(thisline);
      topline := topline^.prev;
      bottomline := bottomline^.prev;
      //  writeto := @work;
      //  scrolldown1(1,80,y1,y2,nil);
      //  scrolldown1(1,80,14,25,nil);
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
      //  writeto := @work;
      //  scrollup1(1,80,y1,y2,nil);
      //  scrollup1(1,80,14,25,nil);
      typos := y2; tcolor := 7;
      cwrite(pstringobj(bottomline)^.s);
      cwriteln('|%');
      colorxy(1,25,7,padstr(pstringobj(bottomline)^.s,80,' '));
      show;
    end;
  end;


  procedure prints( n : pnode );
  begin
    cwriteln( pstringobj(n)^.s );
  end;


  //  not used
  FUNCTION Cipher (St, Passwd: String): String;
    VAR SPtr, PPtr: Integer;
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


  var ed : listeditor;
begin
  randseed := 193;
  ed := listeditor.init;
  if paramcount = 0 then
    writeln( 'usage : cedit <filename>' )
  else if ed.load( paramstr( 1 )) then
  begin
    //  doscursoroff;
    //  setupcrt;
    ed.run;
    ed.destroy;
    //  doscursoron;
  end
  else writeln( 'unable to load file: ', paramstr( 1 ));
end.
