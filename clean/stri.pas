unit stri; { string interface }
interface

  function pad( s : string; len : byte; ch : char ) : string;

implementation

  function trunc( s : string; len : byte ) : string;
  begin
    if ord( s[ 0 ] ) > len then s[ 0 ] := chr( len );
    result := s;
  end;

  function pad( s : string; len : byte; ch : char ) : string;
  begin
    if length( s ) > len then s := trunc( s, len );
    while length( s ) < len do s := s + ch;
    result := s;
  end;

end.
