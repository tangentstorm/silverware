program zmenubartest;
uses crt, crtstuff,zokstuff,moustuff;


var
 z : zmenubar;
 o,t,thr : zbouncemenu;

begin
 textattr := $0F;
 mouseon;
 clrscr;
 z.init( on );
 z.add( 1, 1, '|!k|ROne ', '|!r|koNE ', on, 'O', 1 );
 z.add( 5, 1, '|!k|RTwo ', '|!r|ktWO ', on, 'T', 2 );
 z.add( 9, 1, '|!k|RThree ', '|!r|ktHREE ', on, 'H', 3 );
 o.init( 1, 2, 21, '', true,
    newline( ' |)|WE|(dit            ... ', '', true, 'E', 1,
    newline( ' |)|WO|(pen            <ды ', '', true, 'O', 2,
    newline( ' |)|WC|(opy       Ctrl-Ins ', '', true, 'C', 3,
    newline( ' |)|WD|(elete     Ctrl-Del ', '', true, 'D', 4,
    newline( ' |)|WM|(ove      Shift-Del ', '', true, 'M', 5,
    newbar(
    newline( ' |)|WR|(un             ... ', '', true, 'R', 6,
    newbar(
    newline( ' E|)|Wx|(it to DOS   Alt-X ', '', true, 'X', 7,
   nil ))))))))));
 t.init( 5, 2, 21, '', true,
    newline( ' |)|WE|(dit            ... ', '', true, 'E', 1,
    newline( ' |)|WO|(pen            <ды ', '', true, 'O', 2,
    newbar(
    newline( ' |)|WR|(un             ... ', '', true, 'R', 6,
    newbar(
    newline( ' E|)|Wx|(it to DOS   Alt-X ', '', true, 'X', 7,
   nil )))))));
 z.addsub( 'O', @o );
 z.addsub( 'T', @t );
 write( z.get );
end.