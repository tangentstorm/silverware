{$i xpc}
unit ll; { linked list support }
interface uses xpc;

type
  base	     = class
    constructor init; virtual;
  end;

  pnode	     = ^node;
  node	     = class( base )
    next, prev : pnode;
  end;
  listaction = procedure( var n : node );

  {$ifdef FPC}
  predicate	     = function( n : pNode ) : boolean is nested;
  {$else}
  predicate	     = function( n : pNode ) : Boolean;
  {$endif}

  plist	     = ^list;
  list	     = class( base )
   private
    mLast, mFirst : pnode;
   public constructor init; override;
    procedure append( n : pnode );
    procedure insert( n : pnode );
    procedure remove( n : pnode );
    procedure foreach( what : listaction );
    function find( pred : predicate ) : pnode;
    function is_empty: boolean;
    function first : pnode;
    function last : pNode;
    function next( const n : pnode ) : pnode; deprecated;
    function prev( const n : pnode ) : pnode; deprecated;

    { -- old interface --}
    function empty: boolean; deprecated;
    procedure foreachdo( what : listaction ); deprecated;
    //  procedure killall; deprecated;
  end;

  var NullNode : pNode;

implementation

  { empty base class }
  constructor base.init;
  begin
  end;

  constructor list.init;
  begin
    mLast := nil;
  end;

  function List.find( pred : Predicate ) : pNode;
  begin
    if not self.is_empty then
    begin
      result := self.mFirst;
      repeat result := result^.Next;
      until pred( result ) or ( result = nil )
    end
    else result := nil
  end; { find }


  procedure List.insert(n: pNode);
    { be sure to change zmenu.add IF you change this!!! }
  begin
    if mFirst = nil then
    begin
      mLast := n;
      mFirst := n;
    end
    else
    begin
      n^.next := mFirst;
      mFirst := n;
      n^.prev := mFirst;
    end;
  end; { insert }


  procedure list.foreachdo( what : listaction ); inline; deprecated;
  begin foreach( what )
  end;

  procedure list.append( n: pNode );
  begin
    self.insert( n );
    mLast := n;
  end; { append }

  procedure list.foreach( what : listaction );
    var p, q : pnode;
  begin
    p := first;
    while p <> nil do
    begin
      q := p;
      p := p^.next;
      what( q^ );
    end;
  end;


  procedure List.remove(n: pNode);
    var
      p: pNode;
  begin
    if last <> nil then
    begin
      p := first;
      while (p^.next <> n) and (p^.next <> last) do
	p := p^.next;
      if p^.next = n then
      begin
	p^.next := n^.next;
	if last = n then
	begin
	  if p = n then
	    mLast := nil
	  else
	    mLast := p;
	end;
      end;
    end;
  end; { remove }

  function list.empty : boolean; inline; deprecated;
  begin result := self.is_empty;
  end;
  function list.is_empty : boolean;
  begin result := mLast = nil;
  end;

  function list.first: pnode;
  begin
    result := mFirst;
  end; { first }

  function list.last: pNode;
  begin
    result := mLast;
  end; { last }


  { i don't really see the point of these }
  function list.next( const n: pnode ): pnode; inline; deprecated;
  begin result := n^.next;
  end;


  function list.prev( const n: pNode): pNode; inline; deprecated;
  begin result := n^.prev;
  end;


begin
  nullnode := new( pnode, create );
end. { unit }
