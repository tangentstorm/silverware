unit moustuff;

interface

 type
  GCursor = record
    screenmask,
    cursormask : array [ 0..15 ] of word;
    hotx, hoty : integer;
  end;

 var
  mvisible : boolean;
  mpresent : boolean;
  mstatus  : boolean;
  nb : integer;
  ms, lms,   { mouse status, last mouse status }
  mx, lmx,   { the others are for x,y in characters }
  my, lmy  : integer;

 function mousethere : boolean;
 procedure resetmouse( var status : boolean; var numbtns : integer );
 procedure showmouse( yn : boolean );
 procedure mouseon;
 procedure getmpos; { poll() basically. }
 procedure gettextmpos;
 procedure setmpos( a, b : integer );

 procedure setmwin( a1, b1, a2, b2 : integer );
 function mousemoved : boolean;

 {$IFNDEF FPC}
 { freepascal mouse doesn't do graphics }
 procedure setgcurs( gcurs : gcursor );


 { the os handles mouse accelleration now}
 procedure setmaccel( t : integer );
 {$ENDIF}


implementation

{$IFDEF FPC}
uses mouse;

 function mousethere : boolean;
 begin
  mousethere := mouse.detectmouse > 0;
 end;

 procedure resetmouse( var status : boolean; var numbtns : integer );
 begin
  numbtns := mouse.detectmouse;
  status  := numbtns > 0;
 end;

 procedure showmouse( yn : boolean );
 begin
  mvisible := yn;
  if mvisible then mouse.showmouse else mouse.hidemouse;
 end;

 procedure mouseon;
 begin
  showmouse( true );
 end;

 procedure getmpos;
 begin
  gettextmpos;
 end;

 procedure gettextmpos;
 begin
   lms := ms;
   lmx := mx;
   lmy := my;
   mx := mouse.GetMouseX;
   my := mouse.GetMouseY;
   ms := mouse.GetMouseButtons;
 end;

 procedure setmpos( a, b : integer );
 begin
   mouse.setmouseXY( a, b );
 end;

 procedure setmwin( a1, b1, a2, b2 : integer );
 begin
   writeln( 'setmwin called to trap the mouse. why? :)' );
 end;

{$else} { old dos version }

uses dos,crtstuff;
 var
  regs : registers;

 function mousethere : boolean;
  var
   dOff, dSeg : integer;
  begin
   mousethere := false;
   dOff := MemW[ 0000:0204 ];
   dSeg := MemW[ 0000:0206 ];
   if
    (( dSeg = 0 ) or ( dOff = 0 ))
   then
    mousethere := false
   else
    mousethere := mem[ dSeg:dOff ] <> 207;
  end;

 procedure resetmouse( var status : boolean; var numbtns : integer );
  begin
   regs.ax := $00;
   intr( $33, regs );
   status := regs.ax <> 0;
   numbtns := regs.bx;
  end;

 procedure showmouse( yn : boolean );
  begin
   if not mpresent then exit;
   if
    yn and not mvisible
   then
    begin
     regs.ax := $01;
     mvisible := true;
     intr( $33, Regs );
    end
   else
    if
     mvisible and not yn
    then
     begin
      regs.ax := $02;
      mvisible := false;
      intr( $33, regs );
     end
 end;

 procedure mouseon;
  begin
   mvisible := false;
   mpresent := mousethere;
   if mpresent then
    begin
     resetmouse( mstatus, nb );
     showmouse( true );
     getmpos; getmpos; { initializes mx, my, lmx, lmy }
    end;
  end;

 procedure getmpos;
  begin
   if not mpresent then exit;
   lms := ms;
   lmx := mx;
   lmy := my;
   regs.ax := $03;
   intr( $33, regs );

   ms := Regs.bx;
   mx := regs.cx;
   my := regs.dx;
 end;

 procedure gettextmpos;
  begin
   getmpos;
   mx := mx div 8 +1;
   my := my div 8 +1;
  end;

 procedure setmpos( a, b : integer );
  begin
   if not mpresent then exit;
   regs.ax := $04;
   regs.cx := a;
   regs.dx := b;
   intr( $33, regs );
   mx := a;
   my := b;
  end;

 procedure setmwin( a1, b1, a2, b2 : integer );
  begin
   if not mpresent then exit;
   regs.ax := $07;
   regs.cx := min( a1, a2 );
   regs.dx := max( a1, a2 );
   intr( $33, regs );
   regs.ax := $08;
   regs.cx := min( b1, b2 );
   regs.dx := max( b1, b2 );
   intr( $33, regs );
  end;

 procedure setgcurs( gcurs : gcursor );
  var
   o, s : word;
  begin
   if not mpresent then exit;
   o := ofs( gcurs.screenmask );
   s := seg( gcurs.screenmask );
   asm
    mov ax, $09
    mov bx, gcurs.hotx
    mov cx, gcurs.hoty
    mov dx, o
    mov es, s
    int 33h
   end
  end;

 procedure setmaccel( t : integer );
  begin
   if not mpresent then exit;
   asm
    mov ax, 13h
    mov dx, t
    int 33h
   end;
  end;

{$ENDIF}

 function mousemoved : boolean;
  begin
   mousemoved := ( lmx <> mx ) or ( lmy <> my );
  end;

begin
 mpresent := false;
 mvisible := false;
 mx := 0;
 my := 0;
 ms := 0;
 lmx := 0;
 lmy := 0;
 lms := 0;

 {$IFDEF FPC}
 mouse.InitMouse;
 {$ENDIF}
end.
