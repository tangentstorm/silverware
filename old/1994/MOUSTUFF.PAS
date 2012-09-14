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
  ms, mx, my, lms, lmx, lmy : integer;

 function mousethere : boolean;
 procedure resetmouse( var status : boolean; var numbtns : integer );
 procedure showmouse( yn : boolean );
 procedure mouseon;
 procedure getmpos;
 procedure gettextmpos;
 procedure setmpos( a, b : integer );
 procedure setmwin( a1, b1, a2, b2 : integer );
 procedure setgcurs( gcurs : gcursor );
 procedure setmaccel( t : integer );
 function mousemoved : boolean;

implementation
uses dos,crtstuff;
 var
  regs : registers;

 function mousethere : boolean;
  var
   dOff, dSeg : integer;
  begin
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
end.
