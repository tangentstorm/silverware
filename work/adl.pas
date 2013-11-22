{$mode objfpc}{$h+}
{ Advanced_Direcory_Lister }
{ version 7.0 - free pascal edition }
program adl;
uses xpc, cw, ustr, num, mjw, kvm, cli, dos, sysutils;

function LastPart( s : string ) : string;
  var counter : byte;
  begin
    s := '\' + s;
    counter := length( s );
    while s[counter] <> '\' do dec( counter, 1 );
    Delete( S, 0, counter+1 );
    Lastpart := S;
  end;

function LZ( w : Word ) : string; // leading zero if necessary
  begin
    Str( w:0, result );
    if length( result ) = 1 then result := '0' + result;
  end;

const
  ver = '|B6|w.|B0';

var
  fcount : byte = 0;
  dcount : byte = 0;
  cd, searchstr, cline : string;
  dirinfo : TSearchRec;
  searchattr : word;
  optWide,
  optAttr,
  optHelp,
  optPause,
  optDirsOnly,
  optPrgsOnly : boolean;

procedure init(cline :string);
  var pchk : byte;
  begin
    SearchStr := '';
    cwriteln('|_');
    GetDir(0,CD);
    if CD[length(cd)]='\' then Delete(CD,length(cd),1);
    optwide     := pos( '-W', upstr(cline)) > 0;
    optattr     := pos( '-A', upstr(cline)) > 0;
    optpause    := pos( '-P', upstr(cline)) > 0;
    optprgsonly := pos( '-E', upstr(cline)) > 0;
    optdirsonly := pos( '-D', upstr(cline)) > 0;
    opthelp     := (pos('-?', cline ) > 0) or  (pos('-H', upstr(cline)) > 0);
    for pchk := 1 to nwords( cline ) do
      if pos('/', wordn( cline, pchk )) = 0
	then SearchStr := wordn( cline, pchk);
    if SearchStr = '' then SearchStr := CD+'\';
    if Searchstr[Length(searchstr)] = ':' then
      begin
	getdir( ord(upcase(searchstr[1]))-ord('A')+1, searchstr );
	if searchstr[length(searchstr)]<>'\' then searchstr := searchstr+'\';
      end; { of what to do for x: }
    {$I-} chdir( copy( searchstr , 1, length(searchstr)-1 ) ); {$I+}
    if Searchstr[Length(searchstr)] = '\' then searchstr := searchstr + '*.*';
    SearchAttr := faAnyFile and faDirectory;
    Findfirst( SearchStr, searchattr, DirInfo );
    if (( DirInfo.Attr = faDirectory) and
	( DirInfo.name = upstr(lastpart( searchstr ))))
    or (Searchstr = '..')
    then searchstr := searchstr + '\*.*';
  end; { init }

procedure Help;
 begin
   cwriteln('');
   Cwriteln('|!k|WA|wdvanced |WD|wir |WL|wister |B4|w.|B0 ' +
	    '|K(|Wc|K)|w1994 '+SilverWare );
   Cwriteln('|K|#─73');
   CWrite('|Wxxxxxxxx |wxxx');
   stWriteLn(' ─> regular file (generic text or binary)');
   CWrite('|Yxxxxxxxx |yxxx');
   StWriteLn(' ─> executable program (*.com *.exe)');
   CWrite('|Gxxxxxxxx |gxxx');
   StWriteLn(' ─> executable batch file (*.bat)');
   CWrite('|Mxxxxxxxx |mxxx');
   StWriteLn(' ─> compressed file or archive (*.arj *.zip *.arc *.pak *.zoo)');
   CWrite('|Rxxxxxxxx |rxxx');
   StWriteLn(' ─> graphics file (*.gif *.jpg *.gl *.fli *.pic *.bmp *.pcx)');
   CWrite('|Cxxxxxxxx |cxxx');
   StWriteLn(' ─> source code (*.bas *.pas *.asm *.inc *.c *.h *.cpp *.lsp)');
   CWrite('|bxxxxxxxx xxx');
   StWriteLn(' ─> hidden file of any type (must use /a option)');
   CWrite('|BXXXXXXXXXXX ');
   StWriteLn(' ─> subdirectory');
   CWrite('|bXXXXXXXXXXX ');
   StWriteLn(' ─> hidden subdirectory (with /a option)');
   Cwriteln('|K|#─73');
   StWRiteln('Switches (type after "ADL" from the command line):');
   Cwriteln('|K|#─73');
   StWriteln(' /a ─> shows all files in the directory, including hidden files. ');
   StWriteln(' /w ─> allows for a wider display of filenames.');
   StWriteln(' /p ─> pauses after each screenful of information.');
   StWriteln(' /e ─> show only executable files.');
   StWriteln(' /h ─> this help screen.');
   Cwriteln('|K|#─73');
   halt(0);
 end;


