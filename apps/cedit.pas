{ cEdit
----------------------------------------------------------------
Copyright (c) 199x - 2012 Michal J Wallace  |  MIT/X11 Licensed.
----------------------------------------------------------------
Revised Nov 10-12 2012

  This program was intended to be a colorized text editor.
  See code/cw.pas in the xpl repository for the markup syntax.

  It doesn't look like I implemented the "editor" part, but
  since it was line-oriented, it should just be a matter of
  using a zokstuff.zinput ( now xpl/code/ui.zinput.p ) on the
  current line. It does show colored text though, and I just
  added some line numbers. :)

  I may return to this once I get the ui stuff under test --
  sort of still hoping to find a more complete editor somewhere
  in this codebase. :)

---------------------------------------------------------------}
{$i xpc.inc}
program cedit;
uses ll, li, fs, stri, num, cw, crt;

  type

    //  the idea is to allow nesting here, eventually
    stringobj  = class ( li.node )
      content : string;
      constructor fromstring( st : string );
    end;

    listeditor = class( specialize list<stringobj> )
      x, y, h, w : integer;
      topline, position : listeditor.cursor;
      constructor create;
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
  begin self.content := st;
  end;

  constructor listeditor.create;
  begin
    inherited;
    x := 1;
    y := 1;
    w := crt.windMaxX;
    h := crt.windMaxY;
    //pause( 'windmaxy = ' + n2s( h ));
    topline := self.make_cursor;
    position := self.make_cursor;
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
    end;
  end;

  procedure listeditor.show;
    var
      ypos : cardinal;
      cur  : cursor;

    procedure show_curpos;
    begin
      cwritexy( 1, 1,
                '|B[|C' + flushrt( n2s( self.position.index ), 6, '.' ) +
		'|w/|c' + flushrt( n2s( self.count ), 6, '.' ) +
		'|B]' +
                '|%' );
    end;

    procedure show_highlight;
    begin
      if cur.index = position.index
        then cwrite( '|!b' )
        else cwrite( '|!k' )
    end;

    procedure show_nums;
    begin
      cwritexy( 1, ypos, '|Y|!m' );
      write( flushrt( n2s( cur.index ), 3, ' ' ));
      cwrite( '|w' );
    end;

    procedure show_text;
    begin
      cwrite( stri.trunc( cur.value.content, cw.scr.w - cw.cur.x ));
      cwrite( '|%' ); // clreol
    end;

  begin
    // clrscr; //  fillbox( 1, 1, crt.windmaxx, crt.windmaxy, $0F20 );
    show_curpos;
    ypos := 2;
    cur := self.make_cursor;
    cur.move_to( self.topline );
    repeat
      show_nums;
      show_highlight;
      show_text;
      inc( ypos )
    until ( ypos = self.h ) or ( not cur.move_next );
    while ypos < self.h do begin
      cwritexy( 1, ypos, '|%' );
      inc( ypos )
    end
  end;


  procedure listeditor.home;
  begin
    if self.first = nil then exit;
    self.position.to_top;
    self.topline.to_top;
  end;

  procedure listeditor._end;
    var i : byte;
  begin
    self.position.to_end;
    self.topline.to_end;
    for i := crt.windmaxy div 2 downto 1 do
      self.topline.move_prev;
  end;


  procedure listeditor.pageup;
    var c : byte;
  begin for c := 1 to h do arrowup;
  end;

  procedure listeditor.pagedown;
    var c : byte;
  begin for c := 1 to h do arrowdown;
  end;


  procedure listeditor.run;
    var done : boolean = false; ch : char;
  begin
    self.home;
    repeat
      show;
      ch := crt.readkey;
      case ch of
	#27, ^C	: done := true;
	^N	: arrowdown;
	^P	: arrowup;
	^A	: home;
	^E	: _end;
	#0	: case crt.readkey of
		    #72	: arrowup; // when you press the UP arrow!
		    #80	: arrowdown; // when you press the DOWN arrow!
		    #71	: home;
		    #79	: _end;
		    #73	: pageup;
		    #81	: pagedown;
		  end;
	else;
      end
    until done;
  end;

  procedure listeditor.arrowup;
  begin
    if self.position.move_prev then
    begin
      if self.position.index - self.topline.index < 5 then
          if self.topline.index > 1 then
             self.topline.move_prev;
      //  scrolldown1(1,80,y1,y2,nil);
      //  scrolldown1(1,80,14,25,nil);
    end
    else self.position.move_next;
  end;


  procedure listeditor.arrowdown;
    var screenline : word;
  begin
    if self.position.move_next then
      begin
        assert( self.topline.index <= self.position.index );
        screenline := self.position.index - self.topline.index;
        if ( screenline > self.h - 5 ) and ( self.topline.index < self.count ) then
           self.topline.move_next
          //  scrollup1(1,80,y1,y2,nil);
          //  scrollup1(1,80,14,25,nil);
      end
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
  crt.clrscr;
  ed := listeditor.create;
  if paramcount = 0 then
    writeln( 'usage : cedit <filename>' )
  else if ed.load( paramstr( 1 )) then
  begin
    ed.run;
    ed.destroy;
    cwriteln( '|w|!k' );
  end
  else writeln( 'unable to load file: ', paramstr( 1 ));
end.
