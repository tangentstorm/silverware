Program WordZ;
uses crt;
type
 myrec = record
  s : string[ 80 ];
  u : boolean;
 end;
var
 m : byte;
 n : string;
 f : text;
 w : array[ 0 .. 256 ] of myrec;
 c : word;
 o,t : byte;
 j : string;
 ch : char;
begin
 clrscr;
 randomize;
 n := 'E:\WORDS.TXT';
 m := 115;
 assign( f, n );
 reset( f );
 for c := 0 to m-1 do
  begin
   readln( f, w[c].s );
   w[c].u := false;
  end;
 {jumble}
 for c := 1 to 5048 do
  begin
   o := random( m );
   t := random( m );
   j := w[ o ].s;
   w[ o ].s := w[ t ].s;
   w[ t ].s := j;
  end;
 {end jumble}
 for c := 1 to 20 do
  begin
    repeat
     t := random( c );
    until not w[t].u;
    writeln( w[t].s );
    w[t].u := true;
  end;
 while keypressed do ch := readkey;
 repeat until keypressed;
end.