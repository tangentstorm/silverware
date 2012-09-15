Program Mtest3;
uses crt, crtstuff, vgastuff, moustuff;


const
 c0 = 55;
 c1 = 0;   { black }
 c2 = 15;  { white }
 c3 = 55;  { clear }
 c4 = 40;  { invrt }
 c5 = 70;  { hspot }
 cc : byte = c2; { current }
 quit : boolean = false;
 filename : string[ 8 ] = 'NONAME';
 curs : gcursor = ( screenmask: ($FFFF, $FFFF, $FFFF, $FFFF,
                                 $FFFF, $FFFF, $FFFF, $FFFF,
                                 $FFFF, $FFFF, $FFFF, $FFFF,
                                 $FFFF, $FFFF, $FFFF, $FFFF);
                    cursormask: ($0000, $0000, $0000, $0000,
                                 $0000, $0000, $0000, $0000,
                                 $0000, $0000, $0000, $0000,
                                 $0000, $0000, $0000, $0000);
                    hotx: 0; hoty : 0 );
 var
  back : gcursor;

procedure drawcursor;
 var
  x, y : integer;
 begin
  showmouse( off );
  for y := 0 to 15 do
   for x := 0 to 15 do
    begin
     if not (( x = curs.hotx ) and ( y = curs.hoty )) then
      rectangle( 80 + x * 8, 20 + y * 8, 86 + x * 8, 26 + y * 8, c0 )
     else
      rectangle( 80 + x * 8, 20 + y * 8, 86 + x * 8, 26 + y * 8, c5 );
     if
      curs.screenmask[ y ] AND power( 2, 15-x ) <> 0
     then
      if
       curs.cursormask[ y ] AND power( 2, 15-x ) <> 0
      then
       box( 81 + x * 8, 21 + y * 8, 85 + x * 8, 25 + y * 8, c4 )
      else
       box( 81 + x * 8, 21 + y * 8, 85 + x * 8, 25 + y * 8, c3 )
     else
      if
       curs.cursormask[ y ] AND power( 2, 15-x ) <> 0
      then
       box( 81 + x * 8, 21 + y * 8, 85 + x * 8, 25 + y * 8, c2 )
      else
       box( 81 + x * 8, 21 + y * 8, 85 + x * 8, 25 + y * 8, c1 )
    end;
   showmouse( on );
 end;

procedure save;
 var
  t : text;
 begin
  assign( t, filename + '.CUR' );
  rewrite( t );
  writeln( t, 'const' );
  writeln( t, ' '+filename+' : GCursor =' );
  writeln( t, '  ( ScreenMask : ( ',
   h2s( curs.screenmask[ 0 ] ), ', ',   h2s( curs.screenmask[ 1 ] ), ', ',
   h2s( curs.screenmask[ 2 ] ), ', ',   h2s( curs.screenmask[ 3 ] ), ',');
  writeln( t,
   h2s( curs.screenmask[ 4 ] ), ', ',   h2s( curs.screenmask[ 5 ] ), ', ',
   h2s( curs.screenmask[ 6 ] ), ', ',   h2s( curs.screenmask[ 7 ] ), ',');
  writeln( t,
   h2s( curs.screenmask[ 8 ] ), ', ',   h2s( curs.screenmask[ 9 ] ), ', ',
   h2s( curs.screenmask[ 10 ] ), ', ',   h2s( curs.screenmask[ 11 ] ), ',');
  writeln( t,
   h2s( curs.screenmask[ 12 ] ), ', ',   h2s( curs.screenmask[ 13 ] ), ', ',
   h2s( curs.screenmask[ 14 ] ), ', ',   h2s( curs.screenmask[ 15 ] ), ');');
  writeln( t, '    CursorMask : ( ',
   h2s( curs.cursormask[ 0 ] ), ', ',    h2s( curs.cursormask[ 1 ] ), ', ',
   h2s( curs.cursormask[ 2 ] ), ', ',    h2s( curs.cursormask[ 3 ] ), ',');
  writeln( t,
   h2s( curs.cursormask[ 4 ] ), ', ',    h2s( curs.cursormask[ 5 ] ), ', ',
   h2s( curs.cursormask[ 6 ] ), ', ',    h2s( curs.cursormask[ 7 ] ), ',');
  writeln( t,
   h2s( curs.cursormask[ 8 ] ), ', ',    h2s( curs.cursormask[ 9 ] ), ', ',
   h2s( curs.cursormask[ 10 ] ), ', ',   h2s( curs.cursormask[ 11 ] ), ',');
  writeln( t,
   h2s( curs.cursormask[ 12 ] ), ', ',   h2s( curs.cursormask[ 13 ] ), ', ',
   h2s( curs.cursormask[ 14 ] ), ', ',   h2s( curs.cursormask[ 15 ] ), ');');
  writeln( t, '    hotx : ', h2s( curs.hotx ), ';');
  writeln( t, '    hoty : ', h2s( curs.hoty ), ');');
  close( t );
 end;

