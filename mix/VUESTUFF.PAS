unit vuestuff;
interface
uses pntstuff, crtstuff, crt;

var
  screen : BScreenType absolute $B800:$0000;     { ega43  vga50 }

type
 pstringobj = ^stringobj;
 stringobj = object ( node )
  s : string[180];
  constructor init( st : string );
 end;
 listviewer = object( list )
  Thisline, numlines : longint;
  nlstring : string[6];
  tcolorinit : byte;
  y1, y2, x1, x2 : integer;
  work : bscreentype;
  topline, bottomline : pnode;
  constructor init;
  procedure drawone( a, b : byte; s : string ); virtual;
  procedure show; virtual;
  procedure showpage; virtual;
  procedure arrowup; virtual;
  procedure arrowdown; virtual;
  procedure home; virtual;
  procedure _end;
  procedure pageup; 
  procedure pagedown;
  procedure dowhilelooping; virtual;
  procedure view;
 end;
 listlighter = object( listviewer )
  highline : pnode;
  procedure home; virtual;
  procedure arrowup; virtual;
  procedure arrowdown; virtual;
 end;

implementation

 constructor stringobj.init( st : string );
  begin
   s := st;
  end;

 constructor listviewer.init;
  begin
   list.init;
   y1 := 2;
   y2 := 24;
   x1 := 1;
   x2 := 80;
   tcolorinit := 7;
   work := screen;
   topline := nil;
   bottomline := nil;
   numlines := 0;
  end;

 procedure listviewer.show;
  var y : byte;
  begin
    writeto := @screen;
    for y := pred(y1) to pred(y2) do
     move( work[ (160*y)+2*(x1-1)], screen[ (160*y)+2*(x1-1) ], 2*(x2-x1+1) );
  end;

 procedure listviewer.showpage;
  var
   c : byte;
   t : pnode;
  begin
   t := topline;
   repeat
    drawone( x1, c, pstringobj(t)^.s );
    t := t^.next;
   until t = bottomline;
  end;

 procedure listviewer.arrowup;
  begin
   if topline <> first then
    begin
     dec(thisline);
     topline := topline^.prev;
     bottomline := bottomline^.prev;
     writeto := @work;
     scrolldown1(x1,x2,y1,y2,nil);
     drawone( x1, y1, pstringobj(topline)^.s );
     show;
    end;
  end;

 procedure listviewer.arrowdown;
  begin
   if bottomline <> last then
    begin
     inc(thisline);
     bottomline := bottomline^.next;
     topline := topline^.next;
     writeto := @work;
     scrollup1(x1,x2,y1,y2,nil);
     drawone( x1, y2, pstringobj(bottomline)^.s );
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
   fillbox(x1,y1,x2,y2,$0000);
   txpos := x1; typos := y1;
   for c := y1 to y2 do
    if (c=y1) or (bottomline <> first) then
     begin
      drawone( x1, c, pstringobj(bottomline)^.s );
      bottomline := bottomline^.next;
     end;
     bottomline := bottomline^.prev;
   show;
  end;

 procedure listviewer._end;
  var
   c : byte;
  begin
   if (first = nil) or (bottomline = last) then exit;
   thisline := numlines;
   bottomline := last;
   topline := bottomline;
   writeto := @work;
   fillbox(x1,y1,x2,y2,$0000);
   txpos := x1; typos := y2;
   for c := y2 downto y1 do
   if (c=y2) or (topline <> last) then    
     begin
      drawone( x1, c, pstringobj(topline)^.s );
      dec(thisline);
      topline := topline^.prev;
     end;
     topline := topline^.next;
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

 procedure listviewer.dowhilelooping;
  begin
  end;

 procedure listviewer.view;
  var
   alldone : boolean;
  begin
   home;
   alldone := false;
   repeat
    if keypressed then case readkey of
     #27 : alldone := true;
     #0  : case readkey of
            #72: arrowup; {when you press the UP arrow!}
            #80: arrowdown; {when you press the DOWN arrow!}
            #71: home;
            #79: _end;
            #73: pageup;
            #81: pagedown;
           end;
     end;
    dowhilelooping;
   until alldone;
 end;

procedure listviewer.drawone( a, b : byte; s: string );
 var t : byte;
 begin
  tcolor := tcolorinit;
  txpos := a;
  typos := b;
  s := s + '|%|_';
  for t := 1 to length( s ) do
   if txpos < x2 then cwrite( s[t] );
 end;

procedure listlighter.home;
 begin
  listviewer.home;
  highline := topline;
 end;

procedure listlighter.arrowup;
 begin
  listviewer.arrowup;
 end;

procedure listlighter.arrowdown;
 begin
  listviewer.arrowdown;
 end;

end.