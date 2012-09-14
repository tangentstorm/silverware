program animals;

uses crt, crtstuff, filstuff, zokstuff;

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
 f : file;
 newyes, newno, newquestion : string;
 answer : char;
 saveanimal,
 someanimal : animal;
 input : zinput;

procedure save( s, y, n : string );
 begin
  if animalcount + 2 > maxanimals then
   begin
    cwriteln( #13'|!K|RToo many animals... Aborting...');
    halt;
   end;
  filereset( f, 'Animals.Dat');
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
 cwriteln(#13#13'|!k|B|#Ä10'#13'|WAnimals|C!'#13'|B|#Ä10');
 current := 1;
 animalcount := 1;
 if not fileexists('Animals.Dat') then
  begin
   filerewrite( f, 'Animals.Dat');
   idxinit( f, 'Animals', maxanimals );
   close( f );
   save( 'Does it have legs?', 'dog', 'snake' );
  end;
 filereset( f, 'animals.dat');
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