procedure load;
 var
  t : text;
  i, j, k : integer;
  ch : char;
  worktext : string;
  done : boolean;
  tempval : word;
 begin
  assign( t, filename + '.CUR' );
  {$I-} reset( t ); {$I+}
  if IOResult <> 0 then begin sound( 50 ); delay( 50); nosound; exit; end;
  i := 0;
  repeat
   readln( t, worktext );
   for j := 1 to 4 do
    if Pos( '$', worktext ) > 0 then
     begin
      while worktext[ 1 ] <> '$' do delete( worktext, 1, 1 );
      tempval := s2h ( copy( worktext, 1, 5 ) );
      delete( worktext, 1, 1 );
      case i of
        0 .. 15 : curs.screenmask[ i ] := tempval;
       16 .. 31 : curs.cursormask[ i - 16 ] := tempval;
             32 : curs.hotx := tempval;
             33 : curs.hoty := tempval;
      end; { case }
      i := i + 1;
     end; { for }
  until i > 33;
  close( t );
  drawcursor;
 end;

procedure editpicture( x, y : integer );
 begin
  x := (x - 80) div 8;
  y := (y - 20) div 8;
  showmouse( off );
  case cc of
   c1 : begin
         curs.screenmask[ y ] := curs.screenmask[ y ] and not power( 2, 15-x );
         curs.cursormask[ y ] := curs.cursormask[ y ] and not power( 2, 15-x );
         box( 81 + x * 8, 21 + 8 * y, 85 + x * 8, 25 + 8 * y, c1 );
        end;
   c2 : begin
         curs.screenmask[ y ] := curs.screenmask[ y ] and not power( 2, 15-x );
         curs.cursormask[ y ] := curs.cursormask[ y ] or power( 2, 15-x );
         box( 81 + x * 8, 21 + 8 * y, 85 + x * 8, 25 + 8 * y, c2 );
        end;
   c3 : begin
         curs.screenmask[ y ] := curs.screenmask[ y ] or power( 2, 15-x );
         curs.cursormask[ y ] := curs.cursormask[ y ] and not power( 2, 15-x );
         box( 81 + x * 8, 21 + 8 * y, 85 + x * 8, 25 + 8 * y, c3 );
        end;
   c4 : begin
         curs.screenmask[ y ] := curs.screenmask[ y ] or power( 2, 15-x );
         curs.cursormask[ y ] := curs.cursormask[ y ] or power( 2, 15-x );
         box( 81 + x * 8, 21 + 8 * y, 85 + x * 8, 25 + 8 * y, c4 );
        end;
   c5 : begin curs.hotx := x; curs.hoty := y; drawcursor; end;
  end;
  showmouse( on );
 end;

