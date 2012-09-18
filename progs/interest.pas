{$N-}
program interest;
uses crt,crtstuff;


Var
  balance, rate, deposit, now : real;
  year, month : byte;
  pal : string;


begin
 clrscr;
 pal := 'bBcCMR';
 balance := 225.24;
 balance := 100000;
 rate := 1 + 2/1200;
 deposit := 00;
 for year := 1 to 1 do
  begin
   cwrite('|'+pal[year]);
   getenter;
   for month := 1 to 12
    do
   begin
    now := (balance + deposit) * rate;
    write( 'B: ', balance:10:2, ' + D: ', deposit:10:2, ' x ',
           (rate * 100):4:1, '% = ', now:10:2 );
    balance := now;
    cwriteln('');
   end;
    deposit := deposit + 0; if deposit > 200 then deposit := 200;
    rate := rate + 0.00; { annual increase in rate? }
  end;
end.