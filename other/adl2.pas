uses Dos, vuestuff, crtstuff, pntstuff;

var
 hlist : listviewer;

type
 adlobj = object  {advanced directory lister}
  files : plist;
  constructor init;
  procedure initlist; virtual;
  precedure getfiles; virtual;
  procedure show; virtual;
  destructor done;
 end;
 admobj = object (adlobj) {advanced directory magic}
  procedure makelist; virtual;
 end;
 strcols = record
  nb, nf, eb, ef : char;
  s : string;
 end;

const
 hid = -3;
 dir = -2;
 vol = -1;
 pal : array [ hid .. 10 ] of strcols =
 (
  ( nb: 'k'; nf: 'b'; eb: 'k'; ef: 'b' ),
  ( nb: 'k'; nf: 'B'; eb: 'k'; ef: 'B' ),
  ( nb: 'k'; nf: 'K'; eb: 'k'; ef: 'K' ),
  ( nb: 'k'; nf: 'W'; eb: 'k'; ef: 'w' ),
  ( nb: 'k'; nf: 'C'; eb: 'k'; ef: 'c'; s: 'bas/pas/asm/inc/c/h/cpp/lsp' ),
  ( nb: 'k'; nf: 'R'; eb: 'k'; ef: 'r'; s: 'gif/jpg/gl/fli/pic/bmp/tga/pcx'),
  ( nb: 'k'; nf: 'Y'; eb: 'k'; ef: 'y'; s: 'exe/com'),
  ( nb: 'k'; nf: 'G'; eb: 'k'; ef: 'g'; s: 'bat'),
  ( nb: 'k'; nf: 'M'; eb: 'k'; ef: 'm'; s: 'zip/arc/lzh/pak/zoo/arj/gz '),
  ( nb: 'k'; nf: 'r'; eb: 'k'; ef: 'K'; s: 'rep/qwk'),
  ( nb: 'k'; nf: 'w'; eb: 'k'; ef: 'K'; s: 'bak/bk!/old/tmp/$$$' ),
  ( nb: 'k'; nf: 'K'; eb: 'k'; ef: 'K' ),
  ( nb: 'k'; nf: 'K'; eb: 'k'; ef: 'K' ),
  ( nb: 'k'; nf: 'K'; eb: 'k'; ef: 'K' )
 );


procedure findfiles;
 var
  DirInfo: SearchRec;
  i, found : byte;
  d : dirstr;
  n : namestr;
  e : extstr;
  ss : string;
 begin
   FindFirst('*.*', archive, DirInfo);
   while DosError = 0 do
   begin
    FSplit( dnstr(normaltext(DirInfo.Name)), d, n, e ); Delete( E, 1, 1 );
    found := 0;
    for i := 1 to 10 do
     if pos( padstr( e, 3, '*' ), pal[i].s ) <> 0 then found := i;
    with pal[found] do
     ss := '|!' + nb + '|' + nf +  padstr( n, 9, ' ') +
          '|!' + eb + '|' + ef + flushrt( e, 3, ' ');
    list.append( new( pstringobj, init( ss )));
    FindNext(DirInfo);
   end;
 end;


begin
 setupcrt;
 list.init;
 list.x1 := 50;
 list.y2 := 11;
 init;
 findfiles;
 list.view;
 doscursoron;
end.


