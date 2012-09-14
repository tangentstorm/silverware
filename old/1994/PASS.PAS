program password;
uses zokstuff,crtstuff,crt;

var
 z : zpassword;
 s : string;

begin
 checkbreak := false;
 if paramcount <> 1 then
   begin
    cwriteln('|_|wUsage: |WPASS |w<|Wpassword|w>');
    halt;
   end;
 cwrite('|_|WPassword|w>');
 z.default( txpos, typos, 15, 15, '');
 repeat
   s := z.get;
 until (upstr(s) = upstr(paramstr(1)));
end.