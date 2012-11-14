{ Doth MapMaker (c) 1992 }
{ by S┼εΓL│NG S│LVεΓWΩΓε }

program DMM;
Uses Crt,CrtStuff,SSWStuff;

{$I THARRAY.PAS}
{$I DMMTTL.PIC }

type
 AMap  =  Array[ 0..71, 0..21 ] of Things; { 70x20, with border }

var
 cx, cy,                          { cursor coordinates }
 mx, my, mz : byte;               { map coordinates }
 Map : AMap;

function Confirm( m1, m2 : string ) : boolean;
 begin
 end;

procedure Load;
 begin
 end;

procedure Save;
 begin
 end;

procedure Zap( cnfrm : boolean );
 begin
  if cnfrm then
   if not Confirm('This will erase the entire screen!','Go ahead??') then
    exit;

 end;

procedure New;
 begin
  If Confirm('This will Erase ALL your Data!!!','Proceed Anyway?!?!') then
   begin
   end;
 end;

procedure init;
 begin
  setupcrt;
  slidescreenoff( screentype( DMMTtl ) );
  Get_Enter;
 end;

procedure closeup;
 begin
  Cls(1);
  clrscr;
  restcursor;
 end;

begin
 init;
 closeup;
end.