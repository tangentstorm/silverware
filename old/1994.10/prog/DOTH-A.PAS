Program aheeb;
{ $R+}
Uses Crt,crtstuff,zokstuff,sndstuff,filstuff;

type
 kinds = ( none, wall, breakablewall, boulder, hero, doppelganger, slider,
           coin, gem, heart, ammo, key, scroll, spell, item, grapplinghook,
           cableitem, switchitem, bombitem, feather, fairy, torch, lantern,
           useritem, chest, generator, movingwall, scuzzy, bullet, pusher,
           coward, snake, moron, head, segment, actor, merchant, oracle,
           computer, useractor, terrain, rope, cable, switch, rapids,
           deepwater, trap, lava, passage, teleport, stairs, snakepit, return,
           bed, spellstone, gangercontrol, bomb, surroundspell, creatorspell,
           dock, laser, fan, gravitywell, electricwall, invisiblewall,
           factory, gun, duplicator, volcano, door, electricdoor, conveyor,
           electricconveyor, bouncewall, lightbulb, wind, gravity,
           soundtrack, nextroom );
 level = ( apprentice, adventureer, last );
 somekinds = set of kinds;
 direction = ( north, northeast, east, southeast,
               south, southwest, west, northwest, nowhere );
 directions = set of direction;
 pstat = ^stat;
 stat = object
  x, y : word;
  s : string;
  procedure init( a, b : word; s1 : string );
  procedure changeto( s1 : string );
  procedure value( var l; digits : byte );
  procedure draw;
  procedure erase;
 end;
 Pobj = ^obj;
 obj = object
  x,y,a,delay,dcounter : byte;
  isdefault : boolean;
  kind : kinds;
  facing : direction;
  touch : string;
  deathsound : noises;
  c : char;
  constructor init( a1, b1, dlay, atr : byte; ch : char );
  procedure setfields; virtual;
  procedure loadfields( var f : file ); virtual;
  procedure savefields( var f : file ); virtual;
  procedure draw; virtual;
  procedure update; virtual;
  procedure move( a1, b1 : shortint );
  procedure moverel( a1, b1 : shortint );
  procedure face( d : direction ); virtual;
  procedure walk( d: direction ); virtual;
  procedure shoot; virtual;
  procedure getshot( from : direction ); virtual;
  procedure die; virtual;
  procedure runinto( bywhat : pobj; from : direction ); virtual;
  procedure talk( t : string );
  procedure handle( msg : word; data : pointer; from : Pobj ); virtual;
  procedure broadcast( msg : word; data : pointer ); virtual;
  function neighbor( d: direction ) : pobj;
  function blocked( d : direction ) : boolean; virtual;
  destructor done; virtual;
 end;
 pwallobj = ^wallobj;
 wallobj = object( obj )
  constructor default( a1, b1 : byte );
 end;
 pbreakablewallobj = ^breakablewallobj;
 breakablewallobj = object( wallobj )
  constructor default( a1, b1 : byte );
  procedure runinto( bywhat : pobj; from : direction ); virtual;
  procedure getshot( from : direction ); virtual;
 end;
 pboulderobj = ^boulderobj;
 boulderobj = object( breakablewallobj )
  constructor default( a1, b1 : byte );
  procedure walk( d: direction ); virtual;
  procedure runinto( bywhat : pobj; from : direction ); virtual;
  procedure getshot( from : direction ); virtual;
  function blocked( d: direction ) : boolean; virtual;
 end;
 pheroobj = ^heroobj;
 heroobj = object( boulderobj )
  msgstat,
  namestat,
  rankstat,
  cashstat,
  magicstat,
  ammostat,
  healthstat : stat;
  name : string;
  rank : byte;
  cpoints, cmax, mpoints, mmax, apoints, amax, hpoints, hmax : longint;
  constructor init( a1, b1 : byte; nam : string );
  constructor default( a1, b1 : byte );
  procedure face( d: direction ); virtual;
  procedure walk( d: direction ); virtual;
  procedure shoot; virtual;
  procedure getshot( from : direction ); virtual;
  procedure handle( msg : word; data : pointer; from : pobj ); virtual;
  procedure update; virtual;
  procedure die; virtual;
  function blocked( d : direction ) : boolean; virtual;
 end;
 pdoppelgangerobj = ^doppelgangerobj;
 doppelgangerobj = object( boulderobj )
  mimic : pobj;
  xlast, ylast : byte;
  constructor init( a1, b1 : byte; m : pobj );
  constructor default( a1, b1 : byte );
  procedure draw; virtual;
  procedure update; virtual;
  procedure runinto( bywhat : pobj; from : direction ); virtual;
 end;
 psliderobj = ^sliderobj;
 sliderobj = object( boulderobj )
  northsouth : boolean;
  ways : set of direction;
  constructor init( a1, b1, atr : byte; ns : boolean );
  constructor default( a1, b1 : byte );
  procedure runinto( bywhat : pobj; from : direction ); virtual;
  function blocked( d : direction ) : boolean; virtual;
  procedure setfields; virtual;
  procedure loadfields( var f : file ); virtual;
  procedure savefields( var f : file ); virtual;
 end;
 pcoinobj = ^coinobj;
 coinobj = object( boulderobj )
  message : word;
  constructor init( a1, b1, atr : byte; ch : char; msg : word );
  constructor default( a1, b1 : byte );
  procedure runinto( bywhat : pobj; from : direction ); virtual;
 end;
 pgemobj = ^gemobj;
 gemobj = object( coinobj )
  constructor default( a1, b1 : byte );
 end;
 pheartobj = ^heartobj;
 heartobj = object( coinobj )
  constructor default( a1, b1 : byte );
 end;
 pammoobj = ^ammoobj;
 ammoobj = object( coinobj )
  constructor default( a1, b1 : byte );
 end;
 pkeyobj = ^keyobj;
 keyobj = object( coinobj )
 end;
 pscrollobj = ^scrollobj;
 scrollobj = object( coinobj )
 end;
 pspellobj = ^spellobj;
 spellobj = object( scrollobj )
 end;
 pitemobj = ^itemobj;
 itemobj = object( coinobj )
 end;
 pgrapplinghookobj = ^grapplinghookobj;
 grapplinghookobj = object( itemobj )
 end;
 pcableitemobj = ^cableobj;
 cableitemobj = object( itemobj )
 end;
 pswitchitemobj = ^switchitemobj;
 switchitemobj = object( cableitemobj )
 end;
 pbombitemobj = ^bombitemobj;
 bombitemobj = object( cableitemobj )
 end;
 pfeatherobj = ^featherobj;
 featherobj = object( itemobj )
 end;
 pfairyobj = ^fairyobj;
 fairyobj = object( itemobj )
 end;
 ptorchobj = ^torchobj;
 torchobj = object( itemobj )
 end;
 planternobj = ^lanternobj;
 lanternobj = object( torchobj )
 end;
 puseritemobj = ^useritemobj;
 useritemobj = object( itemobj )
 end;
 pchestobj = ^chestobj;
 chestobj = object( coinobj )
 end;
 pgeneratorobj = ^generatorobj;
 generatorobj = object( boulderobj  )
 end;
 pmovingwallobj = ^movingwallobj;
 movingwallobj = object( boulderobj )
  constructor default( a1, b1 : byte );
  procedure walk( d: direction ); virtual;
  procedure runinto( bywhat : pobj; from : direction ); virtual;
  procedure getshot( from : direction ); virtual;
  procedure update; virtual;
 end;
 pscuzzyobj = ^scuzzyobj;
 scuzzyobj = object( movingwallobj )
  constructor default( a1, b1 : byte );
  procedure walk( d : direction ); virtual;
  procedure runinto( bywhat : pobj; from : direction ); virtual;
  function blocked( d : direction ) : boolean; virtual;
 end;
 pbulletobj = ^bulletobj;
 bulletobj = object( scuzzyobj )
  constructor init( a1, b1 : byte; d : direction );
  procedure runinto( bywhat : pobj; from : direction ); virtual;
  procedure getshot( from : direction ); virtual;
  procedure walk( d : direction ); virtual;
  function blocked( d : direction ) : boolean; virtual;
 end;
 ppusherobj = ^pusherobj;
 pusherobj = object( bulletobj )
  constructor init( a1, b1, dlay, atr: byte; heading: direction );
  constructor default( a1, b1 : byte );
  procedure setfields; virtual;
  procedure loadfields( var f : file ); virtual;
  procedure savefields( var f : file ); virtual;
  procedure runinto( bywhat : pobj; from : direction ); virtual;
  procedure walk( d : direction ); virtual;
 end;
 pcowardobj = ^cowardobj;
 cowardobj = object( scuzzyobj )
  constructor default( a1, b1 : byte );
  procedure walk( d: direction ); virtual;
 end;
 psnakeobj = ^snakeobj;
 snakeobj = object( cowardobj )
  constructor default( a1, b1 : byte );
  procedure walk( d: direction ); virtual;
  procedure update; virtual;
 end;
 pmoronobj = ^moronobj;
 moronobj = object( scuzzyobj )
  constructor default( a1, b1 : byte );
  procedure walk( d : direction ); virtual;
 end;
 pheadobj = ^headobj;
 headobj = object( scuzzyobj )
 end;
 psegmentobj = ^segmentobj;
 segmentobj = object( headobj )
 end;
 pactorobj = ^actorobj;
 actorobj = object( movingwallobj )
 end;
 poracleobj = ^oracleobj;
 oracleobj = object( actorobj )
 end;
 pcomputerobj = ^computerobj;
 computerobj = object( oracleobj )
 end;
 puseractorobj = ^useractorobj;
 useractorobj = object( actorobj )
 end;
 pterrainobj = ^terrainobj;
 terrainobj = object( boulderobj )
 end;
 propeobj = ^ropeobj;
 ropeobj = object( terrainobj )
 end;
 pcableobj = ^cableobj;
 cableobj = object( terrainobj )
 end;
 pswitchobj = ^switchobj;
 switchobj = object( cableobj )
 end;
 prapidsobj = ^rapidsobj;
 rapidsobj = object( terrainobj )
 end;
 pdeepwaterobj = ^deepwaterobj;
 deepwaterobj = object( terrainobj )
 end;
 ptrapobj = ^trapobj;
 trapobj = object( terrainobj )
 end;
 plavaobj = ^lavaobj;
 lavaobj = object( trapobj )
 end;
 ppassageobj = ^passageobj;
 passageobj = object( terrainobj )
 end;
 pteleportobj = ^teleportobj;
 teleportobj = object ( passageobj )
 end;
 pstairsobj = ^stairsobj;
 stairsobj = object( terrainobj )
  stairwayto : integer; { where it leads to }
  constructor default( a1, b1 : byte );
  procedure runinto( bywhat : pobj; from : direction ); virtual;
 end;
 psnakepitobj = ^snakepitobj;
 snakepitobj = object ( stairsobj )
 end;
 preturnobj = ^returnobj;
 returnobj = object( stairsobj )
 end;
 pbedobj = ^bedobj;
 bedobj = object( terrainobj )
 end;
 pspellstoneobj = ^spellstoneobj;
 spellstoneobj = object( terrainobj )
 end;
 pgangercontrolobj = ^gangercontrolobj;
 gangercontrolobj = object( spellstoneobj )
 end;
 pbombobj = ^bombobj;
 bombobj = object( spellstoneobj )
 end;
 psurroundspellobj = ^surroundspellobj;
 surroundspellobj = object( spellstoneobj )
 end;
 pcreatorspellobj = ^creatorspellobj;
 creatorspellobj = object( spellstoneobj )
 end;
 pdockobj = ^dockobj;
 dockobj = object( spellstoneobj )
 end;
 plaserobj = ^laserobj;
 laserobj = object( terrainobj )
 end;
 pfanobj = ^fanobj;
 fanobj = object( boulderobj )
 end;
 pgravitwellobj = ^gravitywellobj;
 gravitywellobj = object( fanobj )
 end;
 pelectricwallobj = ^electricwallobj;
 electricwallobj = object( wallobj )
 end;
 pinvisiblewallobj = ^invisiblewallobj;
 invisiblewallobj = object( wallobj )
 end;
 pfactoryobj = ^factoryobj;
 factoryobj = object( wallobj )
 end;
 pgunobj = ^gunobj;
 gunobj = object( factoryobj )
 end;
 pduplicatorobj = ^duplicatorobj;
 duplicatorobj = object( factoryobj )
 end;
 pvolcanoobj = ^volcanoobj;
 volcanoobj = object( factoryobj )
 end;
 pdoorobj = ^doorobj;
 doorobj = object( wallobj )
 end;
 pelectricdoorobj = ^electricdoorobj;
 electricdoorobj = object( doorobj )
 end;
 pconveyorobj = ^conveyorobj;
 conveyorobj = object( wallobj )
 end;
 pelectricconveyorobj = ^electricconveyorobj;
 electricconveyorobj = object( conveyorobj )
 end;
 pbouncewallobj = ^bouncewallobj;
 bouncewallobj = object( conveyorobj )
 end;
 plightbulbobj = ^lightbulbobj;
 lightbulbobj = object( wallobj )
 end;
 pwindobj = ^windobj;
 windobj = object( obj )
 end;
 pgravityobj = ^gravityobj;
 gravityobj = object( obj )
 end;
 psoundtrackobj = ^soundtrackobj;
 soundtrackobj = object( obj )
 end;
 pnextroomobj = ^nextroomobj;
 nextroomobj = object ( obj )
  constructor init;
 end;
 roomstring = array [ 1 .. 1400 ] of pobj;

