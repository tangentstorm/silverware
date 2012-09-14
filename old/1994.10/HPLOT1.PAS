{$M 6044,0,655360}
Program HPlot1;
uses crt,crtstuff,moustuff,bgistuff,graph,sndstuff,filstuff;

{$I C_Hair.cur}
{$I CrsBox.cur}
{$I HPlot.cur}

type
 linrec = record
  x1, y1, x2, y2 : integer;
  isbox : boolean;
 end;

const
 linnotthere : linrec = (x1:-1);

var
 linarray : array[ 1 .. 500 ] of linrec;
 lincount : word;
 lintemp  : linrec;

procedure drawline( a, b, c, d, color : byte );
 var
  m : real;
  x,y,lasty : integer;
 procedure drawvertical( a, b, d : byte );
  var count : byte;
  begin
   for count := min( b, d ) to max( b, d ) do colorxy( a, count, color, 'Û' );
  end;
 begin
  if min( a, c ) = a then lasty := b else lasty := d;
  if
   ( a - c ) <> 0
  then
   begin
    m := (b-d) / (a-c);
    for x := max( 1, min( a, c )) to min( 80, max( a, c )) do
    begin
     y := round (m * ( x - a )) + b;
     if
      abs( y - lasty ) > 1
     then
      if
       min( y, lasty ) = y
      then
       drawvertical( x, lasty-1, y )
      else
       drawvertical( x, lasty+1, y );
     lasty := y;
     colorxy( x, y, color, 'Û' );
    end; { for x.. }
   end { if..then }
  else
   drawvertical( a, b, d );
 end; { procedure }

type
 mens = ( home, tools );

const
 hplotstr = '|rHappy Plot II |k: The Plot Thickens';
 adefault = '|k(|Bc|k)|K1994 |kÄ|BS|b³LVîâWêâî|kÄ';
 filename = 'HPLOT1.HAP';
 paperx = 20;
 papery = 40;
 menux  = 460;
 menuy  = 40;
 menun  = 5;
 menun2 = 6;
 gridsize = 10;
 portx  = 460;
 porty  = 360;
 men : mens = home;
 gridstate : boolean = on;
 snapstate : boolean = on;
 onoff : array[ false .. true ] of string[3] = ('On', 'Off' );

procedure send( value : byte );
 var
  c : byte;
 begin
  showmouse( off );
  for
   c := 0 to 7
  do
   begin
    if
     boolean(truth( value and power( 2, c ) ))
    then
     setfillstyle( solidfill, 4 )
    else
     setfillstyle( solidfill, 2 );
    bar( portx + 11 + c * 17, porty + 21,
         portx + 19 + c * 17, porty + 59 );
   end;
  port[ 888 ] := value;
  showmouse( on );
 end;

procedure announce( s : string );
 begin
  showmouse( off );
  setfillstyle( solidfill, 15 );
  bar( 1, getmaxy - 19, getmaxx-1, getmaxy-1 );
  if s = '' then s := adefault;
  ctextxy( getmaxx div 2 - ( ctextwidth( s ) div 2), getmaxy - 13, s );
  showmouse( on );
 end;

procedure drawpaper;
 var
  w : integer;
  m : boolean;
 begin
  m := mvisible;
  showmouse( off );
  whitebox( paperx-1, papery-1, paperx + 401, papery + 401 );
  if (gridstate = on) then
   begin
    setcolor( cyan );
    SetLineStyle(DottedLn,0,NormWidth);
    w := paperx + gridsize;
    repeat
     line( w, papery, w, papery + 400 );
     inc( w, gridsize );
    until w >= paperx + 400;
    w := papery + gridsize;
    repeat
     line( paperx, w, paperx + 400, w );
     inc( w, gridsize );
    until w >= papery + 400;
    SetLineStyle(solidLn,0,NormWidth);
    line( paperx, papery + 200, paperx + 400, papery + 200 );
    line( paperx + 200, papery, paperx + 200, papery + 400 );
   end;
  setcolor( 0 );
  w := 0;
  while w < lincount do
   begin
    w := w + 1;
    with linarray[ w ] do
     if isbox then
      rectangle( paperx + x1, papery + y1, paperx + x2, papery + y2 )
     else
      line( paperx + x1, papery + y1, paperx + x2, papery + y2 );
    end;
  showmouse( m );
 end;

var
 men1 : array[ 0 .. menun ] of button;
 men2 : array[ 0 .. menun2 ] of button;

const
 s : array[ 0 .. menun ] of string = { button text }
  ( '|rN|kew',
    '|rL|koad',
    '|rS|kave',
    '|rP|klot',
    '|rT|kools',
    '|kE|rx|kit' );
 s2 : array[ 0 .. menun2 ] of string = { button text }
  ( '|rL|kine',
    '|rB|kox',
    '|rU|kndo',
    '|rE|krase',
    '|kTurn |rG|krid',
    '|kTurn |rS|knap',
    '|rH|kome' );

