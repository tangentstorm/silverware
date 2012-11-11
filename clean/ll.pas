{$i xpc}
unit ll; { linked list }
interface uses xpc;

type
  base	     = class
    constructor new; virtual;
  end;

  pnode	     = ^node;
  node	     = class( base )
    next, prev : pnode;
  end;
  listaction = procedure( var n : node );

  plist	     = ^list;
  list	     = class( base )
    last : pnode;
    constructor new; override;
    procedure append( const n : node );
    procedure insert( const n : node );
    procedure remove( const n : node );
    procedure foreachdo( what : listaction ); deprecated;
    procedure foreach( what : listaction );
    function empty : boolean;
    function first : pnode;
    function next( const n : pnode ) : pnode;
    function prev( const n : pnode ) : pnode;
  end;

implementation

  { empty base class }
  constructor base.new;
  begin
  end;

  constructor list.new;
  begin
    last := nil;
  end;

  procedure list.append( const n : node );
  begin
    insert( n );
    last := @n;
  end;

  procedure list.insert( const n : node ); { be sure to change zmenu.add }
  begin                              { if you change this!!! }
    if last = nil then last := @n
    else n.next := last^.next;
    first^.prev := @n;
    last^.next := @n;
    n.prev := last;
  end;


  procedure list.foreachdo( what : listaction ); inline; deprecated;
  begin foreach( what )
  end;

  procedure list.foreach( what : listaction );
    var p, q : pnode;
  begin
    p := first;
    while p <> nil do
    begin
      q := p;
      p := next( p );
      what( q^ );
    end;
  end;

  procedure list.remove( const n : node );
    var p : pnode;
  begin
    if last <> nil then
    begin
      p := first;
      while (p^.next <> @n) and (p^.next <> @last) do p := p^.next;
      if p^.next = @n then
      begin
	p^.next := n.next;
	if last = @n then if p = @n then last := nil else last := @p;
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

  function list.next( const n : pnode ) : pnode;
  begin
    if n = last then next := nil else next := n^.next;
  end;

  function list.prev( const n : pnode ) : pnode;
  begin
    if n = first then prev := nil else prev := n^.prev;
  end;

end.
