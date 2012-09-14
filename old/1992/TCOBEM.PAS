{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
{    The Cult of Boffology's Electronic Megazine       }
{         Source code (c)1992-93 S³LVîâWêRî            }
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
Program TCoBEM;

uses
 Objects, Menus, Drivers, Views, Gadgets, App, CrtStuff, Dialogs, StdDlg, dos;

{ÄÄÄÄÄÄÄÄÄÄÄ}
{ Commands  }
{ÄÄÄÄÄÄÄÄÄÄÄ}
Const
  cmPrevPage = 100;
  cmNextPage = 101;
  cmTitlPage = 102;
  cmContents = 103;
  cmIndex    = 104;
  cmLoad     = 1000;
  cmInform   = 1001;
  CmSet      = [ cmNextPage, cmPrevPage, cmTitlPage, cmContents, cmIndex ];

{ÄÄÄÄÄÄÄÄÄÄÄ}
{ Types     }
{ÄÄÄÄÄÄÄÄÄÄÄ}
Type
 PIssueView = ^TIssueView;
 TIssueView = Object( TView )
  Message : String[ 38 ];
  Constructor Init( var Bounds : TRect );
  Procedure NewMessage( s : string );
  Procedure Draw; virtual;
 end;
 APage = Record
  Name : String;
  Picture : Array [ 1 .. 3680 ] of char;
 end;
 PContent = ^AContent;
 AContent = Record
  Name : String;
  Num : Word;
 end;
 PContentCollection = ^TContentCollection;
 TContentCollection = object ( TCollection )
 end;
 PIndexCollection = ^TIndexCollection;
 TIndexCollection = object ( TSortedCollection )
  function Compare( key1, key2 : pointer ) : integer; virtual;
 end;
 PContentBox = ^TContentBox;
 TContentBox = object ( TListBox )
   function GetText( item : integer; maxLen : integer ) : string; virtual;
 end;
 PContentDialog = ^TContentDialog;
 TContentDialog = object( TDialog )
  ContentBox : PContentBox;
  constructor Init( Var Bounds : TRect; ATitle : TTitleStr; PCont : PContentBox );
 end;
 PMainView = ^TMainView;
 TMainView = object( TView )
  IssueView : PIssueView;
  IssueName : String;
  TheIndex : PIndexCollection;
  TableOfContents : PContentCollection;
  PageFile : File;
  PageFileName : PathStr;
  Page : APage;
  PageNum,
  NumPages : word;
  constructor Init( var Bounds : TRect );
  Procedure DisableBrowse;
  Procedure EnableBrowse;
  procedure Draw; virtual;
  procedure ChangeToPage( p : word );
  procedure LoadMeg;
  procedure GetFileName;
  procedure ChangeToPageRel( p : integer );
  procedure GetContents;
  procedure Contents;
  procedure Index;
  procedure InitIssueView;
  procedure OpenMeg;
  procedure CloseMeg;
  destructor done; virtual;
 end;
 TMag = object ( TApplication )
  Clock : PClockView;
  MainView : PMainView;
  Constructor Init;
  Procedure HandleEvent ( var Event : TEvent ); virtual;
  Procedure Idle; Virtual;
  Procedure InfoBox;
  Procedure InitClockView;
  Procedure InitMainView;
  Procedure InitStatusLine; virtual;
  Procedure InitMenuBar; virtual;
 end;

Var
 Megazine : TMag;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TIndexCollection  }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
function TIndexCollection.Compare( key1, key2 : pointer ) : integer;
 begin
  if PContent( key1 )^.Name < PContent( key2 )^.Name
   then compare := -1
  else if PContent( key1 )^.Name = PContent( key2 )^.Name
   then compare := 0
  else
   compare := 1;
 end;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TContentBox    }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function TContentBox.GetText( Item: integer; MaxLen : Integer ) : String;
 begin
  GetText := PContent( List^.At( Item ))^.Name;
 end;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TIssueView   }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