Var
 progdone,
 exitmenu,
 gameon : boolean;
 back : PCel;
 temp : screentype;
 room : array[1..70,1..20] of Pobj;
 currentroom : integer;
 player,nextlevel : Pobj;
 c : zconfirmbox;
 i : zinputbox;
 savedexit : pointer;

{--- constants ---}
const
 male   = true;
 female = false;
 cardinal  = [ north, south, east, west ];
 enemies = [ scuzzy, bullet, coward, snake, moron, head, segment ];
 worldext = '.WLD';  { world file extension }
 savedext = '.SAV';  { saved game extension (format is same as .WLD) }
 musicext = '.MSC';  { background musics }
 graphext = '.GRF';



{--- typed constants - can be overwritten with other data ---}
 filetoload : string[ 8 ] = 'DOTH';
 delays : array[ 0 .. 10 ] of byte =
              ( 0, 3, 8, 13, 20, 25, 30, 35, 40, 45, 50 );
 movers   : somekinds = [ hero, doppelganger, boulder, slider, pusher,
                          coin, gem ];
 terrains : somekinds = [];
 walkinto : somekinds = [ boulder, slider, coin, gem, heart, ammo, stairs ];
 ranks    : array[ apprentice..last ] of string = (
            '|BApprentice',  { apprentice }
            '|BAdventurer',
            '|!K|RERROR|Y!|!k' ); { last }
 gematr   : byte = $04;
 wallatr  : byte = $06;
 hpstart  : word = 30;
 hpstmax  : word = 100;
 hpx      : word = 75;
 hpy      : word = 24;
 amostart : word = 0;
 amomax   : word = 100;
 amox     : word = 62;
 amoy     : word = 24;
 mgcstart : word = 0;
 mgcmax   : word = 100;
 mgcx     : word = 51;
 mgcy     : word = 24;
 cshstart : word = 0;
 cshmax   : word = 100;
 cshx     : word = 37;
 cshy     : word = 24;
 msgx     : word = 31;
 msgy     : word = 23;
 namex    : word = 8;
 namey    : word = 23;
 namec    : word = 9;


