uses crtstuff;


type
 string7 = string[7];

const
 binarray : array[ 1 .. 25 ] of string7 =

('1011001', '1101111', '1110101', '1101000', '1100001',
 '1110110', '1100101', '1101010', '1100001', '1100011',
 '1101011', '1100101', '1100100', '1101001', '1101110',
 '1110100', '1101111', '1010000', '1100001', '1110010',
 '1100001', '1100100', '1101111', '1111000', '1000010');

function bin( what : string7 ) : byte;
 var
  temp, count  : byte;
 begin
  temp := 0;
  for count := 1 to 7 do
   temp := temp + (power(2,count-1) * s2n( what[ 8 - count ]) );
  bin := temp;
 end;

var
 count : byte;
begin
 cwriteln( '|$' );
 for count := 1 to 25 do
   write( chr(bin( binarray[ count ] ) ));
end.
