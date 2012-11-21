{Doth: Quest for an Empire
       (c)1992 Michal Wallace / Sterling Silverware }

Program Doth;
Uses Crt, CrtStuff, ZokStuff, SSWstuff;

{$I DTitle.PIC}
{$I DPlay1.PIC}

type
 Things =  ( Hero, Grass, Wall, Water, Box, Door, Scroll, TLast );
 ThingRec = Record
              Name : String[15];
              At : Byte;
              Token  : String;
              MGld : Word;
              MLif : Integer;
              Pathlength,
              PathPointer : byte;
              Path : String;
            end;

Const
  ThingArray : array[Ord(Hero)..Ord(TLast)] of ThingRec =
  ( ( Name: 'Hero';   At: $0E; Token: #2 ),
    ( Name: 'Grass';  At: $2A; Token: '.'),
    ( Name: 'Wall';   At: $08; Token: '▓'),
    ( Name: 'Water';  At: $1F; Token: '                                   '+
            '                                                           -_'),
    ( Name: 'Box';    At: $0C; Token: '■'),
    ( Name: 'Door';   At: $0F; Token: '∩'),
    ( Name: 'Scroll'; At: $09; Token: '≈'),
    ( Name: 'Last' ) );


Type
 Ranks =   ( Novice, Adventurer, AdventurerFirstClass, RLast );
 Statuss = ( Healthy, Thirsty, Hungry, Weak, Tired, Sick, Poisoned, SLast );
 Maps = ( Arcaine, CastleDoth, ArboxBase );
 AMap  =  Array[ 0..71, 0..21 ] of Things; { 70x20, with border }
 Thing = Object
           X, Y : Byte;
           Stats: ThingRec;
           Gold : Word;
           Life, MaxLife : Integer;
           TypeOfThing,
           UnderNeath  : Things;
           Inventory : Pointer;
           Procedure Get( T : Things );
           Procedure Put;
           Procedure Ouch;
           Procedure Transform( T : Things );
           Procedure PMove;
           Procedure Move( ra, rb : integer );
         end;
 ThListPtr = ^ThingList;
 ThingList = record
              next : ThListPtr;
              branch : ^Thing;
             end;
 ThListObj = Object
              ThListRoot : ThingList;
              Procedure Add;
              Procedure Clear;
              Procedure Delete;
             end;
 AHero = Object ( Thing )
          Name    : String[20];
          Rank    : Ranks;
          Status  : Statuss;
          Playing : Boolean;
          Procedure Load;
          Procedure Save;
          Procedure Create;
          Procedure Mnu;
          Procedure Control;
          Procedure Show;
         end;
 ARoom = Object
          X, Y, Z : Byte; { coordinates of screen on WORLD map }
          Player  : AHero;
          TLObj   : ThListObj;
          Function ThingAt( a, b : byte ) : things;
          Procedure Play;
          Procedure Setup;
          Procedure GetMap;
          Procedure ShowMap;
         end;

Const
 RankArray : Array [ ord( Novice ) .. ord( RLast )] of string =
      ( 'Novice', 'Adventurer', 'Adventurer 1rst Class',
       '');
 StatusArray : Array [ ord( Healthy ) .. ord( SLast )] of string =
     ( 'Healthy', 'Thirsty', 'Hungry', 'Weak', 'Tired', 'Sick',
       'Poisoned', '' );


Var                                     
 Done,Gameover : Boolean;
 Room : ARoom;
 WMap : File Of AMap;
 Dos : ScreenType;
 Map : AMap;
 CurrentMap : Maps;

Procedure Init;
 begin
  done := False;
  Gameover := True;
  Dos := Screen;
  CurrentMap := Arcaine;
  DosCursorOff;
  Screen := ScreenType( DTitle );
  GetEnter;
 end;

Procedure Message( M : String );
 var
  c : byte;
 begin
  for c := length( M ) + 1 to 46 do M[c] := ' ';
  for c := 1 to 46 do
   begin
    sound(50);
    delay(2);
    stwritexy( 32 + c, 23, M[c] );
    nosound;
   end;
 end;

Procedure NoMessage;
 begin
  Message(' ');
 end;

Function Zero( s: string; l : byte ) : string;
 var
  c : byte;
 begin
  While length( s ) < l do
   insert( ' ', s, 1 );
  for c := 1 to l do
   if s[c] = '0' then s[c] := 'O';
  Zero := s;
 end;

Procedure GameScreen;
 begin
  fillscreen( $19B1 );
  screen := ScreenType( DPlay1 );
  StWriteXY( 73,  4,  #24': North' );
  StWriteXY( 73,  5,  #25': South' );
  StWriteXY( 73,  6,  #27': East'  );
  StWriteXY( 73,  7,  #26': West'  );
  StWriteXY( 73,  8,    '+: Up'    );
  StWriteXY( 73,  9,    '-: Down'  );
  StWriteXY( 73, 11,    '/: Sword' );
  StWriteXY( 73, 12,    '*: Fire'  );
  StWriteXY( 73, 13,    '.: Item'  );
  StWriteXY( 73, 14,    '■: Stats' );
  StWriteXY( 73, 15,    '0: Notes' );
  StWriteXY( 73, 17,    'P: Pause' );
  StWriteXY( 73, 18,    'S: Sound' );
  StWriteXY( 73, 19,    '?: More'  );
  StWriteXY( 73, 21,    'Esc:Menu' );
 end;

{$I DMAP1.PIC}
Procedure MapScreen;
 var
  a, b : byte;
  s,s2 : screentype;
 begin
    s := screen;
    for b := 0 to 21 do
      move( dmap1[ b*144 + 1 ], s2[ b*160 ], 144 );
    screen := ( s2 );
    message ('Press <Enter> to return to game...');
    getenter;
    screen := s;
 end;

Procedure Thing.Get( T : Things );
 begin
  TypeOfThing := T;
  Stats := ThingArray[ ord( TypeOfThing ) ];
 end;

Procedure Thing.Put;
 begin
  UnderNeath := Map[ X, Y ];
  Map[ X, Y ] := TypeOfThing;
 end;

Procedure Thing.Ouch;
 begin
 end;

Procedure Thing.Transform( T : Things );
 begin
 end;

Procedure Thing.PMove;
 begin
 end;

Procedure Thing.Move( ra, rb : integer );
 var
  a, b : byte;
 begin
  Map[ X, Y ] := UnderNeath;
  a := X + ra;
  If a > 70 then a := 70;
  If a < 1 then a := 1;
  b := Y + rb;
  If b > 20 then b := 20;
  If b < 1 then b := 1;
  UnderNeath :=  Room.ThingAt( a, b );
  X := a;
  Y := b;
  Map[ X, Y ] := TypeOfThing;
 end;

Procedure ThListObj.Add;
 begin
 end;

Procedure ThListObj.Clear;
 begin
 end;

Procedure ThListObj.Delete;
 begin
 end;

Function Confirm( s: string ) : boolean;
 begin
 end;

Procedure Ahero.Load;
 begin
 end;

Procedure Ahero.Save;
 begin
 end;

Procedure Ahero.Create;
 var
  s : ScreenType;
  i : input;
 begin
  s := Screen;
  Rectangle(17,7,50,10,$08);
  StWriteXY(18,8,'Enter a name for your hero(ine):' );
  StWriteXY(18,9,'Name:                           ' );
  i.init(25,9,20,$0F,$89,'▒');
  Name    := i.Get;
  Rank    := Novice;
  Status  := Healthy;
  Gold    := 0;
  Life    := 10;
  MaxLife := 10;
  Get( Hero );
  X := 35;
  Y := 10;
  Room.GetMap;
  Put;
  TypeOfThing := Hero;
  delay(100);
  screen := s;
  gameover := false;
 end;

Procedure AHero.Mnu;
 var
  m : zbouncemenu;
  s : screentype;
 begin
  s := screen;
  m.Init( 15,5,30, '', not gameover,
   newline(' Create a new character       ', '', true, 'c', 1,
   newline(' Load a character from disk   ', '', true, 'l', 2,
   newbar(
   newline(' Save your character to disk  ', '', not gameover, 's', 3,
   newline(' Return to Game               ', '', not gameover, 'r', 4,
   newbar(
   newline(' Quit Doth <return to DOS>    ', '', true, 'q', 5,
  nil ))))))));
  case m.get of
   1: Create;
   2: Load;
   3: Save;
   4:;
   5: begin done := true; gameover := true; end;
  end;
  screen := s;
 end;

Procedure AHero.Show;
 begin
  colorXY(  9, 23, $09, Name );
  colorXY(  9, 24, $09, RankArray[ ord( Rank ) ] );
  colorXY( 39, 24, $09, Zero( N2S( Gold ),   5 ) );
  colorXY( 51, 24, $09, Zero( N2S( Life ),   4 ) );
  colorXY( 56, 24, $09, Zero( N2S( MaxLife), 4 ) );
  colorXY( 71, 24, $09, StatusArray[ ord( status ) ] );
 end;

Procedure Ahero.Control;
 var
  ch : Char;
 begin
  if keypressed then ch := dncase( readkey ) else ch := #255;
  case ch of
   '1' : move( -1, +1 );
   '2' : move(  0, +1 );
   '3' : move( +1, +1 );
   '4' : move( -1,  0 );
   '6' : move( +1,  0 );
   '7' : move( -1, -1 );
   '8' : move(  0, -1 );
   '9' : move( +1, -1 );
   '+' :;
   '-' :;
   'f' :;
   't' :;
   'l' :;
   'g' :;
   'i' :;
   's' :;
   'r' :;
   'p' : Begin
          Message('Press <Enter> to Continue...');
          GetEnter;
          NoMessage;
         end;
   #27 : Mnu;
   '?' :;
   '0' : MapScreen;
   #0 : begin
         ch := readkey;
         case ch of
          ' ' :;
         end;
        end;
  end;
 end;

Function Aroom.ThingAt(a,b : byte) : things;
 begin
  ThingAt := Map[ a, b ];
 end;

Procedure Aroom.Play;
 begin
  repeat
   ShowMap;
   Player.Show;
   Player.Control;
  until gameover;
 end;

Procedure Aroom.Setup;
 begin
  GetMap;
  Player.Mnu;
 end;

Procedure Aroom.GetMap;
 var
  ac, bc : byte;
 begin
  for bc := 1 to 20 do
   for ac := 1 to 50 do
    Map[ ac, bc ] := Grass;
  for bc := 1 to 20 do
   for ac := 51 to 70 do
    Map[ ac, bc ] := Water;
 end;

Procedure Aroom.ShowMap;
 var
  ac, bc, t : byte;
 begin
  for bc := 1 to 20 do
   for ac := 1 to 70 do
    begin
     t := Ord( Map[ ac, bc ] );
     ColorXY( ac + 1, bc + 1, ThingArray[ t ].At,
              ThingArray[ t ].Token[Random(length(Thingarray[t].token))+1]);
    end;
 end;

Begin
 Init;
 GameScreen;
 Repeat
  Room.Setup;
  Room.Play;
 until done;
 Screen :=  dos;
 DosCursorOn;
{ ClrEOL;}
End.