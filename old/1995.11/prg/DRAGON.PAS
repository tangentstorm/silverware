program
 dragon;

{ Implements a Dragon Curve }

uses
 bgistuff, graph, grafx, crt, crtstuff;

Const
 MaxVerts = 4096 * 2 + 2;

Var
 XCA ,
 YCA : Array[ 1 .. MaxVerts ] of integer;
 Color : Byte;
 step, sign : integer;

procedure dragoncurve( generation : byte );
 var
  i, j, dx, dy, power : integer;
 begin
  setcolor( 15 );
  power := 1;
  for
   i := 1 to Generation - 1
  do
   power := power * 2;
  step := (MaxVerts - 2 ) div power;
  clearviewport;
  j := step div 2;
  i := 1;
  repeat
    dx := xca[ i + step ] - xca[ i ];
    dy := yca[ i + step ] - yca[ i ];
    sign := sign * -1;
    xca[ i + j ] := xca[ i ] + ( dx + ( dy * sign )) div 2;
    yca[ i + j ] := yca[ i ] + ( dy - ( dx * sign )) div 2;
    setcolor( color );
    line( xca[ i ], yca[ i ], xca[ i + j ], yca[ i + j ]);
    line( xca[ i + j ], yca[ i + j ], xca[ i + step ], yca[ i + step ] );
    inc( i, step );
  until i >= maxverts - 2;
  color := color + 1;
  step := step div 2;
  getenter;
  if generation < 14 then dragoncurve( generation + 1 );
 end;

begin
 InitGrafx;
 sign :=  -1;
 color := 1;
 step := maxverts - 2;
 XCA[ 1 ] := GetMaxX div 4 -20;
 XCA[ maxverts - 1 ] := 3 * GetMaxX div 4 -20;
 YCA[ 1 ] :=  2 * GetMaxY div 3;
 YCA[ maxverts - 1 ] := 2 * GetMaxY div 3;
 dragoncurve( 1 );
 repeat until enterpressed;
 closegraph;
end.