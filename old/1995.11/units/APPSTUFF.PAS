Unit AppStuff;

InterFace
uses objects,views;
Type
 ScreenType = array [0..3999] of Byte;
 PCel = ^TCel;
 TCel = object( TView )
  Cel : ^tdrawbuffer;
  constructor init( r : trect; buf : pointer );
  procedure draw; virtual;
  destructor done; virtual;
 end;
 ZObject = object
  Constructor Init;
  Procedure Handle( var command ); virtual;
  Procedure Execute; virtual;
  Destructor Done; virtual;
 end;
 ClockType = object( ZObject )
 end;
 Input = object( ZObject )
  echo ,
  full : boolean;
  contents : String;
  constructor init( echoyn : boolean );
  procedure handle( var command ); virtual;
  function readstring( var s : string ) : boolean; virtual;
 end;
 ScreenSaver = object( ZObject )
  BackUp : ScreenType;
  Constructor Init;
  Procedure GetScreen;
  Procedure RestoreScreen;
  Procedure Handle( var counter ); virtual;
 end;

var
  Screen : ScreenType absolute $B800:$0000;

Implementation
Uses Crt,crtstuff;

constructor TCel.Init( r : Trect; buf : pointer );
 begin
  TView.Init( r );
  new( cel );
  cel := buf;
 end;

procedure TCel.Draw;
 begin
  tview.draw;
  writebuf( 0, 0, size.x, size.y, cel^ );
 end;

destructor TCel.done;
 begin
  dispose( cel );
 end;

Constructor ZObject.Init;
 begin
 end;

Procedure ZObject.Handle( var Command );
 begin
 end;

Procedure ZObject.Execute;
 begin
 end;

Destructor ZObject.Done;
 begin
 end;

Constructor Input.init( echoyn : boolean );
 begin
  echo := echoyn;
  contents := '';
  full := no;
 end;

Procedure Input.Handle( var command );
 var
  c : char;
  skip : boolean;
 begin
  skip := false;
  c := char( command );
  case c of
   #13  : full := true;
   #8   : begin
           skip := length( contents ) = 0;
           delete( contents, length( contents ), 1 );
          end;
   else contents := contents + c;
  end;
  if
   echo and ( not skip )
  then
   cwrite( c );
 end;

Function Input.Readstring( var s : string )  : boolean;
 begin
  s := '';
  if
   full
  then
   begin
    full := false;
    s := contents;
    readstring := true;
    contents := '';
   end
  else
   readstring := false;
 end;

Constructor ScreenSaver.Init;
 begin
  GetScreen;
 end;

Procedure ScreenSaver.GetScreen;
 begin
  BackUp := Screen;
 end;

Procedure ScreenSaver.RestoreScreen;
 begin
  Screen := BackUp;
 end;

Procedure ScreenSaver.Handle( var Counter );
 var
  w : word;
 begin
  w := word( counter );
  if w = 0 then
   begin
    Restorescreen;
    GetScreen;
   end;
  If w > 10000 then
   begin
    colorxy ( random( 80 ) + 1, random( 25 ) + 1,
              random( 15 ) + 1, chr( random( 256 ) ) );
   end;
 end;

End.