constructor TIssueView.Init( var Bounds : TRect );
 begin
  TView.Init( Bounds );
  FillChar( Message, SizeOf( Message ), #$FF );
  Message := ' TCOBEM.EXE Version 1.0 ';
 end;

Procedure TIssueView.NewMessage( s : string );
 begin
  Message := s;
  Draw;
 end;

Procedure TIssueView.Draw;
 var
  B: TDrawBuffer;
  C: byte;
 begin
  WriteChar( 0, 0, ' ', 2, Size.X );
  WriteStr( 0, 0, '³  ', 4 );
  WriteStr( 2, 0, Message, 2 );
 end;

{ÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TMainView  }
{ÄÄÄÄÄÄÄÄÄÄÄÄ}

Procedure TMainview.DisableBrowse;
 begin
  DisableCommands( CmSet );
 end;

Procedure TMainView.EnableBrowse;
 begin
  EnableCommands( CmSet );
 end;

Constructor TMainView.Init( var Bounds : TRect );
 begin
  TView.Init( bounds );
  InitIssueView;
  DisableBrowse;
  TheIndex := New( PIndexCollection, Init( 20, 1 ) );
  TableOfContents := New( PContentCollection, Init( 20, 1 ) );
  GetFileName;
 end;

Procedure TMainView.GetContents;
 Var
  Wait : PDialog;
  R : TRect;
  Control : word;
  temp : Apage;
  pc : pcontent;
  pnum : word;
 begin
  R.Assign( 20, 5, 60, 10 );
  Wait := New( PDialog, Init( R, '' ) );
  Wait^.Flags := $0000;
  R.Assign( 6, 2, 35, 3 );
  Wait^.Insert( New( PStaticText, Init( R, 'Loading Contents... Wait...' ) ) );
  Wait^.Flags := $00;
  DeskTop^.Insert( Wait );
  TheIndex^.DeleteAll;
  TableOfContents^.DeleteAll;
  new( pc );
  pnum := 0;
  BlockRead( PageFile, temp, 1 );
  IssueName := Temp.Name;
  while not eof( PageFile ) do
   begin
    inc( pnum );
    BlockRead( PageFile, temp, 1 );
    if Temp.Name <> '' then
     begin
       new(pc);
       pc^.Name := Temp.Name + ' -=> ' + N2S( pnum );
       pc^.Num := pnum;
       TableOfContents^.Insert( pc );
       TheIndex^.Insert( pc );
     end;
   end;
  NumPages := PNum;
  Dispose( Wait, Done );
 end;

Constructor TContentDialog.Init( Var Bounds : TRect; ATitle : TTitleStr;
                                 PCont : PContentBox );
 begin
  TDialog.Init( Bounds, ATitle );
  ContentBox := PCont;
 end;

Procedure TMainView.Contents;
 var
  ContentBox : PContentBox;
  AScrollBar : PScrollBar;
  ContentDialog : PContentDialog;
  control : word;
  R : TRect;
 begin
  R.Assign( 37, 2, 38, 10 );
  AScrollBar := New( PScrollBar, Init ( R ) );
  R.Assign( 2, 2, 37, 10 );
  ContentBox := New( PContentBox, Init( R, 1, AScrollBar ) );
  ContentBox^.NewList( TableOfContents );
  R.Assign( 20, 3, 60, 18 );
  ContentDialog := New( PContentDialog, Init( R, 'Table of Contents' , ContentBox ) );
  ContentDialog^.Flags := $0000;
  R.Assign( 5, 12, 15, 14 );
  ContentDialog^.Insert( New( PButton, Init( R, 'Go To', cmOK, bfDefault )));
  R.Assign( 25, 12, 35, 14 );
  ContentDialog^.Insert( New( PButton, Init( R, 'Cancel', cmCancel, bfNormal )));
  ContentDialog^.Insert( AScrollBar );
  ContentDialog^.Insert( ContentBox );
  Control := DeskTop^.ExecView( ContentDialog );
  if Control = cmOK then
   ChangeToPage( PContent( ContentBox^.List^.At( ContentBox^.Focused ))^.Num );
 end;

Procedure TMainView.Index;
 var
  ContentBox : PContentBox;
  AScrollBar : PScrollBar;
  ContentDialog : PContentDialog;
  control : word;
  R : TRect;
 begin
  R.Assign( 37, 2, 38, 10 );
  AScrollBar := New( PScrollBar, Init ( R ) );
  R.Assign( 2, 2, 37, 10 );
  ContentBox := New( PContentBox, Init( R, 1, AScrollBar ) );
  ContentBox^.NewList( TheIndex );
  R.Assign( 20, 3, 60, 18 );
  ContentDialog := New( PContentDialog, Init( R, 'Index' , ContentBox ) );
  ContentDialog^.Flags := $0000;
  R.Assign( 5, 12, 15, 14 );
  ContentDialog^.Insert( New( PButton, Init( R, 'Go To', cmOK, bfDefault )));
  R.Assign( 25, 12, 35, 14 );
  ContentDialog^.Insert( New( PButton, Init( R, 'Cancel', cmCancel, bfNormal )));
  ContentDialog^.Insert( AScrollBar );
  ContentDialog^.Insert( ContentBox );
  Control := DeskTop^.ExecView( ContentDialog );
  if Control = cmOK then
   ChangeToPage( PContent( ContentBox^.List^.At( ContentBox^.Focused ))^.Num );
 end;

Procedure TMainView.ChangeToPage( p : word );
 begin
  If p <= NumPages then PageNum := p;
  Seek( PageFile, PageNum );
  BlockRead( PageFile, Page, 1 );
  IssueView^.NewMessage( IssueName + '  Page ' +N2S( PageNum )
                         + ' of ' +  N2S( NumPages ) );
  Draw;
 end;

Procedure TMainView.ChangeToPageRel( p : integer );
 begin
  If ( PageNum + p >= 0 ) and ( PageNum + p <= NumPages )
   then ChangeToPage( PageNum + p );
 end;

Procedure TMainView.LoadMeg;
 begin
  OpenMeg;
  GetContents;
  ChangeToPage( 0 );
  EnableBrowse;
 end;

Procedure TMainView.InitIssueView;
 var
  R : TRect;
 begin
  R.Assign( 42, 24, 80, 25 );
  IssueView := New( PIssueView, Init( R ) );
  Megazine.Insert( IssueView );
 end;


Procedure TMainView.GetFileName;
 var
  feeb : PFileDialog;
  S : TSTREAM;
 begin
  Feeb := New( PFileDialog, Init( '*.MEG', 'Load',
          '~MEGA~zine to Load:', fdOpenButton + fdHelpButton, $00 ) );
  Feeb^.Flags := $0000;
  if DeskTop^.ExecView( Feeb ) <> cmCancel then
   begin
    Feeb^.GetFileName( PageFileName );
    LoadMeg;
   end;
  dispose( Feeb, Done );
 end;

Procedure TMainView.Draw;
 begin
  WriteBuf( Origin.X, Origin.Y, Size.X, Size.Y,  Page.Picture  );
 end;

Procedure TMainView.OpenMeg;
 begin
  System.Assign( PageFile, PageFileName );
  System.Reset( PageFile, SizeOf( APage ) );
 end;

Procedure TMainView.CloseMeg;
 begin
  {$I-}
  System.Close( PageFile );
  {$I+}
 end;

Destructor TMainView.Done;
 begin
  CloseMeg;
  TView.Done;
 end;

{ÄÄÄÄÄÄÄÄÄÄÄ}
{ TMag      }
{ÄÄÄÄÄÄÄÄÄÄÄ}

Constructor TMag.Init;
 begin
  TApplication.Init;
  InitClockView;
  InitMainView;
 end;

Procedure TMag.HandleEvent( var Event : TEvent );
 var
  control : word;
 begin
  TApplication.HandleEvent( Event );
  if Event.What = evCommand then
  begin
   case Event.Command of
    cmNextPage : MainView^.ChangeToPageRel( 1 );
    cmPrevPage : MainView^.ChangeToPageRel( -1 );
    cmTitlPage : MainView^.ChangeToPage( 0 );
    cmLoad : MainView^.GetFileName;
    cmContents : MainView^.Contents;
    cmIndex : MainView^.Index;
    cmInform : InfoBox;
   else
    Exit;
   end;
   ClearEvent( Event );
  end;
 end;

Procedure TMag.Idle;
 begin
  TApplication.Idle;
  Clock^.Update;
 end;

Procedure TMag.InfoBox;
 var
  Inf : PDialog;
  R : TRect;
  Control : Word;
 begin
  R.Assign( 20, 5, 60, 15 );
  Inf := New( PDialog, Init( R, 'Information' ) );
  with Inf^ do
   begin
    flags := $0000;
    R.Assign( 8, 2, 35, 3 );
    Insert( New( PStaticText, Init( R, 'The Cult of Boffology''s' )));
    R.Assign( 10, 3, 35, 4 );
    Insert( New( PStaticText, Init( R, 'Electronic MEGAzine' )));
    R.Assign( 10, 4, 35, 5 );
    Insert( New( PStaticText, Init( R, 'Reader Program v1.0' )));
    R.Assign( 7, 5, 35, 6 );
    Insert( New( PStaticText, Init( R, '(c)1993 SÅîâL³NG S³LVîâWêâî')));
    R.Assign( 15, 7, 25, 9 );
    Insert( New( PButton, Init( R, '~O~K', cmOk, bfDefault )));
   end;
  Control := DeskTop^.ExecView( Inf );
 end;

Procedure TMag.InitClockView;
 Var
  R : TRect;
 begin
  GetExtent( R );
  R.B.Y := R.A.Y + 1;
  R.A.X := 70;
  Clock := ( New( PClockView, Init( R ) ) );
  Insert( Clock );
 end;

Procedure TMag.InitMainView;
 var
  R : TRect;
 begin
  R.Assign( 0, 0, 80, 25 );
  MainView := New( PMainView, Init( R ) );
  DeskTop^.Insert( MainView );
 end;

Procedure TMag.InitStatusLine;
 var
  R : TRect;
 begin
  GetExtent( R );
  R.A.Y := R.B.Y - 1;
  R.B.X := 42;
  StatusLine := New( PStatusLine, Init( R,
   NewStatusDef( 0, $FFFF,
    NewStatusKey( '[~Alt~-~X~] Exit', kbAltX, cmQuit,
    NewStatusKey( '[~Pg'#24'~] Previous', kbPgUp, cmPrevPage,
    NewStatusKey( '[~Pg'#25'~] Next', kbPgDn, cmNextPage,
    NewStatusKey( '', kbF10, cmMenu,
    nil )))),
   nil )
  ));
 end;

Procedure TMag.InitMenuBar;
 var
  r : TRect;
 begin
  GetExtent( R );
  R.B.Y := R.A.Y + 1;
  R.B.X := 70;
  MenuBar := New( PMenuBar, Init( R, NewMenu(
   NewSubMenu( '~ğ~', hcNoContext, NewMenu(
    NewItem( '~I~nformation', '', kbNoKey, cmInform, hcNoContext,
    NewLine(
    NewItem( 'E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
    nil )))),
   NewSubMenu( '~MEGA~zine', hcNoContext, NewMenu(
    NewItem( '~L~oad', 'F3', kbF3, cmLoad, hcNoContext,
    NewLine(
    NewItem( '~T~itle Page', 'Home', kbHome, cmTitlPage, hcNoContext,
    NewItem( '~C~ontents', 'Alt-C', kbAltC, cmContents, hcNoContext,
    NewItem( '~I~ndex', 'Alt-I', kbAltI, cmIndex, hcNoContext,
    nil )))))),
   nil ))
  )));
 end;

begin
 Megazine.Init;
 Megazine.Run;
 Megazine.Done;
end.