procedure grid( setto : boolean );
 begin
  if setto = gridstate then exit
  else gridstate := setto;
  men2[4].newmessage( s2[4]+' '+onoff[ gridstate ] ); { grid thing }
  drawpaper;
 end;

procedure snap( setto : boolean );
 begin
  if setto = snapstate then exit
  else snapstate := setto;
  men2[5].newmessage( s2[5]+' '+onoff[ snapstate ] ); { grid thing }
 end;


procedure setmen( m : mens );
 var
  a : byte;
 begin
  if m = men then exit;
  showmouse( off );
  setfillstyle( solidfill, 9 );
  bar( menux, menuy, getmaxx, porty - 5 );
  case m of
   home : for a := 0 to menun do men1[a].draw;
   tools : for a := 0 to menun2 do men2[a].draw;
  end;
  setgcurs( hplot );
  showmouse( on );
  men := m;
 end;

procedure drawscreen;
 var
  a : byte;
 begin
  settextstyle( Defaultfont, horizdir, 1 );
  setfillstyle( solidfill, 9 );
  bar( 0, 20, getmaxx, getmaxy );
  whitebox( 0, 0, getmaxx, 20 );
  ctextxy( getmaxx div 2 - ( ctextwidth( HPlotstr ) div 2), 7, HPlotstr );
  whitebox( 0, getmaxy - 20, getmaxx, getmaxy );
  announce( '' );
  drawpaper;
  for a := 0 to menun do
   men1[a].init( menux, menuy + 40 * a, menux + 150, menuy + 30 + 40 * a, s[a] );
  for a := 0 to menun2 do
   men2[a].init( menux, menuy + 40 * a, menux + 150, menuy + 30 + 40 * a, s2[a] );
  men2[4].newmessage( s2[4]+' '+onoff[ gridstate ] ); { grid thing }
  men2[5].newmessage( s2[5]+' '+onoff[ snapstate ] ); { grid thing }
  setmen( tools );
  setmen( home );
  whitebox( portx, porty, portx + 150, porty + 80 );
  setfillstyle( solidfill, 7 );
  for
   a := 0 to 7
  do
   begin
    bar( portx + 13 + a * 17, porty + 23, portx + 23 + a * 17, porty + 63 );
    rectangle( portx + 10 + a * 17, porty + 20,
               portx + 20 + a * 17, porty + 60 );
    end;
  send( 0 );
 end;

procedure linemode( boxes : boolean );
 var
  tx, ty, x, y, a, b : integer;
  quit : boolean;
 procedure dosnap;
  begin
   if
    (x mod gridsize) > (gridsize div 2)
   then
    inc( x, gridsize - x mod gridsize )
   else
    dec( x, x mod gridsize );
   if
    (y mod gridsize) > (gridsize div 2)
   then
    inc( y, gridsize - y mod gridsize )
   else
    dec( y, y mod gridsize );
   setmpos( mx, my );
  end;
 procedure doline;
  begin
   x := mx;
   y := my;
   if snapstate then dosnap;
   if
    a=-1
   then
    begin
     a := x;
     b := y;
    end
   else
    begin
     showmouse( off );
     setcolor( 0 );
     if not boxes then
      line( a, b, x, y )
     else
      rectangle( a, b, x, y );
     lincount := inc2( lincount, 1, 500 );
     with linarray[lincount] do
      begin
       x1 := a - paperx;
       y1 := b - papery;
       x2 := x - paperx;
       y2 := y - papery;
       isbox := boxes;
      end;
     showmouse( on );
       a := -1;
    end;
  end;
 procedure ghostline;
  begin
   if a = -1 then exit;
   x := mx;
   y := my;
   if snapstate then dosnap;
   showmouse( off );
   setwritemode( xorput );
   setcolor( 15 );
   if not boxes then
    begin
     line( a, b, x, y  );
     showmouse( on );
     delay( 10 );
     showmouse( off );
     line( a, b, x, y  );
    end
   else
    begin
     rectangle( a, b, x, y  );
     showmouse( on );
     delay( 10 );
     showmouse( off );
     rectangle( a, b, x, y  );
    end;
   setwritemode( normalput );
   showmouse( on );
  end;
 begin
  tx := mx;
  ty := my;
  a := -1;
  setcolor( 0 );
  if boxes then setgcurs( crsbox ) else setgcurs( c_hair );
  setmwin( paperx, papery, paperx + 400, papery + 400 );
  setmpos( paperx + 200, papery + 200 );
  quit := false;
  repeat
   getmpos;
   if (lmx <> mx) or (lmy<>my) then
    begin
     x := mx;
     y := my;
     if snapstate then dosnap;
     announce( 'X : '+n2s(x - paperx )+ ' ,  Y : '+n2s(y - papery ) );
    end;
   if keypressed then
    case readkey of
     #0 : begin
           case readkey of
            #72: setmpos( mx, my-gridsize );
            #80: setmpos( mx, my+gridsize );
            #75: setmpos( mx-gridsize, my );
            #77: setmpos( mx+gridsize, my );
           end;
          end;
     #13: doline;
     #27: quit := true;
    end
  else
   if (ms and 1 <> 0) then
    begin
     doline;
     repeat
      getmpos;
      ghostline;
     until (ms and 1 = 0);
    end
   else
    ghostline;
   if ( ms and 2 <> 0 ) then
    begin
     repeat getmpos until ms and 2 = 0;
     if ( a <> -1 ) then a := -1
      else quit := true;
    end;
  until quit;
  setmwin( 0, 0, getmaxx, getmaxy );
  setgcurs( hplot );
  setmpos( tx, ty );
  announce( '' );
 end;

