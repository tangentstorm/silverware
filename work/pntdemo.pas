program pntdemo; { pointer demo for PntStuff }
uses pntstuff, crtstuff, crt;

type
 pstringobj = ^stringobj;
 stringobj = object ( node )
  s : string;
  constructor init( st : string );
 end;

 constructor stringobj.init( st : string );
  begin
   s := st;
  end;

{$F+}
 procedure prints( n : pnode );
  begin
   cwriteln( pstringobj(n)^.s );
  end;
{$F-}

var
 strlist : list;
 p : pstringobj;
begin
 setupcrt;
 strlist.init;
 strlist.append( new( pstringobj, init( 'One' ) ) );
 p := new( pstringobj, init( 'Two' ) );
 strlist.append( p );
 strlist.append( new( pstringobj, init( 'Three' ) ) );
 strlist.insert( new( pstringobj, init( '|K|#─10|W' ) ) );
 strlist.foreachdo( prints );
 p := pstringobj( strlist.first );
 if p^.prev = nil then write( 'nil!' ) else write ( p^.s );
end.

 with strlist do
  begin
   p := pstringobj( first );
   repeat
   repeat
   delay( 50 );
    prints( p );
    p := pstringobj( p^.next );
   until enterpressed;
   repeat
   delay( 50 );
    prints( p );
    p := pstringobj( p^.prev );
   until enterpressed;
   until false
  end;
 doscursoron;
end.