function JoinDirs(paths : array of variant) : string;
  var s : string;
  begin
    result := '';
    for s in paths do AppendStr(result, s);
  end;

procedure adl( cline : string );
  var
    SearchStr : string = '';
    Thing     : Word = faDirectory;
    pstr      : string = '';
    N,E	      : string;
    T	      : DateTime;
    X	      : boolean = false;
    Pause     : boolean = false;
    Hid	      : boolean = false;
    Wide      : boolean = false;
    prgsonly  : boolean = false;
    dirsonly  : boolean = false;
    TA,
    TA2	      : Byte;
    C3	      : Integer = 0;
    CD	      : string;
    Pchk      : integer;
    S2	      : string;
    nl	      : byte;

  begin
    GetDir(0,CD);
    if nwords( cline ) > 0 then
      for pchk := 1 to nwords( cline ) do
	pstr := pstr + ' ' + wordn( cline, pchk );
    if CD[length(cd)]='\' then Delete(CD,length(cd),1);
    if (pos('/?', pstr) > 0) or  (pos('/H', upstr(pstr)) > 0) then help;
    hid   := pos( '-A', upstr(pstr)) > 0;
    wide  := pos( '-W', upstr(pstr)) > 0;
    pause := pos( '-P', upstr(pstr)) > 0;
    prgsonly := pos( '-E', upstr(pstr)) > 0;
    dirsonly := pos( '-D', upstr(pstr)) > 0;
    if wordn( cline, 1) = '' then
      begin
	SearchStr := cd + '\'
      end
    else
      for Pchk := 1 to nwords( cline ) do
	if pos( '/', wordn( cline, pchk )) = 0
	  then SearchStr := wordn( cline, pchk);
    if SearchStr = '' then SearchStr := CD+'\';
    if Searchstr[1] = '.' then searchstr := '*' + searchstr;
    if Searchstr[Length(searchstr)] = ':' then
      begin
	getdir( ord(upcase(searchstr[1]))-ord('A')+1, searchstr );
	if searchstr[length(searchstr)] <> '\'
	  then searchstr := searchstr + '\';
      end;
  {$I-} chdir( copy( searchstr , 1, length(searchstr)-1 ) ); {$I+}
  if Searchstr[Length(searchstr)] = '\' then searchstr := searchstr + '*.*';
    Findfirst( SearchStr, Thing, DirInfo );
    s2 := Upstr( lastpart( SearchStr ) );
    if (( DirInfo.Attr = FaDirectory ) and
	( DirInfo.name = s2 ))
      or ( Searchstr = '..' )
      then searchstr := searchstr + '\*.*';
    if Hid then Thing := faAnyfile;
    Findfirst( SearchStr, Thing, DirInfo );
    Stwrite( 'Looking at : '+dnstr( SearchStr ) );
    cwriteln('');
    nl := 4;
    repeat
      begin
        e := extractfileext(dirinfo.name);
        n := extractfilename(dirinfo.name);
	Delete( E, 1, 1 );
	n := dnstr( normaltext( n ) );
	e := dnstr( normaltext( e ) );
	if ( dirInfo.Attr and faVolumeID ) <> 0 then
          begin
	    Textattr := $08;
	    cwrite( flushrt( DirInfo.name, 12, ' ' ) );
	    if (not wide) then
	      if x then cwriteLn('    |B[|WVolume ID|B]')
	      else cwrite('    |B[|WVolume ID|B]            ');
	    C3 := 1;
	  end
	else if ( DirInfo.Attr and faHidden ) <> 0 then
          begin
	    ta := 1;
	    Textattr := $01;
	    if (dirInfo.Attr and FaDirectory) <> 0 then
	      cwrite( flushrt( DirInfo.name, 12, ' ' ))
	    else cwrite( flushrt( N, 8, ' ' ) + ' ' + flushrt( E, 3, ' ' ) );
	    if (not Wide) then
	      if (dirinfo.Attr and faDirectory <> 0) then
		cwrite('    |B[|WDir|B]')
	      else
		cwrite(' ' + flushrt( n2s( DirInfo.Size ), 8, ' ' ) );
	    if not wide then
	      if X then cWriteLn(' |B[|WHid|B]')
	      else cwrite(' |B[|WHid|B]            ');
	    if dirinfo.attr and faDirectory <> 0 then inc( dcount )
	    else inc( fcount );
	  end
	else case DirInfo.Attr of
	  faDirectory :
	    begin
	      Ta := $09; Textattr := $09;
	      cwrite( flushrt( DirInfo.name, 12, ' ' ) );
	      if ( not wide ) then
		if x then cwriteln('    |B[|WDir|B]')
		else cwrite('    |B[|WDir|B]                  ');
	      inc( dcount );
	    end;
	  else if dirsonly then ta := 0
	  else
	    begin
	      TA := $0F; TA2 := $07;
              case e of
                'com' : ta := $0E;
                'exe' : ta := $0E;
                'bat' : ta := $0A;
              end;
	      if (ta = $0F) and prgsonly then ta := 0
	      else case e of
                'zip','arc','lzh','pak','zoo','arj' : ta := $0D;
                'gif','jpg','gl','fli','pic','bmp','tga','pcx' : TA := $0C;
		'bas','pas','asm','inc','c','h','cpp','lsp' : TA := $0B;
                'bak','bk!','old','tmp','$$$' : TA := $07;
                'rep','qwk' : TA := $04;
	      end;
	      case TA of
		$0A : TA2 := $02;
		$0D : TA2 := $05;
		$0C : TA2 := $04;
		$0B : TA2 := $03;
		$07 : TA2 := $08;
		$0E : TA2 := $06;
		$04 : ta2 := $08;
	      end;
	      if ta <> 0 then
		begin
		  Textattr := TA;
		  cwrite( flushrt( N, 8, ' ' ) );
		  Textattr := TA2;
		  cwrite( flushrt( E, 4, ' ' ) );
		  if not Wide then
		    begin
		      Textattr := TA;
		      UnPacktime(DirInfo.Time,T);
		      cwrite( ' ' + flushrt( n2s( DirInfo.Size ), 8, ' ' ) + ' ' );
		      Textattr := TA2;
		      cwrite(LZ(T.Hour)+':'+LZ(T.Min));
		      Textattr := TA;
		      cwrite(' '+LZ(T.Month)+'/'+LZ(T.Day)+'/'+n2s(T.Year));
		      if x then writeln else write(' ');
		    end;
		  Inc(fcount);
		end; { if ta <> 0 }
	    end; { if ta <> 0 }
	end;  { case dirinfo }
	if ta <> 0 then begin
	  Textattr := $08;
	  if Wide then
	    if ((fcount + dcount + C3) mod 5 = 0) then cwriteln('')
	    else cwrite( ' │ ')
	  else if (not X) then cwrite('│ ');
	  if wherex = 1 then begin
	    inc( nl );
	    if (nl mod 22 = 0) and pause then hitakey;
	  end;
	  X := not X;
	end;
      end;
    until FindNext(DirInfo) <> 0;
    FindClose(DirInfo);
    if wherex > 1 then cwriteln('');
  end;

procedure footer;
  begin
    cwriteln('');
    CWriteLn( '|B' + n2s(fcount) + ' |Wfile|B(|Ws|B)|w,|B '+ n2s(dcount) +
	     ' |Wdirectories in this listing|w,|B '+ N2S(DiskFree(0))+'|W bytes free|w.');
    Cwrite('|WA|wdvanced |WD|wir |WL|wister '+ver+' |K(|Wc|K)|w1994 ' + SilverWare );
    StWriteLn(' type "ADL /?" for help.');
  end; { footer }

begin
  cline := paramline;
  init(cline);
  adl(paramline);
  footer;
  {$I-} chdir(cd); {$I+}
end.
