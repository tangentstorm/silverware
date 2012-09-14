unit filstuff;   { file routines }

interface

const
 fileok = 0;
 filenotfound = 2;
 pathnotfound = 3;
 toomanyopenfiles = 4;
 fileaccessdenied = 5;
 invalidfilehandle = 6;
 invalidfileaccesscode = 7;

var
 result : word;

 procedure filereset  ( var f : file; s : string );
 procedure filerewrite( var f : file; s : string );
 procedure fileappend ( var f : file; s : string );
 procedure savebyte( var f : file; b : byte );
 procedure saveshortint( var f : file; s : shortint );
 procedure saveboolean( var f : file; b : boolean );
 procedure saveword( var f : file; w : word );
 procedure saveinteger( var f : file; i : integer );
 procedure savelongint( var f : file; l : longint );
 procedure savestring ( var f : file; s : string );
 procedure savevar ( var f : file; var v );
 procedure nextvar( var f : file; var v );
 function fileexists ( s : string ) : boolean;
 function nextbyte( var f : file ) : byte;
 function nextshortint( var f : file ) : shortint;
 function nextboolean( var f : file ) : boolean;
 function nextword( var f : file ) : word;
 function nextinteger( var f : file ) : integer;
 function nextlongint( var f : file ) : longint;
 function nextstring( var f : file ) : string;
 function fileerrorstring : string;

implementation

procedure filereset  ( var f : file; s : string );
 begin
 {$I-}
  assign( f, s );
  reset( f, 1 );
 {$I+}
  result := ioresult;
 end;

procedure filerewrite( var f : file; s : string );
 begin
 {$I-}
  assign( f, s );
  rewrite( f, 1 );
 {$I+}
  result := ioresult;
 end;

procedure fileappend ( var f : file; s : string );
 begin
 {$I-}
  assign( f, s );
  rewrite( f, 1 );
 {$I+}
  result := ioresult;
 end;

procedure savebyte( var f : file; b : byte );
 begin
  blockwrite( f, b, 1 );
 end;

procedure saveshortint( var f : file; s : shortint );
 begin
  blockwrite( f, s, 1 );
 end;

procedure saveboolean( var f : file; b : boolean );
 begin
  blockwrite( f, b, 1 );
 end;

procedure saveword( var f : file; w : word );
 begin
  blockwrite( f, w, 2 );
 end;

procedure saveinteger( var f : file; i : integer );
 begin
  blockwrite( f, i, 2 );
 end;

procedure savelongint( var f : file; l : longint );
 begin
  blockwrite( f, l, 4 );
 end;

procedure savestring ( var f : file; s : string );
 begin
  blockwrite( f, s[0], 1 );
  blockwrite( f, s[1], byte(s[0]));
 end;

procedure savevar( var f : file; var v );
 var
  s : integer;
 begin
  s := sizeof( v );
  blockwrite( f, s, 2 );
  blockwrite( f, v, sizeof( v ) );
 end;

procedure nextvar( var f : file; var v );
 var
  siz : integer;
 begin
  siz := nextinteger( f );
  blockread( f, v, siz );
 end;

function  fileexists ( s : string ) : boolean;
 var
  t : file;
 begin
{$I-}
 filereset( t, s );
 close( t );
{$I+}
 fileexists := (ioresult = 0) and (s <> '');
 end;

function nextbyte( var f : file ) : byte;
 var
  n : byte;
 begin
  blockread( f, n, 1 );
  nextbyte := n;
 end;

function nextshortint( var f : file ) : shortint;
 var
  n : shortint;
 begin
  blockread( f, n, 1 );
  nextshortint := n;
 end;

function nextboolean( var f : file ) : boolean;
 var
  n : boolean;
 begin
  blockread( f, n, 1 );
  nextboolean := n;
 end;


function nextword( var f : file ) : word;
 var
  n : word;
 begin
  blockread( f, n, 2 );
  nextword := n;
 end;

function nextinteger( var f : file ) : integer;
 var
  n : integer;
 begin
  blockread( f, n, 2 );
  nextinteger := n;
 end;

function nextlongint( var f : file ) : longint;
 var
  n : longint;
 begin
  blockread( f, n, 4 );
  nextlongint := n;
 end;

function nextstring( var f : file ) : string;
 var
  n : string;
  b : byte;
 begin
  blockread( f, b, 1 );
  blockread( f, n[1], b );
  n[0] := chr(b);
  nextstring := n;
 end;

function fileerrorstring : string;
 begin
  case result of
   fileok                : fileerrorstring := 'No problems...';
   filenotfound          : fileerrorstring := 'File not found.';
   pathnotfound          : fileerrorstring := 'Path not found.';
   toomanyopenfiles      : fileerrorstring := 'Too many open files.';
   fileaccessdenied      : fileerrorstring := 'File access denied.';
   invalidfilehandle     : fileerrorstring := 'Invalid file handle.';
   invalidfileaccesscode : fileerrorstring := 'Invalid file access code.';
  end;
 end;

begin
 result := fileok;
end.