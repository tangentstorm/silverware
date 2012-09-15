program animals;
uses crt,filstuff,crtstuff,zokstuff;

function padstr( s : string; len : byte; ch : char ) : string;
 begin
   if length( s ) > len then s[0] := chr(len);
   while length( s ) < len do s := s + ch;
   padstr := s;
  end;

procedure savelongint( var f : file; l : longint );
 begin
  blockwrite( f, l, 4 );
 end;

function nextlongint( var f : file ) : longint;
 var
  n : longint;
 begin
  blockread( f, n, 4 );
  nextlongint := n;
 end;


procedure saveword( var f : file; w : word );
 begin
  blockwrite( f, w, 2 );
 end;

function nextword( var f : file ) : word;
 var
  n : word;
 begin
  blockread( f, n, 2 );
  nextword := n;
 end;

procedure savevar( var f : file; var v; size : word );
 begin
  saveword( f, size );
  blockwrite( f, v, size );
 end;

procedure nextvar( var f : file; var v );
 var
  s : word;
 begin
  s := nextword( f );
  blockread( f, v, s );
 end;

procedure idxinit( var f : file; tenchars : string; num : longint );
 var
  z : longint;
 begin
  tenchars := padstr( tenchars, 10, ' ' );
  blockwrite( f, tenchars[1], 10 ); { file header }
  savelongint( f, num ); { number of entries }
  for z := 0 to num do savelongint( f, 0 ); { num # of zeroes }
 end;

procedure idxsave( var f : file; index : longint; var v; size : word );
 var
  idxpos : longint;
 begin
  idxpos := filepos( f );
  seek( f, 10 + ( succ( index ) * sizeof( longint ) ) );
  savelongint( f, idxpos );
  seek( f, idxpos );
  savevar( f, v, size );
 end;

procedure idxload( var f : file; index : longint; var v );
 var
  idxpos : longint;
 begin
  seek( f, 10 + ( succ( index ) * sizeof( longint ) ) );
  idxpos := nextlongint( f );
  seek( f, idxpos );
  nextvar( f, v );
 end;

function idxcount( var f : file ) : longint;
 begin
  seek( f, 10 );
  idxcount := nextlongint( f );
 end;

type
 animal = record
  str : string;
  yes, no : word;
 end;

const
 maxanimals = 500;

var
 animalcount,
 current : word;
 input : zinput;
 f : file;
 newyes, newno, newquestion : string;
 answer : char;
 saveanimal,
 someanimal : animal;

procedure save( s, y, n : string );
 begin
  if animalcount + 2 > maxanimals then
   begin
    writeln( #13'Too many animals... Aborting...');
    halt;
   end;
  assign( f, 'Animals.Dat');
  reset( f, 1 );
  seek( f, filesize( f ));
  saveanimal.str := s;
  saveanimal.yes := animalcount + 1;
  saveanimal.no := animalcount + 2;
  idxsave( f, current, saveanimal, sizeof( saveanimal ) );
  saveanimal.str := '!'+y;
  saveanimal.yes := 0;
  saveanimal.no := 0;
  idxsave( f, animalcount + 1, saveanimal, sizeof( saveanimal ) );
  saveanimal.str := '!'+n;
  saveanimal.yes := 0;
  saveanimal.no := 0;
  idxsave( f, animalcount + 2, saveanimal, sizeof( saveanimal ) );
  animalcount := animalcount + 2;
  idxsave( f, 0, animalcount, sizeof( animalcount ));
  close( f );
 end;

begin
 cwriteln('|B|#Ä10|_|W Animals|b!|_|B|#Ä10');
 current := 1; animalcount := 1;
 {$I-} filereset( f, 'animals.dat' ); close( f ); {$I+}
 if not (ioresult = 0) then
  begin
   assign( f, 'animals.dat'); rewrite( f, 1 );
   idxinit( f, 'Animals', maxanimals );
   close( f );
   save( 'Does it have legs?', 'dog', 'snake' );
  end;
 assign( f, 'animals.dat' ); reset( f, 1 );
 idxload( f, 0, animalcount );
 repeat
  idxload( f, current, someanimal );
  if someanimal.str[1] = '!' then
   begin
    delete( someanimal.str, 1, 1 );
    cwriteln( '|YIs it |W'+someanimal.str+'|Y?' );
    repeat answer := upcase( readkey ) until answer in ['Y','N','Q'];
    case answer of
     'Y' : begin
            cwriteln('|CI got it! Yay!');
            answer := 'Q';
           end;
     'N' : begin
            cwriteln('|COh. Well what is it, then?');
            repeat
             input.default( 1, typos, 50, 50, '' );
             newyes := input.get;
             newno := newyes;
             cwriteln(#13'|W'+newyes+'|C, you say?');
             repeat answer := upcase( readkey ) until answer in ['Y','N'];
            until answer = 'Y';
            cwriteln('|CWell, what''s a good yes/no question to distinguish'+
             ' |W'+newyes+'|C from |W'+someanimal.str+'|C?');
            repeat
             input.default( 1, typos, 50, 50, '' );
             newquestion := input.get;
             cwriteln(#13'|CDid you type that in right?');
             repeat answer := upcase( readkey ) until answer in ['Y','N'];
            until answer = 'Y';
            cwriteln('|CAnd what''s the answer for |W'+newyes+'|C?');
            repeat answer := upcase( readkey ) until answer in ['Y','N'];
            if answer = 'Y' then newno := someanimal.str
             else newyes := someanimal.str;
            save( newquestion, newyes, newno );
            cwriteln('|CI know about |W'+n2s(animalcount-1)+'|C animals now!');
            answer := 'Q';
           end;
    end; { case answer }
   end
  else
   begin
    cwriteln( '|M'+someanimal.str );
    repeat answer := upcase( readkey ) until answer in ['Y','N','Q'];
    if answer = 'Y' then current := someanimal.yes
     else current := someanimal.no;
   end;
 until answer = 'Q';
 cwriteln('|GDone.');
 doscursoron;
end.