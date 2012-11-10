{$WARNING pntstuff is deprecated. please use ../clean/ll.pas instead }
{$WAIT}
Unit PntStuff;
{$S-}

interface

type
 base = object
  destructor done; virtual;
 end;
 pnode = ^node;
 node = object( base )
  next, prev : pnode;
 end;
 ListAction = Procedure( N : pnode );

 plist = ^List;
 List = object( Base )
  last : pnode;
  constructor init;
  procedure append( n : pnode );
  procedure insert( n : pnode );
  procedure remove( n : pnode );
  procedure foreachdo( what : listaction );
  procedure killall;
  function empty : boolean;
  function first : pnode;
  function next( n : pnode ) : pnode;
  function prev( n : pnode ) : pnode;
  destructor done; virtual;
 end;

implementation

 destructor base.done;
  begin
  end;

 {$F+}
  procedure killnode( n : pnode );
   begin
    dispose( n, done );
   end;
 {$F-}

 constructor list.init;
  begin
   last := nil;
  end;

 procedure list.append( n : pnode );
  begin
   insert( n );
   last := n;
  end;

 procedure list.insert( n : pnode ); { be sure to change zmenu.add }
  begin                              { if you change this!!! }
   if last = nil then last := n else n^.next := last^.next;
   first^.prev := n;
   last^.next := n;
   n^.prev := last;
  end;

 procedure list.killall;
  begin
   foreachdo( @killnode );
   last := nil;
  end;

 procedure list.foreachdo( what : listaction );
  var
   p, q : pnode;
  begin
   p := first;
   while p <> nil do
    begin
     q := p;
     p := next( p );
     what( q );
    end;
   end;

 procedure list.remove( n: pnode );
  var
   p : pnode;
  begin
   if last <> nil then
    begin
     p := first;
     while (p^.next <> n) and (p^.next <> last) do p := p^.next;
     if p^.next = n then
      begin
       p^.next := n^.next;
       if last = n then if p = n then last := nil else last := p;
      end;
    end;
  end;

 function list.empty : boolean;
  begin
   empty := last = nil;
  end;

 function list.first : pnode;
  begin
   if last = nil then first := nil else first := last^.next;
  end;

 function list.next( n : pnode ) : pnode;
  begin
   if n = last then next := nil else next := n^.next;
  end;

 function list.prev( n : pnode ) : pnode;
  begin
   if n = first then prev := nil else prev := n^.prev;
  end;

 destructor list.done;
  begin
   killall;
  end;

end.