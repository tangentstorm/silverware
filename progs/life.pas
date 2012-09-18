program life;           { implements the game of life }
uses crt, crtstuff;

{--[ Defines & Variables ]--------------------------------}

const
	maxx = 80;
	maxy = 20;

  dead  = ' ';
  alive = 'þ';

type
	agrid = array[ 0..maxx+1, 0..maxy+1 ] of char; { grid + "dead" border }

var
	grid : agrid;
  iteration : integer;

{--[ Procedures ]-----------------------------------------}

procedure drawthegrid;
	var
  	a, b : integer;
	begin
   	for b := 1 to maxy do
	  	for a := 1 to maxx do
      	colorxy( a, b, green, grid[ a, b ] )
  end;

procedure seedthegrid;
	var
  	ch : char;
    a, b : integer;
	begin
  	iteration := 0;
    a := maxx div 2;
    b := maxy div 2;
    gotoxy(a,b);
    doscursoron;
    repeat ch := readkey;
    	case ch of
      	#0 :
					case readkey of
            up: b := decwrap( b, 1, 1, maxy );
            down: b :=incwrap( b, 1, 1, maxy );
            left: a := decwrap( a, 1, 1, maxx );
            right: a := incwrap( a, 1, 1, maxx );
          end;
        #32 :
        	begin
			  		if grid[ a, b ] = alive then
	          	grid[ a, b ] := dead
	          else
	          	grid[ a, b ] := alive
						;
            drawthegrid;
          end;
      end;
    	gotoxy( a, b );
    until ch = #27;
		doscursoroff;
  end;

procedure init;
	var
  	a, b : integer;
	begin
  	clrscr;
  	for a := 0 to maxx+1 do
    	for b := 0 to maxy+1 do
      	grid[ a, b ] := dead;
    seedthegrid;
	end;

function numliveneighbors( x, y : integer ) : byte;
	var
  	counter : byte;
	begin
  	counter := 0;                                   { keypad direction }
    if grid[ x-1, y-1 ] = alive then inc( counter); { 7 }
    if grid[ x-1, y   ] = alive then inc( counter); { 4 }
    if grid[ x-1, y+1 ] = alive then inc( counter); { 1 }
    if grid[ x  , y-1 ] = alive then inc( counter); { 8 }

    if grid[ x  , y+1 ] = alive then inc( counter); { 2 }
    if grid[ x+1, y-1 ] = alive then inc( counter); { 9 }
    if grid[ x+1, y   ] = alive then inc( counter); { 6 }
    if grid[ x+1, y+1 ] = alive then inc( counter); { 3 }
    numliveneighbors := counter;
	end;

procedure iterate;
	var
    a, b : integer;
  	tempgrid : agrid;
	begin
  	tempgrid := grid; {to snag the borders}
    for a := 1 to maxx do
    	for b := 1 to maxy do
      	case grid[ a, b ] of
        	alive:
						case numliveneighbors( a, b ) of		{ using case to allow }
					  	2,3: tempgrid[ a, b ] := alive;		{ messing with the rules }
					    else tempgrid[ a, b ] := dead;		{ later on.}
					    end;
          dead:
          	case numliveneighbors( a, b ) of		{ see above }
            	3 : tempgrid[ a, b ] := alive;
              else
              	tempgrid[ a, b ] := dead;
            end;
          else
        end;
  	inc( iteration );
    grid := tempgrid;
	end;

procedure run;
	var
  	ch : char;
	begin
    ch := #0;
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
		until (ch in [#27,#13])
	end;

procedure done;
	begin
  	textmode( co80 );
  	doscursoron;
	end;


{--[ Main Program ]---------------------------------------}

begin
	init;
	run;
	done;
end.