{--- message constants ---}
const
 textmsg       = $00;
 gethealthmsg  = $01;
 gethurtmsg    = $02;
 getcashmsg    = $03;
 getammomsg    = $04;
 getgemmsg     = $05;
 getrankmsg    = $06;
 getkeymsg     = $07;

{--- junk for use by objects ---}

{ $I WIZARD.PAS}
{ $I STARS.PAS}
{ $I ICE.PAS}
{$I DPLAY1.PIC}

procedure menu; forward;
procedure edit; forward;
procedure loadgame( filename : string ); forward;
procedure savegame( filename : string ); forward;
procedure gotoroom( roomnum : integer ); forward;
function newobject( x, y : byte; k : kinds ) : pobj; forward;

function randomdirection : direction;
 begin
  randomdirection := direction( random( 8 ) );
 end;

function randomdirectionoutof( ds : directions ) : direction;
 var
  d : direction;
 begin
  while not ( d in ds ) do d := randomdirection;
  randomdirectionoutof := d;
 end;

function locationdirectionfrom( a1, b1, a2, b2 : shortint ) : direction;
 var
  n, e, s, w : boolean;
 begin
  n := b1 < b2;
  s := b1 > b2;
  e := a1 > a2;
  w := a1 < a2;
  if n and not e and not w then locationdirectionfrom := north;
  if n and e then locationdirectionfrom := northeast;
  if e and not n and not s then locationdirectionfrom := east;
  if s and e then locationdirectionfrom := southeast;
  if s and not e and not w then locationdirectionfrom := south;
  if s and w then locationdirectionfrom := southwest;
  if w and not n and not s then locationdirectionfrom := west;
  if n and w then locationdirectionfrom := northwest;
 end;

function objdirectionfrom( o : pobj; a1, b1 : byte ) : direction;
 begin
  objdirectionfrom := locationdirectionfrom( o^.x, o^.y, a1, b1 );
 end;

function herodirectionfrom( a1, b1 : byte ) : direction;
 begin
  herodirectionfrom := objdirectionfrom( player, a1, b1 );
 end;

function oppositedirection( d : direction ) : direction;
 begin
  if
   ord( d ) > 3
  then
   oppositedirection := direction( ord( d ) - 4 )
  else
   oppositedirection := direction( ord( d ) + 4 );
 end;

function getheroname : string;
 var
  s : screentype;
  i : zinputbox;
 begin
  s := screen;
  i.default( 5,5,'|WWH|Ga|WT N|Ga|WM|Ge |WW|Gi|WLL |WY|Gou u|WS|Ge|Y?',
          '|Y>', 20 );
  getheroname := i.get;
  screen := s;
 end;

{--- stat object listings ---}

procedure stat.init( a, b : word; s1 : string );
 begin
  x := a;
  y := b;
  s := s1;
  draw;
 end;

procedure stat.changeto( s1 : string );
 begin
  erase;
  s := s1;
  draw;
 end;

procedure stat.value( var l; digits : byte );
 begin
  s := n2s( longint(l) );
  while length( s ) < digits do s := '0' + s;
  s := '|w'+s;
  draw;
 end;

procedure stat.draw;
 begin
  writeto := @dplay1;
  cwritexy( x, y, s );
  writeto := @screen;
 end;

procedure stat.erase;
 begin
  writeto := @dplay1;
  cwritexy( x, y, '|!k|W'+chntimes( ' ', clength( s ) ) );
  writeto := @screen;
 end;

{--- main object listings ---}

constructor obj.init( a1, b1, dlay, atr : byte; ch : char );
 begin
  x := a1;
  y := b1;
  if (x < 1) or (y < 1) or (x > 70) or (y > 20) then
    begin textattr := $4E; gotoxy(1,1); clreol; write('obj.init '); runerror( 255 ); end;
  a := atr;
  kind := none; { NewObject will change this }
  delay := dlay;
  dcounter := random( delays[ dlay ] );
  c := ch;
  facing := south;
  touch := '';
 end;

function getcolor( x, y : word; start : byte ) : byte;
 var
  zc : zcolor;
 begin
  zc.init( x, y, $4F, $08, start );
  getcolor := zc.get;
 end;

function getdirection : direction;
 var
  ch : char;
 begin
  ch := ' ';
  while
   not ( upcase( ch ) in ['N','S','E','W'] )
  do
   ch := readkey;
  write( ch );
  case ch of
   'N' : getdirection := north;
   'S' : getdirection := south;
   'E' : getdirection := east;
   'W' : getdirection := west;
  end;
 end;

procedure obj.setfields;        { update these later for better interface }
 var
  at, ct, dt : byte;
 begin
  at := a;
  ct := byte( c );
  dt := delay;
  isdefault := true;
  Bar( 5, 5, 65, 10, $08 );
  greyshadow( 5, 5, 65, 10 );
  cwritexy( 25, 6, '|rÄÄÄÄÄ|WS|Ge|WTF|Gie|WLDS|rÄÄÄÄÄ|W' );
  cwritexy( 10, 7, '|WC|Go|WL|Go|WR|Y: |W');
  a := getcolor( txpos, typos, a );
  cwritexy( 35, 7, '|WCH|Ga|WR|Ga|WCT|GE|WR|Y: |W');
  readln( c );
  cwritexy( 10, 8, '|WD|Ge|WL|Ga|WY|Y: |W' );
  readln( delay );
  if
   ( at <> a ) or ( ct <> byte( c ) ) or ( dt <> delay )
  then
   isdefault := false;
 end;

procedure obj.loadfields( var f : file );
 begin
  a := nextbyte( f ); { attrib }
  c := char( nextbyte( f )); { char }
  delay := nextbyte( f );
 end;

procedure obj.savefields( var f : file );
 begin
  savebyte( f, a );
  savebyte( f, byte( c ) );
  savebyte( f, delay );
 end;

procedure obj.draw;
 begin
  colorxy(x+1,y+1,a,c); {fit to game window, write c with attribute a}
 end;

procedure obj.update;
 begin
  if room[ x, y ] <> @self then runerror( 254 );
 end;

