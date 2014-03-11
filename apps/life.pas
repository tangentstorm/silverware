{ conway's game of life
------------------------------------------------------}
{$mode delphiunicode}{$i xpc.inc}
program life;
uses cw, kvm, kbd, num, xpc;

const
  up	= #72;
  down	= #80;
  right	= #77;
  left	= #75;

{--[ Defines & Variables ]--------------------------------}

const
  dead_char  : TChr = '·';  { dot operator }
  alive_char : TChr = '▪';  { small square }
  dead	       = 0;
  alive	       = 1;
type
  array2d = array of array of byte;
  agrid	  = class
    w, h   : cardinal;
    cells : array2d;
    constructor create( width, height :  cardinal );
  end;

var
  grid, temp : agrid;
  iteration  : cardinal;

{--[ Procedures ]-----------------------------------------}

  constructor agrid.create( width, height :  cardinal );
    var x, y : cardinal;
  begin
    {   The reason for the + 1 in the two setlength calls is
    | that there's a border of dead cells around the grid.
    |   This lets us check all 8 neighbors even on the edge.
    }
    self.w := width-1;
    self.h := height-1;
    setlength( self.cells, width + 1 );
    for x := 0 to width do begin
      setlength( self.cells[ x ], height + 1 );
      for y := 0 to height do self.cells[ x, y ] := dead;
    end;
  end;

  procedure drawthegrid;
    var a, b : integer;
  begin
    kvm.hidecursor;
    for b := 0 to grid.h do begin
      for a := 0 to grid.w do begin
	if grid.cells[ a, b ] = alive
	  then cxy( $02, a, b, alive_char )
	  else cxy( $08, a, b, dead_char )
      end;
    end
  end;



  var a : cardinal = 999; b : cardinal = 0;
 
  procedure seedthegrid;
    var ch : char;
  begin
    iteration := 0;
    if a = 999 then begin
      a := grid.w div 2;
      b := grid.h div 2;
    end else ok; // center cursor at start, then let it persist.
    drawthegrid;
    cwritexy(0,0,'|wmove cursor with |Warrows|w. use |Wspace to toggle|w cell. ');
    cwritexy(0,1,'press |Wenter to start|w the simulation.' );

    kvm.gotoxy( a, b);
    repeat
      kvm.showcursor; ch := kbd.readkey;
      case ch of
	#0  : begin
	       ch := kbd.readkey;
	       case ch of
		 up    : b := num.decwrap( b, 1, 1, grid.h );
		 down  : b := num.incwrap( b, 1, 1, grid.h );
		 left  : a := num.decwrap( a, 1, 1, grid.w );
		 right : a := num.incwrap( a, 1, 1, grid.w );
		 else begin
		   writeln( 'don''t know how  to handle key #', ord(ch));
		   writeln( 'readkey:', ord(readkey));
		 end
	       end;
	     end;
	#32 : begin
		if grid.cells[ a, b ] = alive
		  then grid.cells[ a, b ] := dead
		  else grid.cells[ a, b ] := alive;
		drawthegrid;
	      end;
	^C  : halt( 1 );
	else ok { ignore key }
      end;
      gotoxy( a, b );
    until ch = #13;
    kvm.hidecursor;
  end;

  procedure init;
  begin
    kvm.clrscr;
    grid := agrid.create( kvm.width, kvm.height );
    temp := agrid.create( kvm.width, kvm.height );
    seedthegrid;
  end;


  function numliveneighbors( x, y : integer ) : byte;
    var counter : byte;
  begin
    counter := 0;                                   { keypad direction }
    with grid do begin
      if cells[ x-1, y-1 ] = alive then inc( counter ); { 7 nw }
      if cells[ x-1, y   ] = alive then inc( counter ); { 4 w  }
      if cells[ x-1, y+1 ] = alive then inc( counter ); { 1 sw }

      if cells[ x  , y-1 ] = alive then inc( counter ); { 8 n  }
      if cells[ x  , y+1 ] = alive then inc( counter ); { 2 s  }

      if cells[ x+1, y-1 ] = alive then inc( counter ); { 9 ne }
      if cells[ x+1, y   ] = alive then inc( counter ); { 6 e  }
      if cells[ x+1, y+1 ] = alive then inc( counter ); { 3 se }
    end;
    numliveneighbors := counter;
  end;

  procedure iterate;
    var
      a, b     : integer;
  begin
    for a := 1 to grid.w do
      for b := 1 to grid.h do
	case grid.cells[ a, b ] of
	  alive :
	    case numliveneighbors( a, b ) of	    { using case to allow }
	      2, 3 : temp.cells[ a, b ] := alive;   { messing with the rules }
	      else temp.cells[ a, b ] := dead;	    { later on.}
	    end;
	  dead :
	    case numliveneighbors( a, b ) of	{ see above }
	      3	: temp.cells[ a, b ] := alive;
	      else temp.cells[ a, b ] := dead;
	    end;
	  else
	end;
    inc( iteration );
    for a := 1 to grid.w do for b := 1 to grid.h do
      grid.cells[ a, b ] := temp.cells[ a,b ]
  end;

  procedure run;
    var ch : char = #0;
  begin
    repeat
      drawthegrid;
      iterate;
      if keypressed then
      begin
	ch := readkey;
	case ch of
	  #32 : seedthegrid;
	end;
      end;
    until ch in [ #27, ^C ]
  end;

  procedure done;
  begin
    kvm.showcursor;
  end;

{--[ Main Program ]---------------------------------------}

begin
 init;
 run;
 done;
end.
