{ The Electronomicon }
{ (c)1993 ─S┼εΓL│NG─S│LVεΓWΩΓε─ }

Program Electro;
uses crt, Crtstuff;

var
 username : string[ 30 ];

procedure delay ( x : integer );
 begin
  crt.delay( x div 2 );
 end;

procedure titlescreen;
 var
  c : byte;
  s2 : string;
 const
  s1 = '|b<|wAll Rights Reserved|b>';
  s2d = '|b(|wc|b)|w1993 |K─|wS|┼εΓL│NG|K─|wS│LVεΓWΩΓε|K─';
 begin
  s2 := '|b(|Wc|b)|w1993 '+copy(Sterling,1,length(Sterling)-1)+Silverware;
  for
   c := 1 to 12
  do
   begin
    delay( 75 );
    ccenterxy( 40, 25-c+1, '|W'+chntimes( ' ', clength( s1 ) ));
    ccenterxy( 40, 25-c, s1 );
    ccenterxy( 40, c-1, '|W'+chntimes( ' ', clength( s2 ) ));
    ccenterxy( 40, c, s2 );
   end;
  delay( 3000 );
  ccenterxy( 40, 12, s2d);
  delay( 100 );
  colorxyc( 40, 12, 8, '(c)1993 ─S┼εΓL│NG─S│LVεΓWΩΓε─');
  colorxyc( 40, 13, 8, '<All Rights Reserved>');
  delay( 100 );
  colorxyc( 40, 12, 0, '(c)1993 ─S┼εΓL│NG─S│LVεΓWΩΓε─');
  colorxyc( 40, 13, 0, '<All Rights Reserved>');
  delay( 500 );
  for c := 1 to 80 do
   begin
    delay( 25 );
    colorxyc( 40,  9, 1, chntimes( '─', c ));
    colorxyc( 40, 15, 1, chntimes( '─', c ));
   end;
  colorxyc( 40, 11, 8, '┌─ │  ┌─ ┌┐ ─── ┌─┐ ┌─┐ ┌┐│ ┌─┐ ┌│┐ │ ┌┐ ┌─┐ ┌┐│');
  colorxyc( 40, 12, 8, '── │  ── │   │  │─┘ │ │ │││ │ │ │││ │ │  │ │ │││');
  colorxyc( 40, 13, 8, '└─ └─ └─ └┘  │  │ │ └─┘ │└┘ └─┘ │ │ │ └┘ └─┘ │└┘');
  delay( 100 );
  colorxyc( 40, 11, 7, '┌─ │  ┌─ ┌┐ ─── ┌─┐ ┌─┐ ┌┐│ ┌─┐ ┌│┐ │ ┌┐ ┌─┐ ┌┐│');
  colorxyc( 40, 12, 7, '── │  ── │   │  │─┘ │ │ │││ │ │ │││ │ │  │ │ │││');
  colorxyc( 40, 13, 7, '└─ └─ └─ └┘  │  │ │ └─┘ │└┘ └─┘ │ │ │ └┘ └─┘ │└┘');
  delay( 100 );
  colorxyc( 40, 11, 14, '┌─ │  ┌─ ┌┐ ─── ┌─┐ ┌─┐ ┌┐│ ┌─┐ ┌│┐ │ ┌┐ ┌─┐ ┌┐│');
  colorxyc( 40, 12, 14, '── │  ── │   │  │─┘ │ │ │││ │ │ │││ │ │  │ │ │││');
  colorxyc( 40, 13, 14, '└─ └─ └─ └┘  │  │ │ └─┘ │└┘ └─┘ │ │ │ └┘ └─┘ │└┘');
  delay( 1000 );
  colorxyc( 40, 17, 8, 'Press <Enter> to begin.');
  delay( 100 );
  ccenterxy( 40, 17, '|wPress |b<|wEnter|b>|w to begin|K.');
  delay( 100 );
  ccenterxy( 40, 17, '|WPress |B<|WEnter|B>|W to begin|w.');
  getenter;
 end;

procedure getusername;
 begin
   { shows a list of available accounts, allows user to select one
     or enter a new name }
  username := 'Saber Renault';
 end;

procedure init;
 begin
  setupcrt;
  titlescreen;
  getusername;
 end;

begin
 init;
end.