procedure obj.move( a1, b1 : shortint );
 begin
  if (a1 > 70) or (a1 < 1) or (b1 > 20) or (b1 < 1) then exit;
  if
   room[ a1, b1 ] <> nil
  then
   room[ a1, b1 ]^.runinto( @self, locationdirectionfrom( x, y, a1, b1 ) )
  else
   begin
    room[ x, y ] := nil;
    room[ a1, b1 ] := @self;
    x := a1;
    y := b1;
   end;
 end;

procedure obj.moverel( a1, b1 : shortint );
 begin
  move( x + a1, y + b1 );
 end;

procedure obj.face( d : direction );
 begin
  facing := d;
 end;

procedure obj.walk( d : direction );
 begin
 end;

procedure obj.shoot;
 begin
  if
   neighbor( facing ) <> nil
  then
   if
    neighbor( facing ) <> nextlevel
   then
    neighbor( facing )^.getshot( oppositedirection( facing ))
   else
  else
   case facing of
    north : room[ x, y - 1 ] := new( pbulletobj, init( x, y - 1, north ));
    south : room[ x, y + 1 ] := new( pbulletobj, init( x, y + 1, south ));
    east  : room[ x + 1, y ] := new( pbulletobj, init( x + 1, y, east  ));
    west  : room[ x - 1, y ] := new( pbulletobj, init( x - 1, y, west  ));
   end;
 end;

procedure obj.getshot( from : direction );
 begin
 end;

procedure obj.die;
 begin
  done;
 end;

procedure obj.runinto( bywhat : pobj; from : direction );
 begin
  if (bywhat <> player) then exit;
  talk( touch );
{  spkr.makenoise( noise );}
 end;

procedure obj.talk( t : string );
 begin
  player^.handle( textmsg, @t, @self );
 end;

procedure obj.handle( msg : word; data : pointer; from : Pobj );
 begin
 end;

procedure obj.broadcast( msg : word; data : pointer );
 begin
 end;

function obj.neighbor( d: direction ) : pobj;
 var
  a1, b1 : shortint;
  r : pobj;
 begin
  case d of
   north     : begin a1 :=  0; b1 := -1; end;
   northeast : begin a1 :=  1; b1 := -1; end;
   east      : begin a1 :=  1; b1 :=  0; end;
   southeast : begin a1 :=  1; b1 :=  1; end;
   south     : begin a1 :=  0; b1 :=  1; end;
   southwest : begin a1 := -1; b1 :=  1; end;
   west      : begin a1 := -1; b1 :=  0; end;
   northwest : begin a1 := -1; b1 := -1; end;
   nowhere   : begin a1 :=  0; b1 :=  0; end;
  end;
  if ( x + a1 > 70 ) or ( x + a1 < 1 ) or
     ( y + b1 > 20 ) or ( y + b1 < 1 ) then r := nextlevel else
  r := room[ x+a1, y+b1 ];
  neighbor := r;
 end;

function obj.blocked( d : direction ) : boolean;
 begin
  blocked := neighbor( d ) <> nil;
 end;

destructor obj.done;
 var
  ta, tb : byte;
 begin
  ta := x; tb := y;
  if (ta < 1) or (tb < 1) or (ta > 70) or (tb > 20) then
   begin
    gotoxy( 1, 1 );
    textattr := $4E;
    write('obj.done(', x, ',' ,y, ') ' );
    textattr := $4F;
    write('kind = (',byte(kind), ') ' );
    runerror( 255 );
   end;
  if room[ta, tb] <> nil then dispose( room[ ta, tb ] );
  room[ ta, tb ] := nil;
 end;

constructor wallobj.default( a1, b1 : byte );
 begin
  obj.init( a1, b1, 0, wallatr, 'Û' );
  touch := '|WYou can|w''|Wt walk through walls|w.';
 end;

constructor breakablewallobj.default( a1, b1 : byte );
 begin
  obj.init( a1, b1, 0, wallatr, '²');
  touch := '|WA breakable wall blocks your path|w.';
 end;

procedure breakablewallobj.runinto( bywhat : pobj; from : direction );
 begin
  if
   bywhat^.kind in enemies
  then
   if
    bywhat^.kind = bullet
   then
    getshot( from )
   else
    begin
     bywhat^.die;
     die;
    end
  else
   obj.runinto( bywhat, from );
 end;

procedure breakablewallobj.getshot( from : direction );
 begin
  obj.getshot( from );
  die;
 end;

constructor boulderobj.default( a1, b1 : byte );
 begin
  obj.init( a1, b1, 0, 7, 'O' );
  touch := '|WYou push the boulder|w.';
 end;

procedure boulderobj.walk( d : direction );
 begin
  if facing <> d then face( d );
  case d of
   north      : moverel(  0, -1 );
   northeast  : if not blocked( east ) then walk( east ) else walk( north );
   east       : moverel(  1,  0 );
   southeast  : if not blocked( east ) then walk( east ) else walk( south );
   south      : moverel(  0,  1 );
   southwest  : if not blocked( west ) then walk( west ) else walk( south );
   west       : moverel( -1,  0 );
   northwest  : if not blocked( west ) then walk( west ) else walk( north );
  end;
 end;

procedure boulderobj.runinto( bywhat : pobj; from : direction );
 var
  a1, b1 : byte;
 begin
  obj.runinto( bywhat, from );
  a1 := x; b1 := y;
  if not (bywhat^.kind in movers ) then exit;
  boulderobj.walk( oppositedirection( from ) );
  if (a1 = x) and (b1 = y) then exit;
  bywhat^.walk( oppositedirection( from ) );
 end;

procedure boulderobj.getshot( from : direction );
 begin
  obj.getshot( from );
 end;

function boulderobj.blocked( d: direction ) : boolean;
 begin
  if
   not obj.blocked( d )
  then
   blocked := false
  else
   if not (neighbor(d)^.kind in walkinto)
    then blocked := true
   else
    blocked := neighbor(d)^.blocked(d);
 end;


constructor heroobj.init( a1, b1 : byte; nam : string );
 begin
  obj.init( a1, b1, 0, $0E, '' );
  namestat.init( namex, namey, '|!k|B' + nam );
  msgstat.init( msgx, msgy,
                '|WD|Go|WTH |B(|WC|B)|W1993 |KÄ|WS|wÅîâL³NG|KÄ|WS|w³LVîâWêâî|KÄ');
  hpoints := hpstart;
  hmax := hpstmax;
  healthstat.init( hpx, hpy, '|w0000' );
  healthstat.value( hpoints, 4 );
  apoints := amostart;
  amax := amomax;
  ammostat.init( amox, amoy, '|w0000' );
  ammostat.value( apoints, 4 );
  mpoints := mgcstart;
  mmax := mgcmax;
  magicstat.init( mgcx, mgcy, '|w0000' );
  magicstat.value( mpoints, 4 );
  cpoints := cshstart;
  cmax := cshmax;
  cashstat.init( cshx, cshy, '|w000000' );
  cashstat.value( cpoints, 6 );
  facing := nowhere;
  face( south );
  player := @self;
 end;

constructor heroobj.default( a1, b1 : byte );
 begin
  heroobj.init( a1, b1, '' );
 end;

