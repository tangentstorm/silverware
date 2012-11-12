unit stri; { string interface }
interface

  function pad( s : string; len : byte; ch : char ) : string;
  function chntimes( c : char; n : byte ) : string;
  function ntimes( const s : string; n : byte ) : string;
  function flushrt( s : string; n : byte; ch : char ) : string;
  function trunc( s : string; len : byte ) : string;

implementation

  function chntimes( c : char; n : byte ) : string; inline;
    var i : byte; s : string = '';
  begin
    for i := 1 to n do s := s + c;
    result := s;
  end;

  function ntimes( const s : string; n : byte ) : string; inline;
    var i : byte;
  begin
    result := s;
    for i := 1 to n - 1 do result := result + s;
  end;

  { todo : profile this. }
  function flushrt( s : string; n : byte; ch : char ) : string;
  begin
    if length( s ) < n then insert( chntimes( ch, n-length( s )), s, 1 );
    result := s;
  end;

  function pad( s : string; len : byte; ch : char ) : string;
  begin
    if length( s ) > len then s := trunc( s, len );
    while length( s ) < len do s := s + ch;
    result := s;
  end;

  function trunc( s : string; len : byte ) : string;
  begin
    if ord( s[ 0 ] ) > len then s[ 0 ] := chr( len );
    result := s;
  end;

end.
