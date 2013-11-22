{$mode objfpc}{$H-}
program animals;
uses fs,stri,ui,kbd,cw,kvm,num,cli,cx;

type
 animal = packed record
  str : string;
  yes, no : word;
 end;

pconst
 maxanimals = 500;

var
 animalcount                : word = 1;
 current                    : word = 1;
 input                      : zinput;
 f                          : file;
 newyes, newno, newquestion : string;
 answer                     : char;
 saveanimal,
 someanimal                 : animal;

const
  kpath = 'animals.dat';

procedure save( s, y, n : string );
  begin
    if animalcount + 2 > maxanimals then
      begin
        writeln( #13'Too many animals... Aborting...');
        halt;
      end;
    fs.update( f, kpath );
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
  input := zinput.create(nil);
  cwriteln('|B|#-10|_|W Animals|b!|_|B|#-10');
  fs.review( f, kpath );
  if fs.error <> 0 then
    begin
      fs.create( f, kpath );
      idxinit( f, 'Animals', maxanimals );
      close( f );
      save( 'Does it have legs?', 'dog', 'snake' );
    end;
  fs.review( f, kpath );
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
                    input.default( 0, kvm.wherey, 50, 50, '' );
                    newyes := input.get;
                    newno := newyes;
                    cwriteln('');
                    cwriteln(#13'|W'+newyes+'|C, you say?');
                    repeat answer := upcase( readkey ) until answer in ['Y','N'];
                  until answer = 'Y';
                  cwriteln('|CWell, what''s a good yes/no question to distinguish'+
                           ' |W'+newyes+'|C from |W'+someanimal.str+'|C?');
                  repeat
                    input.default( 0, kvm.wherey, 50, 50, '' );
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
        cwriteln( '|M' + someanimal.str );
        stwrite('[Y,N,Q]?');
        repeat answer := upcase( readkey ) until answer in ['Y','N','Q',^C];
        gotoxy(0,kvm.wherey);clreol;
        if answer = 'Y' then current := someanimal.yes
        else current := someanimal.no;
      end;
  until answer in [^C,'Q'];
  cwriteln('|GDone.');
  kvm.showcursor;
  input.free;
end.
