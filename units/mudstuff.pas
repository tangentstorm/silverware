Unit MudStuff;
interface

type
 base = object
  Description  : array[ 1 .. 5 ] of string;
  Active       : boolean;
  MaxCapacity,
  CapacityUsed : byte;
  constructor Init( s1, s2, s3, s4, s5 : string );
  procedure   LookAt; virtual;
  procedure   Act; virtual;
 end;
 pitem = ^item;
 item = object( base )
 end;
 room = object( base )
 end;

implementation
 uses crt, crtstuff, zokstuff;

constructor base.init( s1, s2, s3, s4, s5 : string );
 begin
  description[1] := s1;
  description[2] := s2;
  description[3] := s3;
  description[4] := s4;
  description[5] := s5;
 end;

procedure base.lookat;
 var
  dc : byte;
 begin
  writeln;
  for dc := 1 to 5 do
   if length( description[dc] ) <> 0 then
    cwriteln( description[dc]);
  writeln;
 end;

end.