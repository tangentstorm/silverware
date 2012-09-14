Program Advanced_Direcory_Lister;
{ version 3.0 }
Uses Dos, Crt, CrtStuff;

begin
 adl( paramline );
end.
          all this doesn't matter anymore:


Var
 DirInfo: Searchrec;
 SearchStr : String;
 Thing : Word;
 D : DirStr;
 na : NameStr;
 ex : extstr;
 pstr, N,E : String;
 T : DateTime;
 X,
 Wide,
 Pause,
 Hid,
 prgsonly : Boolean;
 TA,
 TA2 : Byte;
 C,
 C2,
 C3 : Integer;
 CD : string;
 Pchk : integer;
 S2 : string;
 nl : byte;

Procedure Help;
 begin
  cwriteln('');
  Cwriteln('|!k|WA|wdvanced |WD|wir |WL|wister |B4|w.|B0 ' +
   '|K(|Wc|K)|w1994 '+SilverWare );
  Cwriteln('|K|#Ä73');
  CWrite('|Wxxxxxxxx |wxxx');
  stWriteLn(' Ä> regular file (generic text or binary)');
  CWrite('|Yxxxxxxxx |yxxx');
  StWriteLn(' Ä> executable program (*.com *.exe)');
  CWrite('|Gxxxxxxxx |gxxx');
  StWriteLn(' Ä> executable batch file (*.bat)');
  CWrite('|Mxxxxxxxx |mxxx');
  StWriteLn(' Ä> compressed file or archive (*.arj *.zip *.arc *.pak *.zoo)');
  CWrite('|Rxxxxxxxx |rxxx');
  StWriteLn(' Ä> graphics file (*.gif *.jpg *.gl *.fli *.pic *.bmp *.pcx)');
  CWrite('|Cxxxxxxxx |cxxx');
  StWriteLn(' Ä> source code (*.bas *.pas *.asm *.inc *.c *.h *.cpp *.lsp)');
  CWrite('|bxxxxxxxx xxx');
  StWriteLn(' Ä> hidden file of any type (must use /a option)');
  CWrite('|BXXXXXXXXXXX ');
  StWriteLn(' Ä> subdirectory');
  CWrite('|bXXXXXXXXXXX ');
  StWriteLn(' Ä> hidden subdirectory (with /a option)');
  Cwriteln('|K|#Ä73');
  StWRiteln('Switches (type after "ADL" from the command line):');
  Cwriteln('|K|#Ä73');
  StWriteln(' /a Ä> shows all files in the directory, including hidden files. ');
  StWriteln(' /w Ä> allows for a wider display of filenames.');
  StWriteln(' /p Ä> pauses after each screenful of information.');
  StWriteln(' /e Ä> show only executable files.');
  StWriteln(' /h Ä> this help screen.');
  Cwriteln('|K|#Ä73');
  halt(0);
 end;

Function LZ( w : Word ) : String;
 var
  s : String;
 begin
  Str( w:0, s );
  if
   length( s ) = 1
  then
   s := '0' + s;
  lz := s;
 end;

Function LastPart( S : String ) : String;
 var
  counter : byte;
 begin
  s := '\' + s;
  counter := length( s );
  While
   S[counter] <> '\'
  do
   dec( counter, 1 );
  Delete( S, 0, counter+1 );
  Lastpart := S;
 end;