procedure toolbox( y : integer );
 begin
  case y of
     5.. 15 : setgcurs( curs ); { use }
    17.. 27 : save; { save }
    29.. 39 : load; { load }
    41.. 51 : quit := true; { exit }
    53.. 63 : begin
               curs := back;
               drawcursor;
              end;
    65.. 73 : cc := c1; { black }
    75.. 83 : cc := c2; { white }
    85.. 93 : cc := c3; { clear }
    95..103 : cc := c4; { invrt }
   105..113 : cc := c5; { hspot }
  end;
 end;

procedure getfilename;
 begin
  showmouse( false );
  box( 60, 165, 243, 178, c1 );
  rectangle( 60, 165, 243, 178, c0 );
  gotoxy( 9, 22 );
  textattr := $0F;
  write( 'Filename: ');
  readln( filename );
  showmouse( true );
 end;

procedure drawfilebox;
 begin
  showmouse( false );
  bar( 60, 165, 243, 178, c1 );
  rectangle( 60, 165, 243, 178, c0 );
  directvideo := false;
  gotoxy( 9, 22 );
  textattr := $0F;
  write( 'Filename: ' + flushrt( Upstr( filename), 8, ' ') + '.CUR' );
  showmouse( true );
 end;

procedure drawscreen;
 begin
  rectangle( 10,  5, 20, 15, c0 ); { use }
   drawline( 12,  7, 12, 13, 7 );
   drawline( 12, 13, 18, 13, 7 );
   drawline( 18,  7, 18, 13, 7 );
  rectangle( 10, 17, 20, 27, c0 ); { save }
   drawline( 12, 19, 18, 19, 7 );
   drawline( 12, 19, 12, 22, 7 );
   drawline( 12, 22, 18, 22, 7 );
   drawline( 18, 22, 18, 25, 7 );
   drawline( 12, 25, 18, 25, 7 );
  rectangle( 10, 29, 20, 39, c0 ); { load }
   drawline( 12, 31, 12, 37, 7 );
   drawline( 12, 37, 18, 37, 7 );
  rectangle( 10, 41, 20, 51, c0 ); { exit }
   drawline( 12, 43, 18, 49, 7 );
   drawline( 18, 43, 12, 49, 7 );
  rectangle( 10, 53, 20, 63, c0 );  { clear box }
   drawline( 12, 55, 18, 55, 7 );
   drawline( 12, 55, 12, 61, 7 );
   drawline( 12, 61, 18, 61, 7 );
  box( 10, 65, 20, 73, c1 );            { color things }
  box( 10, 75, 20, 83, c2 );
  box( 10, 85, 20, 93, c3 );
  box( 10, 95, 20, 103, c4 );
   rectangle( 10, 65, 20, 73, c0 );
   rectangle( 10, 75, 20, 83, c0 );
   rectangle( 10, 85, 20, 93, c0 );
   rectangle( 10, 95, 20, 103, c0 );
   rectangle( 10, 105, 20, 113, c5 );
  drawcursor;
  drawfilebox;
 end;

var
 ox, oy : integer;
begin
 clrscr;
 back := curs;
 ox := -1;
 oy := -1;
 if not mousethere then begin writeln('No Mousie, Mon.'); halt( 1 ); end;
 setmode( $13 );
 setmwin( 0, 0, 639, 199 );
 setmpos( 320, 100 );
 drawscreen;
 mouseon;
 repeat
  getmpos;
  mx := mx div 2;
  if
   ms and $02 <> 0
  then
   begin
    repeat getmpos until ms and $02 = 0;
    mouseon;
   end
  else
   if
    ms and $01 <> 0
   then
    if
     mx in [10..20]
    then
     begin
      toolbox( my );
     end
    else
     if
      (mx in [80..205]) and ( my in [20..145] )
     then
      begin
       if (ox <> mx) OR (oy <> my) then editpicture( mx, my );
       ox := mx;
       oy := my;
      end
    else
     if
      (mx in [ 60 .. 243 ]) and ( my in [165..178] )
     then
      begin
       getfilename;
       drawfilebox;
      end;
 until quit or (keypressed and ( readkey = #27 ));
end.