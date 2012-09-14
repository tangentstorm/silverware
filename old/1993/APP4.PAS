Program App4;
Uses app,objects,drivers,dialogs,menus,editors,views,AppStuff,crt,crtstuff,TvrStuff;


Type
 ZApp4 = object( TApplication )
  menubox : pdialog;
  constructor init;
  procedure initmenubox;
  procedure initmenubar; virtual;
  procedure initstatusline; virtual;
  procedure HandleEvent( var Event : TEvent ); virtual;
  procedure newwindow;
  procedure shopmenu;
 end;

const
 prompt = '|bÄ|BÄ|CÄ|W>';
 CmNil = 100;
 CmShop = 101;
 cmNew = 102;

procedure ZApp4.initmenubar;
 begin
  Menubar := nil;
 end;

procedure Zapp4.initstatusline;
 var
  r: Trect;
 begin
{  statusline := new( pstatusline, init}
  TApplication.InitStatusline;
 end;

procedure Zapp4.initmenubox;
 var
  r : TRect;
  m : pmenubox;
 begin
  r.assign( 16, 3, 36,  15 );
  menubox := new( pdialog, init( r, 'Menu' ) );
  r.assign( 1, 1, 20, 12);
  m := New( PMenuBox, Init( R, NewMenu(
    NewItem( '~I~nformation', '', kbNoKey, cmNil, hcNoContext,
    NewLine(
    NewItem( 'E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
    NewItem( '~L~oad', 'F3', kbF3, cmNew, hcNoContext,
    NewLine(
    NewItem( '~S~hopping ...', '', kbHome, cmShop, hcNoContext,
    NewItem( '~C~ontents', '', kbAltC, cmNil, hcNoContext,
    NewItem( '~I~ndex', '', kbAltI, cmNil, hcNoContext,
    nil )))))))))
   ,  nil ));
  m^.setstate( sfshadow, false );
  menubox^.insert( m );
  menubox^.flags := wfmove;
  getextent( r );
  desktop^.insert(menubox);
 end;

procedure Zapp4.newwindow;
 var
  r : trect;
  w : pwindow;
  e : peditor;
 begin
  r.assign( 15, 5, 35, 15 );
  w := new( pwindow, init( r, 'Editor', 0 ));
  w^.insert( w^.standardscrollbar( sbhorizontal ));
  w^.insert( w^.standardscrollbar( sbvertical ));
  r.assign( 1, 1, w^.size.x -1 , w^.size.y -1 );
  w^.insert( new( peditor, init( r, nil, nil, nil, 4500 )));
  desktop^.insert( w );
 end;

{$I DBAR}
constructor Zapp4.Init;
 var
  r: trect;
 begin
  TApplication.Init;
  shadowsize.x := 1;
  initmenubox;
  getextent( r ); r.b.y := r.a.y + 1;
  insert( new( appstuff.pcel, init( r, @Dbar )));
 end;

procedure Zapp4.HandleEvent(var Event : TEvent );
 begin
  TApplication.HandleEvent( Event );
  if
   Event.What = EvCommand
  then
   begin
     case
      Event.Command
     of
      cmShop : ShopMenu;
      cmNew  : NewWindow;
     else
      Exit;
     end;
    clearevent( event );
   end;
 end;

{$I SHOP.PAS}
{$I OWN1.PAS}
{$I OWN2.PAS}
{$I OWN3.PAS}
{$I OWN4.PAS}
procedure Zapp4.Shopmenu;
 var
  r : Trect;
  w : pdialog;
  c : appstuff.pcel;
  b : pbutton;
  s : pstatictext;
  control : word;
 begin
  R.Assign( 17, 3, 59, 13 );
  w := new( pdialog, init( R, 'Quickie-Mart' ));
  R.Assign( 1, 1, 41, 9 );
  w^.insert( new( appstuff.pcel, init( r, @shop )));
  R.Assign( 2, 2, 14, 9 );
  randomize;
  case random( 4 ) + 1 of
   1 : c := new( appstuff.pcel, init( r, @own1 ));
   2 : c := new( appstuff.pcel, init( r, @own2 ));
   3 : c := new( appstuff.pcel, init( r, @own3 ));
   4 : c := new( appstuff.pcel, init( r, @own4 ));
  end;
  w^.insert( c );
  r.Assign( 16, 2, 38, 3 );
  w^.insert( new ( pstatictext, init( r, 'What can I do for ya?' ) ) );
  R.Assign( 17, 5, 26, 7 );
  w^.insert( new( pbutton, init( R, '~B~uy', cmnil, bfNormal ) ) );
  R.Assign( 30, 5, 39, 7 );
  w^.insert( new( pbutton, init( R, '~T~rade', cmnil, bfnormal ) ) );
  R.Assign( 17, 7, 26, 9 );
  b := new( pbutton, init( R, ' ~S~ell', cmnil, bfNormal ));
  w^.insert( b );
  R.Assign( 30, 7, 39, 9 );
  b := new( pbutton, init( R, '~L~eave', cmCancel, bfdefault ));
  w^.insert( b );
  control := desktop^.execview(w);
 end;

Var
 A4 : ZApp4;
 Progdone : Boolean;
 Counter : Word;
 ch : char;
 RND : ScreenSaver;
 inp : input;
 s : string;

Procedure docommand( s : string );
 begin
  if
   s = ''
  then
   cwriteln( '|Yş |GEh|g?');
  if
   s = 'CLS'
  then
   begin
    cwcommand( cwclrscr , '');
    rnd.getscreen;
   end;
  if
   (s = 'QUIT') or (s = 'Q')
  then
   begin
    Cwriteln(' |Yş |GAre you |Ysure|G you want to quit|g? ');
   end;
  if
   (s = '/Q')
  then
   progdone := true;
  if
   (s = '/W') or (s = '/WHO')
  then
   begin
    cwriteln('');
    cwriteln('|KÄ|WUsers|KÄ|WOnline|KÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
    cwriteln('|w Battle Axe    Cybernet - yay!');
    cwriteln('|w Pirate        Has anyone seen my bottle of rum?');
    cwriteln('|Yú|wFigment       ');
    cwriteln('|Yú|cSterling      |GWelcome to CyberNet|g...');
    cwriteln('|w Yagi Hito     ');
    cwriteln('|KÄ|WFree|KÄ|WLines|B:|KÄÄ|W05|KÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
    cwriteln('');
   end;
 end;

function parse( s : string ) : string;
 begin
  parse := Upstr( s );
 end;

procedure thing;
begin
 doscursoroff;
 textattr := $0F;
 clrscr;
 cwrite( prompt );
 rnd.init;
 inp.init( true );
 While Keypressed do ch := Readkey;
 Counter := 0;
 Progdone := false;
 While not ProgDone do
  begin
    RND.Handle( counter );
    Counter := Counter + 1;
    if keypressed then
     begin
      Counter := 0;
      RND.Handle( counter );
      ch := readkey;
      case ch of
       ^Q : Progdone := True;
       else
        begin
         inp.handle(ch);
         Rnd.GetScreen;
        end;
      end;
     end;
    if
     inp.readstring( s )
    then
     begin
      docommand( parse( s ) );
      cwrite( prompt );
      rnd.getscreen;
     end;
  end;
  doscursoron;
end;


begin
 A4.Init;
 A4.Run;
 A4.Done;
end.