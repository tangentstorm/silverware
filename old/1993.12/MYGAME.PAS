Program MyGame;
uses crt, crtstuff, zokstuff;

type
 cinput = object( zinput )
  procedure handle( ch : char ); virtual;
  procedure handlestripped( ch : char ); virtual;
 end;

var
 commandpast : array[ 1 .. 5 ] of string;
 cline : cinput;
 maxerr : byte;
 done,briefmode,chatmode,badlogin : boolean;
 divider,boxes,prompt,sprompt,error,user,banner : string;

function pstring( s : string ) : string;
 var
  temp : string;
 begin
  temp := '';
  while pos( '�', s ) > 0 do
   begin
    temp := temp + copy( s, 1, pos( '�', s ) - 1 );
    delete( s, 1, pos( '�', s ) );
    case s[ 1 ] of
     'T','t' : temp := temp + '!|C'+stardate+'@'
    end;
    delete( s, 1, 1 );
   end;
   temp := temp + s;
  pstring := temp;
 end;


type
 commands=( action, brief, chat, down, drop, east, follow, give, help,
            items, jump, look, north, notice, open, private, read, say,
            south, take, up, use, west, yell, quickhelp, sysmen, batch,
            comset, goodbye, info, refresh, setup, time, version, who, nocmd );

function cmd( s : string ) : commands;
 begin
  s := upstr( s );
  while (s[1] = ' ') and (s[0] <> #0) do delete( s, 1, 1 );
  case nwords( s ) of
   0 : cmd := nocmd;
   1 : case s[1] of
        'B' : cmd := brief;
        'C' : cmd := chat;
        'D' : cmd := down;
        'E' : cmd := east;
        'H' : cmd := help;
        'I' : cmd := items;
        'L' : cmd := look;
        'N' : begin
               if s[ length( s ) ] = ' '
               then cmd := notice
               else cmd := north;
              end;
        'S' : cmd := south;
        'U' : cmd := up;
        'W' : cmd := west;
        '?' : cmd := quickhelp;
        '/' : if length( s ) = 1 then cmd := sysmen else
              case s[2] of
               'B' : cmd := batch;
               'C' : cmd := comset;
               'G' : cmd := goodbye;
               'I' : cmd := info;
               'R' : cmd := refresh;
               'S' : cmd := setup;
               'T' : cmd := time;
               'V' : cmd := version;
               'W' : cmd := who;
               '?' : cmd := sysmen;
               else
                cmd := nocmd;
              end;
        else
         cmd := nocmd;
       end; { case nwords = 1 }
   else
    case s[1] of
     'A' : cmd := action;
     'B' : cmd := brief;
     'D' : cmd := drop;
     'F' : cmd := follow;
     'G' : cmd := give;
     'H' : cmd := help;
     'J' : cmd := jump;
     'L' : cmd := look;
     'N' : cmd := notice;
     'O' : cmd := open;
     'P' : cmd := private;
     'R' : cmd := read;
     'S' : cmd := say;
     'T' : cmd := take;
     'U' : cmd := use;
     'Y' : cmd := yell;
     '/' : if s[2] = 'I' then cmd := info else cmd := nocmd;
     else
      cmd := nocmd;
    end;
  end;
 end;


procedure plogin;
 var
  name : zinput;
  errors : byte;
 begin
  errors := 0;
  cwriteln('|MMain Gate');
  cwriteln('|wYou emerge suddenly from the void, and find yourself before the Project''s');
  cwriteln('|wmain entrance.');
  cwriteln('|RTiny is here.');
  cwrite('|GTiny: What do they call ya, mate?'+#13+sprompt);
  name.init( txpos, 25, 12, 12, $0F, $0E, 'new' );
  user := name.get;
  cwriteln('');
  while upstr( user ) <> 'STERLING' do
   begin
    inc( errors, 1 );
    if errors >= maxerr then begin badlogin := true; exit; end;
    if upstr( user ) = 'NEW'
     then cwriteln('|GTiny: We don''t want no newbies here.')
     else cwriteln('|GTiny: I didn''t quite catch that, buddy.');
    cwrite( sprompt );
    user := name.get;
    cwriteln('');
   end;
   cwriteln('|GTiny: Alright, go on in.');
   cwriteln('|wYou step through the gate and are immediately transported to your cramped');
   cwriteln('personal locker at Project HQ.');
   user := 'Sterling';
   cwriteln( divider );
 end;

procedure paction( s : string );
 var
  verb : boolean;
 begin
  delete( s, 1, pos( wordn(s,2), s )-1 );
  verb := upcase(s[pos(' ',s)-1]) = 'S';
  while s[length(s)] in ['.',' '] do dec(byte(s[0]));
  cwrite('|B'+user);
  if verb then
   cwriteln( ' ' + normaltext( s ) + '.' )
  else
   cwriteln( ' is acting ' + normaltext( s ) + '.' );
 end;

procedure plook;
 begin
  cwriteln('|M'+user+'''s Locker');
  if briefmode then
   cwriteln('|wA brief description goes here.')
  else
   cwriteln('|wA long description goes here.');
 end;

procedure psay( s  : string );
 begin
  cwriteln( '|GSterling: '+normaltext( copy( s, pos( ' ', s )+1, length( s ) )));
 end;

procedure pquickhelp;
 begin
  cwriteln( divider+divider );
  cwriteln( boxes + 'Available commands |r(|WOnly the first letter is necessary|r):');
  cwriteln( divider+divider );
  cwriteln( ' |WA|wction    |WB|wrief     |WC|what      |WD|wown      |WD|wrop      |WE|wast      |WF|wollow    |WG|wive');
  cwriteln( ' |WH|welp      |WI|wtems     |WJ|wump      |WL|wook      |WN|worth     |WN|wotice    |WO|wpen      |WR|wead');
  cwriteln( ' |WP|wrivate   |WS|way       |WS|wouth     |WT|wake      |WU|wp        |WU|wse       |WW|west      |WY|well');
  cwriteln( divider+divider );
  cwriteln( boxes+ 'Type |r"|Y?|r"|W for this screen anytime|r,|W or |r"|Y/|r"|W for system menu|r.');
  cwriteln( divider+divider );
 end;

procedure psysmen;
 begin
  cwriteln( divider );
  cwriteln( boxes+'Available system commands');
  cwriteln( divider );
  cwriteln( ' |W/B|watch        |W/C|womset       |W/G|woodbye');
  cwriteln( ' |W/I|winfo        |W/R|wefresh      |W/S|wetup');
  cwriteln( ' |W/T|wime         |W/V|wersion      |W/W|who');
  cwriteln( divider );
 end;

procedure prefresh;
 begin
  setupcrt;
  typos := 25;
 end;

procedure psetup;
 begin
 end;

procedure ptime;
 begin
  cwriteln( '|C' + stardate );
 end;

procedure pversion;
 begin
  cwriteln( divider );
  cwriteln( boxes + '|WThe Project |Y: |Gv1.0 by ' + silverware );
  cwriteln( divider );
 end;

procedure pwho;
 begin
 end;

procedure docommand( s : string );
 begin
  case cmd( s ) of
   action     : paction( s );
   look       : plook;
   say        : psay( s );
   quickhelp  : pquickhelp;
   sysmen     : psysmen;
   goodbye    : done := true;
   refresh    : prefresh;
   time       : ptime;
   version    : pversion;
   nocmd      : cwriteln( error );
  end;
  if not done then cwrite( pstring( prompt ) );
 end;

procedure cinput.handlestripped( ch : char );
 begin
  zinput.handlestripped( ch );
 end;

procedure cinput.handle( ch : char );
 begin
  case ch of
   #27 : reset;
   #13 : begin
          cwriteln('');
          docommand( strg );
          reset;
         end;
   else zinput.handle( ch );
  end;
 end;

procedure shutdown;
 begin
  cwriteln( boxes + 'Thanks for playing my game|w.');
  doscursoron;
 end;

procedure init;
 begin
  done := false;
  badlogin := false;
  divider := '|b'+chntimes('�',40)+'|W';
  boxes  := '|r�|R�|Y� |W';
  prompt := '|b�|B�|C�|W>';
  banner :=
    '|!k|# 19|W��Ŀ|K'#13+'�|#�14|BTHE|K�|W�|K�|w�|W�|BROJECT|K|#�18�'#13+
    '�|# 18|W�|# 27|K�'#13+'� |Woo |wlines!    |W12|w/|W24|w/|W96oo |wbaud'+

    '   |w(|Wxxx|w)|Wxxx|w-|Wxxxx |K�'#13+'�|#�26|w|B(|Wc|B)1994'+silverware+'��'#13;

  sprompt := '|BSay|C>';
  maxerr := 4;
  error := boxes + 'Say What|R?';
  setupcrt;
  doscursoron;
  txpos := 1;
  typos := 25;
  cwriteln( banner );
  cwriteln( divider + divider );
  plogin;
  if badlogin then
   begin
    cwriteln(divider);
    cwriteln(boxes+'Try again when you''re sober, okay?'+#13);
    cwriteln('NO CARRIER');
    halt;
   end;
  plook;
  ptime;
  cwrite( pstring( prompt ));
  cline.init( txpos, 25, 70, 70, $0F, $0E, '' );
  cline.show;
 end;

begin
 init;
 repeat
  if keypressed then cline.handle( readkey );
 until done;
 shutdown;
end.