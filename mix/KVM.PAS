{
  This is basically a module to ease porting between
  turbo, gnu, and free pascal.
}
unit kvm;
interface

 function readkey: char;
 function keypressed : boolean;
 procedure gotoxy( x, y : byte );
 procedure delay( ms : integer );

implementation
{$IFDEF FPC}
uses crt;d
{$ELSE}
uses crt, crtstuff;
{$ENDIF}

 function readkey : char;
 begin
   readkey := crt.readkey;
 end;

 function keypressed : boolean;
 begin
   keypressed := crt.keypressed;
 end;

 procedure gotoxy( x, y : byte );
 begin
   crt.gotoxy( x, y );
 end;

 procedure delay( ms : integer );
 begin
   crt.delay( ms );
 end;


end.