procedure heroobj.face( d : direction );
 begin
  if facing = d then exit;
  obj.face( d );
  writeto := @dplay1;
  colorxyv( 73, 4, $07, ''#26'' );
  case facing of
   north : colorxy( 73, 4, $0F, '' );
   south : colorxy( 73, 5, $0F, '' );
   east  : colorxy( 73, 6, $0F, #26 );
   west  : colorxy( 73, 7, $0F, '' );
  end;
  writeto := @screen;
 end;

procedure heroobj.walk( d: direction );
 begin
  boulderobj.walk( d );
 end;

procedure heroobj.shoot;
 begin
  if
   apoints > 0
  then
   begin
    obj.shoot;
    apoints := dec2( apoints, 1, 0 );
    ammostat.value( apoints, 4 );
   end;
 end;

procedure heroobj.getshot( from : direction );
 begin
  obj.getshot( from );
  spkr.ding;
 end;

procedure heroobj.handle( msg : word; data : pointer; from : pobj );
 begin
  case msg of
   textmsg : msgstat.changeto( string( data^ ) );
   gethealthmsg : begin
                    hpoints := inc2( hpoints, 1, hmax );
                    healthstat.value( hpoints, 4 );
                   end;
   gethurtmsg   : begin
                   hpoints := dec2( hpoints, 1, 0 );
                   healthstat.value( hpoints, 4 );
                  end;
   getcashmsg   : begin
                   cpoints := inc2( cpoints, 1, cmax );
                   cashstat.value( cpoints, 6 );
                  end;
   getammomsg   : begin
                   apoints := inc2( apoints, 5, amax );
                   ammostat.value( apoints, 4 );
                  end;
   getgemmsg    : begin
                   mpoints := inc2( mpoints, 1, mmax );
                   magicstat.value( mpoints, 4 );
                  end;
   getrankmsg   : begin
                  end;
   getkeymsg    : begin
                  end;
  end;
 end;

procedure heroobj.update;
 var
  ch : char;
 begin
  obj.update;
  if hpoints <= 0 then begin die; exit; end;
  if
   not keypressed
  then
   exit
  else
   msgstat.erase;
  ch := readkey;
  case upcase(ch) of
   #00 : case upcase( readkey ) of
          #71 : walk( northwest );
          #72 : walk( north );
          #73 : walk( northeast );
          #75 : walk( west );
          #77 : walk( east );
          #79 : walk( southwest );
          #80 : walk( south );
          #81 : walk( southeast );
         end;
   '-',' ' : shoot;
   '7' : walk( northwest );
   '8' : walk( north );
   '9' : walk( northeast );
   '4' : walk( west );
   '6' : walk( east );
   '1' : walk( southwest );
   '2' : walk( south );
   '3' : walk( southeast );
   'D' : die;
   #27 : menu;
  end;
 end;

procedure heroobj.die;
 begin
  gameon := false;
  msgstat.changeto('|WYou|w''|Wre dead|w... |b<|Wtsk|w,|Wtsk|w,|Wtsk|b>');
  obj.die;
 end;

function heroobj.blocked( d : direction ) : boolean; 
 begin
  if
   not boulderobj.blocked( d )
  then
   blocked := false
  else
   blocked := not ( neighbor( d )^.kind in walkinto);
 end;

constructor doppelgangerobj.init( a1, b1 : byte; m : pobj );
 begin
  mimic := m;
  if
   mimic <> nil
  then
   begin
    obj.init( a1, b1, 0, 0, mimic^.c );
    xlast := mimic^.x;
    ylast := mimic^.y;
    touch := '|WIt|w''|Ws just your run|w-|Wof|w-|Wthe|w-|Wmill doppelganger|w.';
   end
  else
   begin
    obj.init( a1, b1, 0, 0, '±' );
    xlast := 0;
    ylast := 0;
    touch := '|WIt|w''|Ws a doppelganger|w,|W but it|w''|Ws not doing anything|w.';
   end;
 end;

constructor doppelgangerobj.default( a1, b1 : byte );
 begin
  doppelgangerobj.init( a1, b1, nil );
 end;

procedure doppelgangerobj.draw;
 begin
  if mimic <> nil then a := random( 15 ) + 1 else a := 8;
  obj.draw;
 end;

procedure doppelgangerobj.update;
 begin
  obj.update;
  if mimic = nil then exit;
  if (xlast = mimic^.x) and (ylast = mimic^.y) then exit;
  boulderobj.walk( locationdirectionfrom(
                     mimic^.x, mimic^.y, xlast, ylast ));
  xlast := mimic^.x; ylast := mimic^.y;
 end;

procedure doppelgangerobj.runinto( bywhat : pobj; from : direction );
 begin
  boulderobj.runinto( bywhat, from );
  xlast := mimic^.x; ylast := mimic^.y;
 end;

constructor sliderobj.init( a1, b1, atr : byte; ns : boolean );
 begin
  if
   ns
  then
   begin
    obj.init( a1, b1, 0, atr, '' );
    northsouth := true;
    ways := [ north, south ];
   end
  else
   begin
    obj.init( a1, b1, 0, atr, '' );
    northsouth := false;
    ways := [ east, west ];
   end;
 end;

constructor sliderobj.default( a1, b1 : byte );
 begin
  sliderobj.init( a1, b1, $5, true );
 end;

procedure sliderobj.runinto( bywhat : pobj; from : direction );
 begin
  if
   from in ways
  then
   boulderobj.runinto( bywhat, from )
  else
   if bywhat = player then talk( '|WIt won|w''|Wt go that way|w!' );
 end;

function sliderobj.blocked( d : direction ) : boolean;
 begin
  if
   d in ways
  then
   blocked := boulderobj.blocked( d )
  else
   blocked := true;
 end;

procedure sliderobj.setfields;
 var
  ns : boolean;
 begin
  ns := northsouth;
  obj.setfields;
  cwritexy( 35, 8, '|WN|Go|WRTHS|Gou|WTH|Y: |W');
  case yesno of
   yes : begin write( 'Y' ); northsouth := true; end;
   no  : begin write( 'N' ); northsouth := false; end;
  end;
  sliderobj.init( x, y, a, northsouth );
  if northsouth <> ns then isdefault := false;
 end;

procedure sliderobj.loadfields( var f : file );
 begin
  obj.loadfields( f );
  sliderobj.init( x, y, a, nextboolean( f ) );
 end;

procedure sliderobj.savefields( var f : file );
 begin
  obj.savefields( f );
  saveboolean( f, northsouth );
 end;

constructor coinobj.init( a1, b1, atr : byte; ch : char; msg : word );
 begin
  obj.init( a1, b1, 0, atr, ch );
  message := msg;
 end;

constructor coinobj.default( a1, b1 : byte );
 begin
  coinobj.init( a1, b1, $0E, '', getcashmsg );
  touch := '|WYou found a gold coin|w!';
 end;

procedure coinobj.runinto( bywhat : pobj; from : direction );
 begin
  if
   bywhat <> player
  then
   boulderobj.runinto( bywhat, from )
  else
   begin
    talk( touch );
    player^.handle( message, nil, @self );
    die;
    player^.walk( oppositedirection( from ) );
   end;
 end;

constructor gemobj.default( a1, b1 : byte );
 begin
  coinobj.init( a1, b1, gematr, '', getgemmsg );
  touch := '|WGems give you magic|w!';
 end;

constructor heartobj.default( a1, b1 : byte );
 begin
  coinobj.init( a1, b1, $0C, '', gethealthmsg );
  touch := '|WHearts give you health points|w!';
 end;

constructor ammoobj.default( a1, b1 : byte );
 begin
  coinobj.init( a1, b1, $07, '', getammomsg );
  touch := '|WAmmunition |w-|W 5 shots|w!';
 end;

constructor movingwallobj.default( a1, b1 : byte );
 begin
  obj.init( a1, b1, 4, wallatr, '±' );
 end;

procedure movingwallobj.walk( d : direction );
 begin
  case d of
   north,south,east,west : boulderobj.walk( d );
   northeast : boulderobj.walk( randomdirectionoutof( [north,east] ));
   southeast : boulderobj.walk( randomdirectionoutof( [south,east] ));
   northwest : boulderobj.walk( randomdirectionoutof( [north,west] ));
   southwest : boulderobj.walk( randomdirectionoutof( [south,west] ));
  end;
 end;

procedure movingwallobj.runinto( bywhat : pobj; from : direction );
 begin
  breakablewallobj.runinto( bywhat, from );
 end;

procedure movingwallobj.getshot( from : direction );
 begin
  breakablewallobj.getshot( from );
 end;

procedure movingwallobj.update;
 begin
  obj.update;
  inc( dcounter );
  if dcounter >= delays[ delay ] then dcounter := 0;
  if dcounter = 0 then walk( herodirectionfrom( x, y ) );
 end;

constructor scuzzyobj.default( a1, b1 : byte );
 begin
  obj.init(  a1, b1, 3, $04, 'ê' );
 end;

procedure scuzzyobj.walk( d : direction );
 begin
  if
   (neighbor( d ) = player) and (d in cardinal)
  then
   begin
    player^.handle( gethurtmsg, nil, @self );
    die;
   end
  else
   movingwallobj.walk( d );
 end;

procedure scuzzyobj.runinto( bywhat : pobj; from : direction );
 begin
  if bywhat <> player then
   if
    bywhat^.kind = bullet
   then
    movingwallobj.runinto( bywhat, from )
   else
    boulderobj.runinto( bywhat, from )
  else
   begin
    obj.runinto( bywhat, from );
    player^.handle( gethurtmsg, nil, @self );
    die;
    player^.walk( oppositedirection( from ));
   end;
 end;

function scuzzyobj.blocked( d : direction ) : boolean;
 begin
  blocked := obj.blocked( d );
 end;

constructor bulletobj.init( a1, b1 : byte; d : direction );
 begin
  obj.init( a1, b1, 1, $07, 'ù' );
  facing := d;
  kind := bullet;
 end;

procedure bulletobj.runinto( bywhat : pobj; from : direction );
 begin                                 
  bywhat^.getshot( oppositedirection( from ));
  die;
 end;

procedure bulletobj.getshot( from : direction );
 begin
  obj.getshot( from );
 end;

procedure bulletobj.walk( d : direction );
 begin
{  boulderobj.walk( facing );
  exit;}
  if
   neighbor( facing ) = nil
  then
   begin
{    shoot;
    die;}
    boulderobj.walk( facing )
   end
  else
   begin
{    if
     neighbor( facing ) <> nextlevel
    then}
     boulderobj.walk( facing );
    spkr.pop;
    die;
   end;
 end;

function bulletobj.blocked( d : direction ) : boolean;
 begin
  blocked := neighbor( d ) <> nextlevel; { can't stop a bullet }
 end;

constructor pusherobj.init( a1, b1, dlay, atr: byte; heading: direction );
 begin
  case heading of
   north : obj.init( a1, b1, 3, atr, '' );
   south : obj.init( a1, b1, 3, atr, '' );
   east  : obj.init( a1, b1, 3, atr, #26 );
   west  : obj.init( a1, b1, 3, atr, '' );
  end;
  facing := heading;
 end;

constructor pusherobj.default( a1, b1 : byte );
 begin
  pusherobj.init( a1, b1, 3, $0D, south );
 end;

procedure pusherobj.setfields;
 var
  f : direction;
 begin
  f := facing;
  obj.setfields;
  cwritexy( 35, 8, '|WF|Ga|WC|Gi|WNG|Y: |W');
  pusherobj.init( x, y, 3, a, getdirection );
  if f <> facing then isdefault := false;
 end;

procedure pusherobj.loadfields( var f : file );
 begin
  obj.loadfields( f );
  facing := direction( nextbyte( f ));
 end;

procedure pusherobj.savefields( var f : file ); 
 begin
  obj.savefields( f );
  savebyte( f, byte( facing ) );
 end;

procedure pusherobj.runinto( bywhat : pobj; from : direction );
 begin
 end;

procedure pusherobj.walk( d : direction );
 begin
  boulderobj.walk( facing );
 end;

constructor cowardobj.default( a1, b1 : byte );
 begin
  obj.init( a1, b1, 3, $09, '' );
 end;

procedure cowardobj.walk( d: direction );
 begin
  case d of
   north,south,east,west : scuzzyobj.walk( oppositedirection( d ) );
  else
   scuzzyobj.walk( d );
  end;
 end;

constructor snakeobj.default( a1, b1 : byte );
 begin
  obj.init( a1, b1, 3, $02, '‡' );
 end;

procedure snakeobj.walk( d: direction );
 begin
   cowardobj.walk( oppositedirection( d ) );
 end;

procedure snakeobj.update;
 begin
  if
   herodirectionfrom(x,y) in [north,south,east,west]
  then
   inc( dcounter, 10 );
  cowardobj.update;
 end;

constructor moronobj.default( a1, b1 : byte );
 begin
  obj.init( a1, b1, 3, $0B, 'Õ' );
 end;

procedure moronobj.walk( d : direction );
 begin
  scuzzyobj.walk( randomdirection );
 end;

constructor stairsobj.default( a1, b1 : byte );
 begin
  obj.init( a1, b1, 0, $07, 'ð' );
  stairwayto := currentroom + 1;
 end;

procedure stairsobj.runinto( bywhat : pobj; from : direction );
 begin
  if bywhat = player then
  (***************** INSERT CODE TO SAVE CURRENT LEVEL HERE **********)
  gotoroom( stairwayto );
 end;

constructor nextroomobj.init;
 begin
  kind := nextroom;
  spkr.silversound;
  { just a fake object returned when something tries to leave a room }
 end;

{--- end of object listings ---}

Procedure LoadBackground;
 begin
  temp := screentype( dplay1 );
  back := nil;
 end;

procedure owrite( x, y, c : byte; s : string );
 var
  i : byte;
 begin
  for i := 0 to length( s ) - 1 do
  room[ x + i, y ] := new( pobj, init( x + i, y, 0, c, s[ i + 1 ] ));
 end;

Procedure nilObjects;
 var
  x, y : byte;
 begin
  for y := 1 to 20 do
   for x := 1 to 70 do
     room[x,y] := nil;
 end;

procedure loadobjectss;
 begin
  loadgame('DOTH.SAV');
 end;

Procedure ShowObjects;
 var
  x, y : byte;
 begin
  for y := 1 to 20 do
   for x := 1 to 70 do
     if room[x,y] <> nil then
        {colorxy( x + 1, y +1, room[x,y]^.a, 'X' )}  room[x,y]^.draw;
 end;

Procedure UpdateObjects;
 var
  x, y : byte;
 begin
  for y := 1 to 20 do
   for x := 1 to 70 do
    begin
     if room[x,y] <> nil then room[x,y]^.Update;
    end;
 end;

Procedure DisposeObjects;
 var
  x, y : byte;
 begin
  for y := 1 to 20 do
   for x := 1 to 70 do
    if room[x,y] <> nil then room[x,y]^.done;
 end;

Procedure UpdateScreen;
 begin
  {ModifyBackground;}
  temp := screentype( dplay1 );
  WriteTo := @Temp;
  if back <> nil then stamp( 1, 1, 71, 21, back );
  ShowObjects;
  WriteTo := @Screen;
  Screen := Temp;
 end;

procedure newgame;
 begin
  gameon := true;
  gotoroom( 0 );
 end;

function quitconfirm : boolean;
 var
  s : screentype;
  confirm : zconfirmbox;
 begin
  s := screen;
  confirm.default( 20, 7,
   '|Ga|WR|Ge |WY|Gou |WS|Gu|WR|Ge |WY|Gou |WW|Ga|WNT T|Go |WQ|Gui|WT|Y?',
   '|B(|WY|B/|WN|B)|Y?' );
  quitconfirm := confirm.get;
  screen := s;
 end;

function newgameconfirm : boolean;
 var
  s : screentype;
  confirm : zconfirmbox;
 begin
  s := screen;
  confirm.default( 7, 7,
   '|WST|Ga|WRT |Go|WV|Ge|WR |WW|Gi|WTH |Ga |WN|Ge|WW G|Ga|WM|Ge|Y?',
   '|B(|WY|B/|WN|B)|Y?' );
  newgameconfirm := confirm.get;
  screen := s;
 end;

{$F+}
procedure errorbox;
{$F-}
 begin
  if erroraddr <> nil then
   begin
    bar( 15, 7, 55, 13, $08 );
    greyshadow( 15, 7, 55, 13 );
    cwritexy( 17, 8, '|!k|rÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|!K|Y!!|!k|RERROR|!K|Y!!|!k|rÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
    cwritexy( 17, 9, '|W Something really bad just happened|w!');
    cwritexy( 17, 10, '|W |B(|WMost likely|w,|W you|w''|Wre out of memory|B)');
    cwritexy( 17, 11, '|W  I|w''|Wll attempt to save as |GERROR|Y.|GSAV');
    cwritexy( 17, 12, '|W Address: '+n2s(seg(erroraddr^))+':'+n2s(ofs(erroraddr^))+' Code:'+n2s(exitcode));
    savegame( 'ERROR.SAV' );
    erroraddr := nil;
    exitcode := 0;
   end;
  exitproc := savedexit;
 end;

{$F+}
procedure loaderrorbox;
{$F-}
 begin
  if erroraddr <> nil then
   begin
    bar( 15, 7, 55, 12, $08 );
    greyshadow( 15, 7, 55, 12 );
    cwritexy( 17, 8, '|!k|rÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|!K|Y!!|!k|RERROR|!K|Y!!|!k|rÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
    cwritexy( 17, 9, '|W          Unable to load|w!');
    cwritexy( 17, 10, '|W |B(|WMost likely|w,|W you|w''|Wre out of memory|B)');
    cwritexy( 17, 11, '|W   Address: '+n2s(seg(erroraddr^))+':'+n2s(ofs(erroraddr^))+' Code:'+n2s(exitcode));
    erroraddr := nil;
    exitcode := 0;
   end;
  exitproc := savedexit;
 end;

function newobject( x, y : byte; k : kinds ) : pobj;
 var
  nobj : pobj;
 begin
  nobj := nil;
  newobject := nobj;
  case k of
   none : exit;
   wall : nobj := new( pwallobj, default( x, y ) );
   breakablewall : nobj := new( pbreakablewallobj, default( x, y ));
   boulder: nobj := new( pboulderobj, default( x, y ));
   hero: nobj := new( pheroobj, default( x, y ));
   doppelganger : nobj := new( pdoppelgangerobj, default( x, y ));
   slider: nobj := new( psliderobj, default( x, y ));
   coin: nobj := new( pcoinobj, default( x, y ));
   gem: nobj := new( pgemobj, default( x, y ));
   heart: nobj := new( pheartobj, default( x, y ));
   ammo: nobj := new( pammoobj, default( x, y ));
   key:exit;
   scroll:exit;
   spell:exit;
   item:exit;
   grapplinghook:exit;
   cableitem:exit;
   switchitem:exit;
   bombitem:exit;
   feather:exit;
   fairy:exit;
   torch:exit;
   lantern:exit;
   useritem:exit;
   chest:exit;
   generator:exit;
   movingwall: nobj := new( pmovingwallobj, default( x, y ));
   scuzzy: nobj := new( pscuzzyobj, default( x, y ));
   bullet: nobj := new( pbulletobj, init( x, y, south ));
   pusher: nobj := new( ppusherobj, default( x, y ));
   coward: nobj := new( pcowardobj, default( x, y ));
   snake: nobj := new( psnakeobj, default( x, y ));
   moron: nobj := new( pmoronobj, default( x, y ));
   head:exit;
   segment:exit;
   actor:exit;
   merchant:exit;
   oracle:exit;
   computer:exit;
   useractor:exit;
   terrain:exit;
   rope:exit;
   cable:exit;
   switch:exit;
   rapids:exit;
   deepwater:exit;
   trap:exit;
   lava:exit;
   passage:exit;
   teleport:exit;
   stairs: nobj := new( pstairsobj, default( x, y ));
   snakepit:exit;
   return:exit;
   bed:exit;
   spellstone:exit;
   gangercontrol:exit;
   bomb:exit;
   surroundspell:exit;
   creatorspell:exit;
   dock:exit;
   laser:exit;
   fan:exit;
   gravitywell:exit;
   electricwall:exit;
   invisiblewall:exit;
   factory:exit;
   gun:exit;
   duplicator:exit;
   volcano:exit;
   door:exit;
   electricdoor:exit;
   conveyor:exit;
   electricconveyor:exit;
   bouncewall:exit;
   lightbulb:exit;
   wind:exit;
   gravity:exit;
   soundtrack:exit;
   nextroom:exit;
  end;
  nobj^.kind := k;
  nobj^.isdefault := true;
  newobject := nobj;
 end;

procedure loadgame( filename : string );
 var x, y : byte;
 t : file;
 k : kinds;
 begin
  exitproc := @loaderrorbox;
  spkr.zap;
  disposeobjects;
  nilobjects;
  gameon := true;
  filereset( t, filename );
  for y := 1 to 20 do
   for x := 1 to 70 do
    begin
     blockread( t, k, 1 );
     room[ x, y ] := newobject( x, y, k );
     if room[ x, y ] <> nil then
      begin
       room[ x, y ]^.isdefault := boolean( nextbyte( t ));
       if not room[ x, y]^.isdefault then room[ x, y ]^.loadfields( t );
      end;
    end;
  close( t );
  exitproc := @errorbox;
 end;

procedure gotoroom( roomnum : integer );  (****CHANGE THIS LATER!!!!****)
 var
  f : string;
 begin
  f := n2s( roomnum ) + '.ROO';
  currentroom := roomnum;
  loadgame( f );
 end;

procedure savegame( filename : string );
 var x, y : byte;
 t : file;
 begin
  filerewrite( t, filename );
  for y := 1 to 20 do
   for x := 1 to 70 do
    if room[ x, y ] <> nil then
     begin
      blockwrite( t, room[ x, y ]^.kind, 1 );
      savebyte( t, byte( room[x,y]^.isdefault ) );
      if not room[ x, y ]^.isdefault then room[ x, y ]^.savefields( t );
     end
    else
    savebyte( t, 0 );
  close( t );
 end;

procedure menu;
 var
  m : zbouncemenu;
  result : byte;
  heap : pointer;
 begin
  exitmenu := false;
  mark(heap);
  m.Init( 5, 3, 14, 'kKwrY', gameon,
   newline('  |WD|Go|WTH M|Ge|WN|Gu   ', '', false,  #0,   0,
   newbar(
   newline('(|)|WN|()ew         ', '', true,   'N',  1,
   newline('(|)|WL|()oad        ', '', true,   'L',  2,
   newline('(|)|WS|()ave        ', '', gameon, 'S',  3,
   newbar(
   newline('(|)|WE|()dit        ', '', true,   'E',  4,
   newbar(
   newline('(|)|WQ|()uit to DOS ', '', true,   'Q',  5,
  nil ))))))))));
  repeat
    result := m.get;
   case result of
    1: if not gameon or newgameconfirm then exitmenu := true;
    else exitmenu := true;
   end;
  until exitmenu;
  release( heap );
  case result of
   1: newgame;
   2: loadgame('DOTH.SAV');
   3: savegame('DOTH.SAV');
   4: edit;
   5: if quitconfirm then begin gameon := false; progdone := true; end;
  end;
 end;

Procedure Initialize;
 begin
  savedexit := exitproc;
{  exitproc := @errorbox;}
  randomize;
  progdone := false;
  gameon := false;
  setupcrt;
  spkr.on;
  nilobjects;
  nextlevel := new( pnextroomobj, init );
  player := nil;
  screen := screentype( dplay1 );
  repeat menu until gameon or progdone;
  if progdone then exit;
  loadbackground;
  updatescreen;
 end;

Procedure ShutDown;
 begin
  DisposeObjects;
  dispose( nextlevel );
{  Clrscr;}
  DosCursorOn;
 end;

{$I dmmscr.pic }

procedure edit;
 var
  cursorx, cursory : byte;
  ch : char;
  arrow: byte;
  doneediting,toggle,cursortog,drawtog,texttog : boolean;

procedure plot;
 begin
  if
   room[ cursorx, cursory ] <> nil
  then
   room[ cursorx, cursory ]^.die;
  room[ cursorx, cursory ] :=
   newobject( cursorx, cursory, kinds( arrow - 1 ) );
  end;

 procedure cset;
  begin
   if room[ cursorx, cursory ] <> nil
    then room[ cursorx, cursory ]^.setfields;
  end;

 function getinteger : integer;
  var
   s : integer;
  begin
   bar( 5, 22, 30, 25, $08 );
   cwritexy( 6, 23, '|WR|Goo|WM |WN|Gu|WMB|Ge|WR|Y?');
   cwritexy( 6, 24, '|Y> |W');
   readln( s );
   getinteger := s;
  end;

 begin
  spkr.on;
  arrow := 1;
  cursorx := 35;
  cursory := 10;
  doneediting := false;
  toggle := true;
  drawtog := false;
  texttog := false;
  repeat
   writeto := @temp;
   temp := screentype( dmmscr );
   showobjects;
   if toggle then colorxy( 78, 20, $0D, '' ) else colorxy( 78,20, $0D, '');
   if drawtog then cwritexy( 76, 14, '|MDR|Ra|MW' );
   if texttog then cwritexy( 76, 13, '|MT|Re|MXT' );
   screen := temp;
   writeto := @screen;
   cursortog := not cursortog;
   if cursortog then colorxy( cursorx + 1, cursory + 1, $0F, 'Û' );
   colorxy( arrow + 3, 24, $0E, '' );
   if keypressed then
   begin
    ch := readkey;
    case ch of
     #0 : begin
           ch := readkey;
           case ch of
            #59 : spkr.ding{help};
            #60 : texttog := not texttog;
            #61 : drawtog := not drawtog;
           else
            if toggle then
             begin
              case ch of
               #72  : cursory := dec2( cursory, 1, 1 );
               #75  : cursorx := dec2( cursorx, 1, 1 );
               #115 : cursorx := dec2( cursorx, 5, 1 );
               #77  : cursorx := inc2( cursorx, 1, 70 );
               #116 : cursorx := inc2( cursorx, 5, 70 );
               #80  : cursory := inc2( cursory, 1, 20 );
               #71  : begin
                       cursorx := dec2( cursorx, 1, 1 );
                       cursory := dec2( cursory, 1, 1 );
                      end;
               #73  : begin
                       cursorx := inc2( cursorx, 1, 70 );
                       cursory := dec2( cursory, 1, 1 );
                      end;
               #79  : begin
                       cursorx := dec2( cursorx, 1, 1 );
                       cursory := inc2( cursory, 1, 20 );
                      end;
               #81  : begin
                       cursorx := inc2( cursorx, 1, 70 );
                       cursory := inc2( cursory, 1, 20 );
                      end;
              end; { case ch }
              if drawtog then plot;
             end { if toggle }
            else
             case ch of
              #75  : arrow := dec2( arrow, 1, 1 );
              #115 : arrow := dec2( arrow, 5, 1 );
              #77  : arrow := inc2( arrow, 1, 74 );
              #116 : arrow := inc2( arrow, 5, 74 );
             end; { case ch }
           end; { case ch }
          end; { case #0 }
     else { not #0 }
      if
       texttog
      then
       begin
        if
         room[ cursorx, cursory ] <> nil
        then
         room[ cursorx, cursory ]^.die;
        room[ cursorx, cursory ] :=
         newobject( cursorx, cursory, wall );
         room[ cursorx, cursory ]^.A := $0F;
         room[ cursorx, cursory ]^.C := ch;
         room[ cursorx, cursory ]^.isdefault := false;
        cursorx := inc2( cursorx, 1, 70 );
       end
      else
      begin
       ch := upcase( ch );
       case ch of
        #9 : toggle := not toggle;
        #13 : cset;
        ' ' : if
               room[ cursorx, cursory ] <> nil
              then
               room[ cursorx, cursory ]^.die
              else
               plot;
        'S' : savegame( n2s( getinteger ) + '.ROO' );
        'L' : gotoroom( getinteger );
        'N' : if newgameconfirm then begin disposeobjects; nilobjects; end;
        'B' :;
        'I' :;
        'Q' : if quitconfirm then doneediting := true;
       end;
      end;
     end; { main case statement }
   end; { if keypressed then begin .. }
  until doneediting;
 {  progdone := true;}
  doscursoroff;
end;

 var
   takethisout : wallobj;
begin
 Initialize;
 while not progdone do
  begin
   while gameon do
    begin
     UpdateObjects;
     UpdateScreen;
    end;
    if not progdone then menu;
  end;
 shutdown;
end.