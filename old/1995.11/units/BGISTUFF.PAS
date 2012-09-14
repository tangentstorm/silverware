Unit BGIstuff;

InterFace

  Procedure InitGrafx;
  Function ctextwidth( s : string ) : word;
  Procedure ctextxy( x, y : integer; s : string );
  Procedure whitebox( x1, y1, x2, y2 : integer );
  procedure drawline( x1, y1, x2, y2 : integer; c : byte );

type
 button = object
  x1, y1, x2, y2 : integer;
  size : word;
  message : string;
  norm, select, back : pointer;
  constructor init( a1, b1, a2, b2 : integer; s : string );
  procedure getback; virtual;
  procedure getnorm; virtual;
  procedure getselect; virtual;
  procedure free( var p : pointer );
  procedure draw;
  procedure invert;
  procedure erase;
  procedure move( a, b : integer );
  procedure newmessage( s : string );
  function click : boolean;
  destructor done;
 end;

Implementation
  Uses crtstuff,moustuff,Graph,BGIDriv,BGIFont;

procedure Abort(Msg : string);
begin
  Writeln(Msg, ': ', GraphErrorMsg(GraphResult));
  Halt(1);
end;

Procedure InitGrafx;
  var
   grDriver : Integer;
   grMode   : Integer;
   ErrCode  : Integer;
  begin
   if RegisterBGIdriver(@CGADriverProc) < 0 then Abort('CGA');
   if RegisterBGIdriver(@EGAVGADriverProc) < 0 then Abort('EGA/VGA');
   if RegisterBGIdriver(@HercDriverProc) < 0 then Abort('Herc');
   if RegisterBGIdriver(@ATTDriverProc) < 0 then Abort('AT&T');
   if RegisterBGIdriver(@PC3270DriverProc) < 0 then Abort('PC 3270');
   if RegisterBGIfont(@GothicFontProc) < 0 then  Abort('Gothic');
   if RegisterBGIfont(@SansSerifFontProc) < 0 then  Abort('SansSerif');
   if RegisterBGIfont(@SmallFontProc) < 0 then Abort('Small');
   if RegisterBGIfont(@TriplexFontProc) < 0 then Abort('Triplex');
   grDriver := Detect;
   InitGraph(grDriver,grMode,'');
   ErrCode := GraphResult;
   if ErrCode <> grOk then WriteLn('Graphics error:',GraphErrorMsg(ErrCode));
   SetTextStyle(SmallFont,HorizDir,4);
  end;

function ctextwidth( s : string ) : word;
 begin
  ctextwidth := clength( s ) * textwidth('M');
 end;

procedure ctextxy( x, y : integer; s : string );
 var
  c : byte;
  d : boolean;
 begin
  moveto( x, y );
  c := 1;
  while
   c <= length( s )
  do
   begin
    setcolor( tcolor );
    repeat
     d := cwcommandmode;
     if d then inc( c );
     cwrite( s[ c ] );
    until not cwcommandmode;
    if not d or cwcommandmode then
     begin
      outtextxy( getx, gety, s[ c ]);
      moveto( getx + ctextwidth(s[c]), gety );
     end;
    inc( c );
   end;
 end;

procedure whitebox( x1, y1, x2, y2 : integer );
 var
  tc : byte;
 begin
  tc := getcolor;
  setfillstyle( solidfill, 0 );
  bar( x1+5, y2, x2+5, y2+5 );
  bar( x2, y1+5, x2+5, y2 + 5 );
  setfillstyle( solidfill, 15 );
  bar( max( -1, x1), y1, x2, y2 );
  setcolor( 0 );
  rectangle( max( -1, x1), y1, x2, y2 );
  setcolor( tc );
 end;

 procedure drawline( x1, y1, x2, y2 : integer; c : byte );
  begin
   setcolor( c );
   line( x1, y1, x2, y2 );
  end;


{BUTTON}

constructor button.init( a1, b1, a2, b2 : integer; s : string );
 begin
  x1 := a1;
  y1 := b1;
  x2 := a2;
  y2 := b2;
  size := imagesize( x1, y1, x2 + 5, y2 + 5 );
  message := s;
  norm := nil;
  select := nil;
  back := nil;
  getback;
 end;

procedure button.getback;
 begin
  if back <> nil then free( back );
  getmem( back, size );
  getImage( x1, y1, x2 +5, y2 + 5, back^ );
 end;

procedure button.getnorm;
 begin
  if norm <> nil then free( norm );
  whitebox( x1, y1, x2, y2 );
  ctextxy( x1+ 10, y1 + 10, message );
{  getmem( norm, size );
  getimage( x1, y1, x2 +5, y2 + 5, norm^ );}
 end;

procedure button.getselect;
 begin
  if select <> nil then free( select );
  setcolor( 0 );
  setfillstyle( solidfill, 15 );
  bar( x1 + 4, y1 + 4, x2 + 4, y2 + 4 );
  rectangle( x1 + 4, y1 + 4, x2 + 4, y2 + 4 );
  ctextxy( x1+ 15, y1 + 15, message );
 { getmem( select, size );
  getimage( x1, y1, x2 + 5, y2 + 5, select^ );}
 end;

procedure button.free( var p : pointer );
 begin
  if p <> nil then freemem( p, size );
  p := nil;
 end;

procedure button.draw;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  if
   norm <> nil then putimage( x1, y1, norm^, normalput )
  else
   begin
    erase;
    getnorm;
   end;
  showmouse( mv );
 end;

procedure button.invert;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  if
   select <> nil
  then
   putimage( x1, y1, select^, normalput )
  else
   begin
    erase;
    getselect;
   end;
  showmouse( mv );
 end;

procedure button.erase;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  putimage( x1, y1, back^, normalput );
  showmouse( mv );
 end;

procedure button.move( a, b : integer );
 var
  w, h : integer;
 begin
  erase;
  free( back );
  free( norm );
  free( select );
  w := x2 - x1;
  h := y2 - y1;
  x1 := a;
  x2 := a + w;
  y1 := b;
  y2 := b + h;
  getback;
  draw;
 end;

procedure button.newmessage( s : string );
 begin
  free( norm );
  free( select );
  message := s;
  draw;
 end;

function button.click : boolean;
 begin
  getmpos;
  if
   (ms and $01 <> 0)
   and (mx > x1 ) and (mx < x2 )
   and (my > y1 ) and (my < y2 )
  then
   begin
    invert;
    repeat
     getmpos
    until (ms and $01 = 0)
     or (mx <= x1 ) or (mx >= x2 )
     or (my <= y1 ) or (my >= y2 );
    draw;
    if
     (mx > x1 ) and (mx < x2 ) and (my > y1 ) and (my < y2 )
    then
     click := true { clicked & released on box }
    else
     click := false; { released outside of box }
   end
  else
   click := false; { never even clicked in box }
 end;

destructor button.done;
 begin
  free( back );
  free( norm );
  free( select );
 end;

End.