Begin
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
 if
  paramcount > 0
 then
  for
   pchk := 1 to paramcount
  do
   pstr := pstr + ' ' + paramstr( pchk );
 If
  CD[length(cd)]='\'
 then
  Delete(CD,length(cd),1);
 If (pos('/?', pstr) > 0) or  (pos('/H', upstr(pstr)) > 0) then help;
 hid   := pos( '/A', upstr(pstr)) > 0;
 wide  := pos( '/W', upstr(pstr)) > 0;
 pause := pos( '/P', upstr(pstr)) > 0;
 prgsonly := pos( '/E', upstr(pstr)) > 0;
 If
  Paramstr(1) = ''
 then
  SearchStr := CD+'\*.*'
 else
  for
   Pchk := 1 to Paramcount
  do
   if
    pos( '/', paramstr( pchk )) = 0
   then
    SearchStr := paramstr(pchk);
 If
  SearchStr = ''
 then
  SearchStr := CD+'\*.*';
 If
  Searchstr[Length(searchstr)] = ':'
 then
  searchstr := searchstr + '\';
 If
  Searchstr[Length(searchstr)] = '\'
 then
  searchstr := searchstr + '*.*';
 Findfirst( SearchStr, Thing, DirInfo );
 s2 := Upstr( lastpart( SearchStr ) );
 If
  ( ( DirInfo.Attr = Directory ) and
  ( DirInfo.Name = s2 ) ) or
  ( Searchstr = '..' )
 then
  searchstr := searchstr + '\*.*';
 If
  Hid
 then
  Thing := Anyfile;
 Findfirst( SearchStr, Thing, DirInfo );
 Stwrite( 'Looking at : '+dnstr( SearchStr ) );
 cwriteln('');
 cwriteln('');
 nl := 4;
 While DosError = 0 do
  begin
   FSplit( DirInfo.Name, d, na, ex );
   n := na;
   e := ex;
   Delete( E, 1, 1 );
   n := dnstr( normaltext( n ) );
   e := dnstr( normaltext( e ) );
   If
    ( dirInfo.Attr and VolumeID <> 0 )
   then
    begin
     TColor := $08;
     cwrite( flushrt( DirInfo.Name, 12, ' ' ) );
     if
      (not wide)
     then
      if
       x
      then
       cwriteLn('   |B[|WVolume ID|B]')
     else
      cwrite('   |B[|WVolume ID|B]           ');
     C3 := 1;
    end
   else
    If
     ( DirInfo.Attr and Hidden ) <> 0
    then
     begin
      TColor := $01;
      if
       (dirInfo.Attr and Directory) <> 0
      then
       cwrite( flushrt( DirInfo.Name, 12, ' ' ))
      else
      cwrite( flushrt( N, 8, ' ' ) + ' ' + flushrt( E, 3, ' ' ) );
      if
       (not Wide)
      then
       if
        (dirinfo.Attr and Directory <> 0)
       then
        cwrite('   |B[|WDir|B]')
      else
       cwrite(' ' + flushrt( n2s( DirInfo.Size ), 6, ' ' ) + ' ' );
      if
       not wide
      then
       If
        X
       then
        cWriteLn(' |B[|WHid|B]')
       else
        cwrite(' |B[|WHid|B]           ');
       if
        dirinfo.attr and directory <> 0
       then
        inc( c2, 1 )
       else
        inc( c, 1 );
     end
    else
     Case DirInfo.Attr of
      Directory :
       begin
        Ta := $09;
        TColor := $09;
        cwrite( flushrt( DirInfo.Name, 12, ' ' ) );
        if
         ( not wide )
        then
         if
          x
         then
          cwriteln('   |B[|WDir|B]')
        else cwrite('   |B[|WDir|B]                 ');
         Inc(C2,1);
       end;
      Else
       begin
        TA := $0F; TA2 := $07;
        if
         ( e = 'exe' ) or
         ( e = 'com' )
        then
          TA := $0E;
        if
         e = 'bat'
        then
         TA := LightGreen;
        if (ta = $0F) and prgsonly then ta := 0 else
        begin
         if
          ( e = 'zip' ) or
          ( e = 'arc' ) or
          ( e = 'lzh' ) or
          ( e = 'pak' ) or
          ( e = 'zoo' ) or
          ( e = 'arj' )
         then
          TA := $0D;
         if
          ( e = 'gif' ) or
          ( e = 'jpg' ) or
          ( e = 'gl'  ) or
          ( e = 'fli' ) or
          ( e = 'pic' ) or
          ( e = 'bmp' ) or
          ( e = 'pcx' )
         then
          TA := $0C;
         if
          ( e = 'bas' ) or
          ( e = 'pas' ) or
          ( e = 'asm' ) or
          ( e = 'inc' ) or
          ( e = 'c' ) or
          ( e = 'h' ) or
          ( e = 'cpp' ) or
          ( e = 'lsp' )
         then
          TA := $0B;
        end;
        Case TA of
         $0A :
          TA2 := $02;
         $0D :
          TA2 := $05;
         $0C :
          TA2 := $04;
         $0B :
          TA2 := $03;
         $0E :
          TA2 := $06;
        end;
        if ta <> 0 then
        begin
         TColor := TA;
         cwrite( flushrt( N, 8, ' ' ) );
         TColor := TA2;
         cwrite( flushrt( E, 4, ' ' ) );
         If
          Not Wide
         then
          begin
           TColor := TA;
           UnPacktime(DirInfo.Time,T);
           cwrite( ' ' + flushrt( n2s( DirInfo.Size ), 6, ' ' ) + ' ' );
           TColor := TA2;
           cwrite(LZ(T.Hour)+':'+LZ(T.Min));
           TColor := TA;
           If X then
            cwriteLn(' '+LZ(T.Month)+'/'+LZ(T.Day)+'/'+n2s(T.Year))
           else
            cwrite((' '+LZ(T.Month)+'/'+LZ(T.Day)+'/'+N2S(T.Year))+' ');
          end; { if not wide }
         Inc(c,1);
        end; { if ta <> 0 }
       end; { if ta <> 0 }
      end;  { case dirinfo }
     FindNext(DirInfo);
     if ta <> 0
     then
      begin
       TColor := $08;
       If
        Wide
       then
        if
         ((C + C2 + C3) mod 5 = 0)
        then
         cwriteln('')
        else cwrite( '  ³ ')
       else
        if
         (Not X)
        then
         cwrite(' ³  ');
       if
        txpos = 1
       then
        begin
         inc( nl );
         if (nl mod 22 = 0) and pause then hitakey;
        end;
       X := Not X;
      end;
     end;
 If
  txpos > 1
 then
 cwriteln('');
 cwriteln('');
 StWriteLn( N2S(C)+' file(s), '+N2s(c2)+' directories in this listing, '+
 N2S(DiskFree(0))+' bytes free.');
 Cwrite('|WA|wdvanced |WD|wir |WL|wister |B4|w.|B0 |K(|Wc|K)|w1994' + SilverWare );
 StWriteLn(' Type "ADL /h" for help.');
 gotoxy( txpos, typos );
End.
