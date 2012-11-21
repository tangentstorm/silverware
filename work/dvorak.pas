program dvorak;
uses crt,crtstuff;

var
 dvstring : string;
 i : byte;

begin
 dvstring := '';
 for i := 1 to 255 do dvstring := dvstring + chr( i );
 cwrite( dvstring );
end.