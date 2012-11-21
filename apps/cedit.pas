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
{$i xpc.inc }
program cedit;
uses ll, fs, stri, num, cw, crt;

  type

    //  duplicated in vuestuff
    stringobj  = class ( node )
      s	: string[ 180 ];
      constructor fromstring( st : string );
    end;

    listeditor = class( list )
      thisline : longint;
      x, y, h, w : integer;
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
    topline := nil;
    bottomline := nil;
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
      i	: integer = 1;
      s	: stringobj;

    procedure show_curpos;
    begin
        cwritexy( 1, 1,
		 '|B[|C' + flushrt( n2s( self.thisline ), 6, '.' ) +
		 '|w/|c' + flushrt( n2s( self.count ), 6, '.' ) +
		 '|B]' );
    end;

    procedure show_highlight;
    begin if i = thisline then cwrite( '|!b' ) else cwrite( '|!k' )
    end;

    procedure show_nums;
    begin
      cwritexy( 1, i + 1, '|Y|!m' );
      write( flushrt( n2s( i ), 3, ' ' ));
      cwrite( '|w' );
    end;

    procedure show_text;
    begin
      cwrite( stri.trunc( s.s, cw.scr.w - cw.cur.x ));
      cwrite( '|%' ); // clreol
    end;

  begin
    clrscr; //  fillbox( 1, 1, crt.windmaxx, crt.windmaxy, $0F20 );
    show_curpos;
    s := self.first as stringobj;
    while ( i < self.h ) and ( i < self.count ) do begin
      show_nums;
      show_highlight;
      show_text;
      inc( i );
      s := s.next as stringobj;
    end;
  end;


  procedure listeditor.home;
    var c : byte;
  begin
    if self.first = nil then exit;
    self.thisline := 1;
    self.topline := mfirst as stringobj;
    self.bottomline := self.topline;
  end;

  procedure listeditor._end;
    var c : byte;
  begin
    if last = nil then exit;
    bottomline := last as stringobj;
    thisline := self.count - 1;
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
    if topline <> first then
    begin
      dec( thisline );
      topline := topline.prev as stringobj;
      bottomline := bottomline.prev as stringobj;
      //  scrolldown1(1,80,y1,y2,nil);
      //  scrolldown1(1,80,14,25,nil);
    end;
  end;


  procedure listeditor.arrowdown;
  begin
    if bottomline.next <> last then
    begin
      inc(thisline);
      bottomline := bottomline.next as stringobj;
      topline := topline.next as stringobj;
      //  scrollup1(1,80,y1,y2,nil);
      //  scrollup1(1,80,14,25,nil);
    end;
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
  ed := listeditor.init;
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
