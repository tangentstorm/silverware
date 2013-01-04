{ conway's game of life
------------------------------------------------------}
{$i xpc.inc}
program life;
uses cw, crt, num, xpc;

const
  up	= #72;
  down	= #80;
  right	= #77;
  left	= #75;

{--[ Defines & Variables ]--------------------------------}

const
  dead_char  = '.'; //'·';  { dot operator }
  alive_char = 'x'; //'▪';  { small square }
  dead	     = 0;
  alive	     = 1;
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
    crt.cursoroff;
    gotoxy( 1, 1 );
    for b := 1 to grid.h do begin
      for a := 1 to grid.w do begin
	if grid.cells[ a, b ] = alive
	  then colorxy( a, b, $02, alive_char )
	  else colorxy( a, b, $08, dead_char )
      end;
    end
  end;

  procedure seedthegrid;
    var
      ch   : char;
      a, b : cardinal;
  begin
    iteration := 0;
    a := grid.w div 2;
    b := grid.h div 2;

    drawthegrid;
    cwritexy( 1, 1, 'move cursor with arrows. use space to toggle cell; enter to start sim.' );

    crt.gotoxy( a, b);
    crt.cursoron;
    repeat ch := crt.readkey;
      case ch of
	#0  : begin
	       ch := crt.readkey;
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
	else pass { ignore key }
      end;
      gotoxy( a, b );
    until ch = #13;
    crt.cursoroff;
  end;

  procedure init;
  begin
    crt.clrscr;
    grid := agrid.create( crt.windMaxX, crt.windMaxY );
    temp := agrid.create( crt.windMaxX, crt.windMaxY );
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
    for a := 1 to grid.w do for b := 1 to grid.h do grid.cells[ a, b ] := temp.cells[ a,b ]
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
    crt.cursoron;
  end;

{--[ Main Program ]---------------------------------------}

begin
 init;
 run;
 done;
end.
