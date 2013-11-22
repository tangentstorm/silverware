{ Advanced_Direcory_Lister }
{ version 7.0 - free pascal edition }
program adl;
uses xpc, dos, cw, ustr, num, mjw, kvm, cli;

function LastPart( s : string ) : string;
  var counter : byte;
  begin
    s := '\' + s;
    counter := length( s );
    while s[counter] <> '\' do dec( counter, 1 );
    Delete( S, 0, counter+1 );
    Lastpart := S;
  end;

function LZ( w : Word ) : string;
  var s : string;
  begin
    Str( w:0, s );
    if length( s ) = 1 then s := '0' + s;
    lz := s;
  end;

const
  ver = '|B6|w.|B0';

var
  c, c2 : byte;
  cd, searchstr, cline : string;
  searchattr : word;
  dirinfo : searchrec;
  dowide,
  doattr,
  dohelp,
  dopause,
  dodirsonly,
  doprgsonly : boolean;

procedure init(cline :string);
  var pchk : byte;
  begin
    SearchStr := '';
    cwriteln('|_');
    GetDir(0,CD);
    if CD[length(cd)]='\' then Delete(CD,length(cd),1);
    dowide     := pos('/W', upstr(cline)) > 0;
    doattr     := pos( '/A', upstr(cline)) > 0;
    dopause    := pos( '/P', upstr(cline)) > 0;
    doprgsonly := pos( '/E', upstr(cline)) > 0;
    dodirsonly := pos( '/D', upstr(cline)) > 0;
    dohelp     := (pos('/?', cline ) > 0) or  (pos('/H', upstr(cline)) > 0);
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
    SearchAttr := Directory;
    Findfirst( SearchStr, searchattr, DirInfo );
    if (( DirInfo.Attr = Directory) and
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


procedure adl( cline : string );
  var
    SearchStr : string;
    Thing     : Word;
    D	      : DirStr;
    na	      : NameStr;
    ex	      : extstr;
    pstr, N,E : string;
    T	      : DateTime;
    X,
    Wide,
    Pause,
    Hid,
    prgsonly,
    dirsonly  : Boolean;
    TA,
    TA2	      : Byte;
    C,
    C2,
    C3	      : Integer;
    CD	      : string;
    Pchk      : integer;
    S2	      : string;
    nl	      : byte;


  begin
    SearchStr := '';
    cwriteln('');
    cwriteln('');
    Thing := Directory;
    X := False;
    C := 0;
    C2 := 0;
    C3 := 0;
    Wide := False;
    Hid := False;
    Pause := False;
    GetDir(0,CD);
    pstr := '';
    if nwords( cline ) > 0 then
      for pchk := 1 to nwords( cline ) do
	pstr := pstr + ' ' + wordn( cline, pchk );
    if CD[length(cd)]='\' then Delete(CD,length(cd),1);
    if (pos('/?', pstr) > 0) or  (pos('/H', upstr(pstr)) > 0) then help;
    hid   := pos( '/A', upstr(pstr)) > 0;
    wide  := pos( '/W', upstr(pstr)) > 0;
    pause := pos( '/P', upstr(pstr)) > 0;
    prgsonly := pos( '/E', upstr(pstr)) > 0;
    dirsonly := pos( '/D', upstr(pstr)) > 0;
    if wordn( cline, 1) = '' then
      begin
	SearchStr := cd+'\'
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
    if (( DirInfo.Attr = Directory ) and
	( DirInfo.name = s2 ))
      or ( Searchstr = '..' )
      then searchstr := searchstr + '\*.*';
    if Hid then Thing := Anyfile;
    Findfirst( SearchStr, Thing, DirInfo );
    Stwrite( 'Looking at : '+dnstr( SearchStr ) );
    cwriteln('');
    cwriteln('');
    nl := 4;
    while DosError = 0 do
      begin
	FSplit( DirInfo.name, d, na, ex );
	n := na;
	e := ex;
	Delete( E, 1, 1 );
	n := dnstr( normaltext( n ) );
	e := dnstr( normaltext( e ) );
	if ( dirInfo.Attr and VolumeID <> 0 ) then
          begin
	    Textattr := $08;
	    cwrite( flushrt( DirInfo.name, 12, ' ' ) );
	    if (not wide) then
	      if x then cwriteLn('    |B[|WVolume ID|B]')
	      else cwrite('    |B[|WVolume ID|B]            ');
	    C3 := 1;
	  end
	else if ( DirInfo.Attr and Hidden ) <> 0 then
          begin
	    ta := 1;
	    Textattr := $01;
	    if (dirInfo.Attr and Directory) <> 0 then
	      cwrite( flushrt( DirInfo.name, 12, ' ' ))
	    else cwrite( flushrt( N, 8, ' ' ) + ' ' + flushrt( E, 3, ' ' ) );
	    if (not Wide) then
	      if (dirinfo.Attr and Directory <> 0) then
		cwrite('    |B[|WDir|B]')
	      else
		cwrite(' ' + flushrt( n2s( DirInfo.Size ), 8, ' ' ) );
	    if not wide then
	      if X then cWriteLn(' |B[|WHid|B]')
	      else cwrite(' |B[|WHid|B]            ');
	    if dirinfo.attr and directory <> 0 then inc( c2, 1 )
	    else inc( c, 1 );
	  end
	else case DirInfo.Attr of
	  Directory :
	    begin
	      Ta := $09;
	      Textattr := $09;
	      cwrite( flushrt( DirInfo.name, 12, ' ' ) );
	      if ( not wide ) then
		if x then cwriteln('    |B[|WDir|B]')
		else cwrite('    |B[|WDir|B]                  ');
	      Inc(C2,1);
	    end;
	  else if dirsonly then ta := 0
	  else
	    begin
	      TA := $0F; TA2 := $07;
	      if ( e = 'exe' ) or ( e = 'com' ) then TA := $0E;
	      if e = 'bat' then TA := $0A;
	      if (ta = $0F) and prgsonly then ta := 0
	      else begin
		if pos(ustr.rpad( e,3,'*'),
		       'zip/arc/lzh/pak/zoo/arj') <> 0 then TA := $0D;
		if pos(ustr.rpad( e,3,'*'),
		       'gif/jpg/gl/fli/pic/bmp/tga/pcx') <> 0 then TA := $0C;
		if pos(ustr.rpad( e,3,'*'),
		       'bas/pas/asm/inc/c/h/cpp/lsp') <> 0 then TA := $0B;
		if pos(ustr.rpad( e,3,'*'),
		       'bak/bk!/old/tmp/$$$') <> 0 then TA := $07;
		if pos(ustr.rpad( e,3,'*'),
		       'rep/qwk') <> 0 then TA := $04;
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
		    // !! if x then writeln ' ' else write(' ');
		    if X then
		      cwriteln(' '+LZ(T.Month)+'/'+LZ(T.Day)+'/'+n2s(T.Year))
		    else
		      cwrite((' '+LZ(T.Month)+'/'+LZ(T.Day)+'/'+N2S(T.Year))+' ');
		  end; { if not wide }
		Inc(c,1);
	      end; { if ta <> 0 }
	    end; { if ta <> 0 }
	end;  { case dirinfo }
	FindNext(DirInfo);
	if ta <> 0 then begin
	  Textattr := $08;
	  if Wide then
	    if ((C + C2 + C3) mod 5 = 0) then cwriteln('')
	    else cwrite( ' │ ')
	  else if (not X) then cwrite('│ ');
	  if wherex = 1 then begin
	    inc( nl );
	    if (nl mod 22 = 0) and pause then hitakey;
	  end;
	  X := not X;
	end;
      end;
    if wherex > 1 then cwriteln('');
  end;

procedure footer;
  begin
    cwriteln('');
    CWriteLn( '|B'+N2S(C)+' |Wfile|B(|Ws|B)|w,|B '+N2s(c2)+
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