program Doth;
Uses Crt,crtstuff,zokstuff,sndstuff,filstuff,pntstuff;

{ þ Global Types }
Type
 Pobj = ^obj;
 obj = object ( node )
  active : boolean;
  constructor init;
  procedure update;
  procedure act; virtual;
  procedure draw; virtual;
 end;
 roomstring = array [ 1 .. 1400 ] of pobj; { for speedier broadcasting }

{ þ Global Variables }
var
 progdone,
 gameon : boolean;
 room : array[1..70,1..20] of Pobj;
 player : pobj;

{$I DOTHSCR.Pas}

{ þ Global Procedures and Functions }

function confirm( Message : string ) : boolean;
 var
  confirmbox : zconfirmbox;
 begin
  dosscreen := screen;
  confirmbox.default( 20, 7, message, '|B(|WY|B/|WN|B)|Y?' );
  confirm := confirmbox.get;
  screen := dosscreen;
 end;

procedure menu;
 var
  m : zbouncemenu;
  result : byte;
  heap : pointer;
  writetemp : screentypeptr;
  exitmenu : boolean;
 begin
  writetemp := writeto;
  writeto := @screen;
  exitmenu := false;
  mark(heap);
  m.Init( 4, 2, 14, 'kKwrY', gameon, false,
   newchoice('  |WD|Go|WTH M|Ge|WN|Gu   ', '', false,  #0,   0, nil,
   newsepbar(
   newchoice('(|)|WN|()ew         ', '', true,   'N',  1, nil,
   newchoice('(|)|WL|()oad        ', '', true,   'L',  2, nil,
   newchoice('(|)|WS|()ave        ', '', gameon, 'S',  3, nil,
   newchoice('(|)|WC|()ontrols    ', '', true,   'C',  4, nil,
   newsepbar(
   newchoice('(|)|WE|()dit        ', '', true,   'E',  5, nil,
   newsepbar(
   newchoice('(|)|WQ|()uit to DOS ', '', true,   'Q',  6, nil,
  nil )))))))))));
  greyshadow( 4, 2, 19, 13 );
  repeat
    result := m.get;
   case result of
    1: if not gameon or
         confirm('|WST|Ga|WRT |Go|WV|Ge|WR |WW|Gi|WTH |Ga'+
                 '|WN|Ge|WW G|Ga|WM|Ge|Y?')
       then exitmenu := true;
    else exitmenu := true;
   end;
  until exitmenu;
  release( heap );
  case result of
   1: {new};
   2: {load};
   3: {save};
   4: {controls - mouse, soundblastervolume, font };
   5: {edit};
   6: if confirm('|Ga|WR|Ge |WY|Gou |WS|Gu|WR|Ge |WY|Gou |WW|Ga|WNT '+
                 'T|Go |WQ|Gui|WT|Y?')
      then begin gameon := false; progdone := true; end;
  end;
  writeto := writetemp;
 end;

{ þ Object Procedures and Functions }

constructor obj.init;
 begin
 end;

procedure obj.update;
 begin
  if active then act;
 end;

procedure obj.draw;
 begin
 end;


procedure obj.act;
 begin
 end;

{ þ Normal Variables }
var
 Masterheap : pointer;

{ þ Normal Procedures and Functions }

Procedure nilObjects;
 var
  x, y : byte;
 begin
  for y := 1 to 20 do
   for x := 1 to 70 do
     room[x,y] := nil;
 end;

Procedure UpdateObjects;
 var
  x, y : byte;
 begin
  for y := 1 to 20 do
   for x := 1 to 70 do
     if room[x,y] <> nil then
       room[x,y]^.update;
 end;

Procedure ShowObjects;
 var
  x, y : byte;
 begin
  for y := 1 to 20 do
   for x := 1 to 70 do
     if room[x,y] <> nil then
       room[x,y]^.draw;
 end;


Procedure UpdateScreen;
 begin
  dosscreen := screentype(dothscreen);
  writeto := @dosscreen;
  bar( 1, 1, 71, 21, $0F );
  ShowObjects;
  screen := dosscreen;
 end;

Procedure Initialize;
 begin
  Mark( Masterheap );
  randomize;
  progdone := false;
  gameon := false;
  WriteTo := @Dothscreen;
  setupcrt;
  spkr.on;
  nilobjects;
  player := nil;
  screen := screentype( dothscreen );
  repeat menu until gameon or progdone;
  if progdone then exit;
  updatescreen;
 end;

Procedure ShutDown;
 begin
  Release( Masterheap );
  Setmode( 3 );
  writeto := @screen;
  cwriteln( '|_|_|WD|Go|Wth |w/ |b[|B[|WS|Ca|WBR|Ce|WN|B]|b]');
  DosCursorOn;
 end;

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