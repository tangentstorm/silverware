unit winstuff;
{window toolbox..}

interface

 uses crtstuff,moustuff;
 type
 point = object
  x1,y1:integer;
  color:byte;
  constructor init(a1,b1:integer);
  procedure erase; virtual;
  procedure draw; virtual;
  procedure drag; virtual;
  destructor done;
 end;
 gtool = object(point)
  x2, y2 : integer;
  constructor init( a1, b1, a2, b2 : integer );
  procedure draw; virtual;
  procedure move( a, b : integer ); virtual;
  function click : boolean;
 end;




implementation

constructor point.init( a1, b1 : integer );
 begin
  x1 := a1;
  y1 := b1;
 end;

procedure point.erase;
 begin
 end;

procedure point.draw;
 begin
 end;

procedure point.drag;
 begin
 end;

destructor point.done;
 begin
 end;

constructor gtool.init( a1, b1, a2, b2 : integer );
 begin
  point.init( a1, b1 );
  x2 := a2;
  y2 := b2;
 end;

procedure gtool.draw; 
 begin
 end;

procedure gtool.move( a, b : integer ); 
 var
  w, h : integer;
 begin
  erase;
  w := x2 - x1;
  h := y2 - y1;
  x1 := a;
  y1 := b;
  x2 := a + w;
  y2 := b + h;
  draw;
 end;

function gtool.click : boolean;
 begin
 end;


eND.