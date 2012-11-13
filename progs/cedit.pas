{$i xpc.inc }
program cedit;
uses ll, fs, stri, num, cw, crt; {,crtstuff,crt,filstuff,zokstuff; }

  type

    //  duplicated in vuestuff
    stringobj  = class ( node )
      s	: string[ 180 ];
      constructor fromstring( st : string );
    end;

    listeditor = class( list )
      lightbar : ^node;
      nlstring : string[ 6 ];
      thisline : longint;
      x, y, h, w : integer;
      y1, y2 : integer;
      //   work	  : screentype;
      topline, bottomline : stringobj;
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
    x := 1;
    y := 1;
    w := crt.windMaxX;
    h := crt.windMaxY;
    y1 := y; y2 := y + h; //  ditch these
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
	self.append( stringobj.fromstring( line ));
      end;
      close( txt );
      self.nlstring := flushrt( n2s( self.count ), 6, '.' );
    end;
  end;

  procedure listeditor.show;
    var i : integer; s : stringobj;
  begin
    // if self.topline = nil then home;
    cwritexy( 1, 1,
	     '|B[|C' + flushrt( n2s( self.thisline ), 6, '.' ) +
	     '|w/|c' + nlstring + '|B]' );
    i := 1;
    s := self.first as stringobj;
    writeln( 'self.height :', self.h );
    writeln( 'mfirst = nil?', mfirst = nil );
    writeln( 'first = nil?', first = nil );
    writeln( 'first = mfirst?', first = mfirst );
    writeln( 'i < self.h?', i < self.h );
    while ( i < self.h ) and ( i < self.count ) do begin
      writeln( i );
      cwritexy( 1, i, s.s );
      inc( i ); s := s.next as stringobj;
    end;
    //  writeto := @screen;
    //  screen := work;
  end;


  procedure listeditor.home;
    var c : byte;
  begin
    if self.first = nil then exit;
    self.thisline := 1;
    self.topline := mfirst as stringobj;
    self.bottomline := self.topline;
    //  writeto := @work;
    //  fillbox(1,y1,80,y2,$0F20);
    //  vt.txpos := 1;
    //  vt.typos := y1;
  end;

  procedure listeditor._end;
    var c : byte;
  begin
    if first = nil then exit;
    bottomline := first.prev as stringobj;
    topline := bottomline;
    //  writeto := @work;
    //  fillbox(1,y1,80,y2,$0F20);
    txpos := 1; typos := y2;
    thisline := self.count;
    for c := y1 to y2-1 do
      if topline.prev <> bottomline then
      begin
	cwriteln( '|w' + topline.s );
	dec( thisline );
	dec( typos, 2 );
	topline := topline.prev as stringobj;
      end;
    cwriteln( '|w' + topline.s );
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
    var done : boolean = false; ch : char;
  begin
    self.home;
    repeat
      crt.clrscr;
      show;
      ch := crt.readkey;
      case ch of
	#27, ^C	: done := true;
	^N	: arrowdown;
	^P	: arrowup;
	^A	: home;
	^E	: _end;
	^T	: begin
		    clrscr;
		    writeln( 'count:', self.count );
		    readln;
		  end;
	#0	: case crt.readkey of
		    #72	: arrowup; // when you press the UP arrow!
		    #80	: arrowdown; // when you press the DOWN arrow!
		    #71	: home;
		    #79	: _end;
		    #73	: pageup;
		    #81	: pagedown;
		  end;
	else write( ch );
      end
    until done;
  end;

 procedure listeditor.arrowup;
  begin
    if topline <> first then
    begin
      dec( thisline );
      topline := topline.prev as stringobj;
      bottomline := bottomline.prev as stringobj;
      //  writeto := @work;
      //  scrolldown1(1,80,y1,y2,nil);
      //  scrolldown1(1,80,14,25,nil);
      typos := y1; tcolor := 7;
      cwrite( topline.s );
      cwriteln( '|%' );
      colorxy( 1, 14, 7, cpadstr( topline.s, 80, ' ' ));
      show;
    end;
  end;


  procedure listeditor.arrowdown;
  begin
    if bottomline.next <> last then
    begin
      inc(thisline);
      bottomline := bottomline.next as stringobj;
      topline := topline.next as stringobj;
      //  writeto := @work;
      //  scrollup1(1,80,y1,y2,nil);
      //  scrollup1(1,80,14,25,nil);
      typos := y2; tcolor := 7;
      cwrite( bottomline.s );
      cwriteln( '|%' );
      colorxy( 1, 25, 7, cpadstr( bottomline.s, 80, ' ' ));
      show;
    end;
  end;


  procedure prints( s : stringobj );
  begin
    cwriteln( s.s );
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