procedure shutdown;
 var
  a : byte;
 begin
  for a := 0 to menun do men1[a].done;
  closegraph;
 end;

var
 a,b : byte;
 ch : char;
 finished : boolean;

procedure newarray;
 var
  w : word;
 begin
  lincount := 0;
  for w := 1 to 500
   do linarray[ w ] := linnotthere;
 end;

procedure getfilename( doload : boolean );
 begin
 end;

procedure load;
 var
  f : file;
  w : word;
 begin
  getfilename( on );
  if not fileexists( filename ) then exit;
  newarray;
  filereset( f, filename );
  if nextstring( f ) <> 'HAPPY-PLOT' then
   begin
    spkr.beep;
    announce( '|rThis is an Unhappy Plot File...');
    exit;
   end;
  lincount := nextword( f );
  w := 0;
  while w < lincount do
   begin
    inc( w );
    linarray[ w ].x1 := nextword( f );
    linarray[ w ].y1 := nextword( f );
    linarray[ w ].x2 := nextword( f );
    linarray[ w ].y2 := nextword( f );
    linarray[ w ].isbox  := nextboolean( f );
   end;
  close( f );
  drawpaper;
 end;

procedure save;
 var
  f : file;
  w : word;
 begin
  getfilename( off );
  announce( '|kFilename: |B' + Filename );
  filerewrite( f, filename );
  savestring( f, 'HAPPY-PLOT');
  saveword( f, lincount );
  w := 0;
  while w < lincount do
   begin
    inc( w );
    saveinteger( f, linarray[ w ].x1 );
    saveinteger( f, linarray[ w ].y1 );
    saveinteger( f, linarray[ w ].x2 );
    saveinteger( f, linarray[ w ].y2 );
    saveboolean( f, linarray[ w ].isbox );
   end;
  close( f );
 end;

procedure undo;
 begin
  if lincount = 0 then
   begin
    announce( '|rNothing Left to Undo!' );
    {spkr.ding;}
    delay( 1000 );
    announce('');
    exit;
   end;
  linarray[ lincount ] := linnotthere;
  lincount := lincount - 1;
  drawpaper;
 end;

procedure init;
 begin
  finished := false;
  if not mousethere then
   begin
    cwriteln('|!K|RError: Mouse driver not present!!');
    halt( 1 );
   end;
  newarray;
  initgrafx;
  drawscreen;
  mouseon;
  setgcurs( hplot );
  randomize;
 end;

begin
 init;
 while not finished do
  if
   keypressed
  then
   case men of
    home  : case upcase( readkey ) of
             #0  : if keypressed then ch := readkey;
             'N' : begin newarray; drawpaper; send( 0 ); end; { new }
             'L' : load; { load }
             'S' : save; { save }
             'P' : send( random(256) ); { plot }
             'T' : setmen( tools ); { tools }
             'X' : finished := true; { exit }
            end;
    tools : case upcase( readkey ) of
             #0  : if keypressed then ch := readkey;
             'L' : linemode( false ); { line }
             'B' : linemode( true ); { box }
             'U' : undo; { undo }
             'E' : spkr.beep; { erase }
             'G' : grid( not gridstate ); { grid }
             'S' : snap( not snapstate ); { snap }
             'H' : setmen( home ); { home }
            end;
   end { case }
  else
   case men of
    HOME:
     for a := 0 to menun do
      if
       men1[a].click
      then
       case a of
        0 : begin newarray; drawpaper; send( 0 ); end; { new }
        1 : load; { load }
        2 : save; { save }
        3 : send( random( 256 ) ); { plot }
        4 : setmen( tools ); { tools }
        5 : finished := true;   { exit }
       end;
    TOOLS:
      for a := 0 to menun2 do
       if
        men2[a].click
       then
        case a of
         0 : linemode( false ); { line }
         1 : linemode( true ); { box }
         2 : undo; { undo }
         3 : spkr.beep; { erase }
         4 : grid( not gridstate ); { grid }
         5 : snap( not snapstate ); { snap }
         6 : setmen( home );   { home }
        end;
    end;
 shutdown;
end.