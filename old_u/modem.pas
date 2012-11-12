unit modem;

interface

uses dos,crt;

type com_parity = (com_none, com_even, com_odd, com_zero, com_one);

function carrier:boolean;
function getchar:char;
function com_tx_ready:boolean;
function com_tx_empty:boolean;
function com_rx_empty:boolean;
function numchars:integer;
procedure sendchar (k:char);
procedure com_tx_string (st:string);
procedure hangup;
procedure setmodem;
procedure com_set_speed (speed:word);
procedure com_set_parity (parity:com_parity; stop_bits:byte);
procedure dontanswer;
procedure doanswer;
procedure setparam (comlame:byte; baud:longint; parity:boolean);
procedure com_install (portnum:word; var error:word);
procedure com_deinstall;

implementation

const max_port = 4;
      uart_base:array [1..max_port] of integer = ($3F8,$2F8,$3E8,$2E8);
      intnums:array [1..max_port] of byte = ($0C,$0B,$0C,$0B);
      i8259levels:array [1..max_port] of byte = (4,3,4,3);
      com_installed:boolean = false;
      rx_queue_size = 8192;
      tx_queue_size = 10;

var uart_data,uart_ier,uart_iir,uart_lcr,uart_mcr,uart_lsr,uart_msr,uart_spr:word;
    intnum,i8259bit,old_ier,old_mcr,old_i8259_mask:byte;
    exit_save,old_vector:pointer;
    rx_queue:array [1..rx_queue_size] of byte;
    rx_in,rx_out,rx_chars:word;
    tx_queue:array [1..tx_queue_size] of byte;
    tx_in,tx_out,tx_chars:integer;

procedure disable_interrupts;
inline($FA);

procedure enable_interrupts;
inline($FB);

{$R-,S-}
procedure com_interrupt_driver; interrupt;
var ch:char;
    iir,dummy:byte;
begin
  iir:=port [uart_iir];
  while not odd (iir) do begin
    case iir shr 1 of
      2:begin
          ch:=char (port[uart_data]);
          if (rx_chars<=rx_queue_size) then begin
             rx_queue [rx_in]:=ord (ch);
             inc (rx_in);
             if rx_in>rx_queue_size then
              rx_in:=1;
             rx_chars:=succ (rx_chars)
             end
          end;
      1:if (tx_chars<=0) then
          port [uart_ier]:=port [uart_ier] and not 2
        else if odd (port [uart_lsr] shr 5) then begin
          port [uart_data]:=tx_queue [tx_out];
          inc (tx_out);
          if tx_out>tx_queue_size then
           tx_out:=1;
          dec (tx_chars)
        end;
      0:dummy:=Port [uart_msr];
      3:dummy:=Port [uart_lsr]
    end;
    iir:=port [uart_iir]
  end;
  port [$20]:=$20
end;
{$R+,S+}

procedure com_flush_rx;
begin
  disable_interrupts;
  rx_chars:=0;
  rx_in:=1;
  rx_out:=1;
  enable_interrupts
end;

procedure com_flush_tx;
begin
  disable_interrupts;
  tx_chars:=0;
  tx_in:=1;
  tx_out:=1;
  enable_interrupts
end;

function carrier: Boolean;
begin
  carrier:=com_installed and odd (port [uart_msr] shr 7)
end;

function getchar:char;
begin
  if not com_installed or (rx_chars=0) then
   getchar:=#0 else begin
     disable_interrupts;
     getchar:=chr (rx_queue[rx_out]);
     inc (rx_out);
     if rx_out>rx_queue_size then
      rx_out := 1;
     dec (rx_chars);
     enable_interrupts
   end
end;

function com_tx_ready:boolean;
begin
  com_tx_ready:=(tx_chars<tx_queue_size) or not com_installed
end;

function com_tx_empty:boolean;
begin
  com_tx_empty:=(tx_chars=0) or not com_installed
end;

function com_rx_empty:boolean;
begin
  com_rx_empty:=(rx_chars=0) or not com_installed
end;

function numchars:integer;
begin
  numchars:=rx_chars
end;

procedure sendchar (k:char);
begin
  if com_installed then begin
    repeat until com_tx_ready;
    disable_interrupts;
    tx_queue [tx_in]:=ord(k);
    if tx_in<tx_queue_size then
     inc (tx_in) else
      tx_in:=1;
    inc (tx_chars);
    port [uart_ier]:=port [uart_ier] or 2;
    enable_interrupts
  end
end;

procedure com_tx_string (st:string);
var i:byte;
begin
  for i:=1 to Length (st) do
   sendchar (st[i])
end;

procedure setmodem;
begin
  if com_installed then begin
    disable_interrupts;
    port [uart_mcr]:=port [uart_mcr] or 1;
    enable_interrupts
  end
end;

procedure dontanswer;
begin
  if com_installed then begin
    disable_interrupts;
    port [uart_mcr]:=port [uart_mcr] and not 1;
    enable_interrupts
  end
end;

procedure hangup;
begin
  dontanswer;
  delay(400);
  setmodem
end;

procedure doanswer;
begin
  setmodem
end;

procedure com_set_speed (speed:word);
var divisor:word;
begin
  if com_installed then begin
    if speed < 2 then speed:=2;
    divisor:=115200 div speed;
    disable_interrupts;
    port[uart_lcr]:=port [uart_lcr] or $80;
    portw[uart_data]:=divisor;
    port[uart_lcr]:=port [uart_lcr] and not $80;
    enable_interrupts
  end
end;

procedure com_set_parity (parity:com_parity; stop_bits:byte);
var lcr:byte;
begin
  case parity of
    com_none:lcr:=$00 or $03;
    com_even:lcr:=$18 or $02;
    com_odd :lcr:=$08 or $02;
    com_zero:lcr:=$38 or $02;
    com_one :lcr:=$28 or $02
  end;
  if stop_bits=2 then
   lcr:=lcr or $04;
  disable_interrupts;
  port [uart_lcr]:=port [uart_lcr] and $40 or lcr;
  enable_interrupts
end;

procedure setparam (comlame:byte;baud:longint;parity:boolean);
begin
  com_set_speed(baud);
  if parity then com_set_parity(com_even,7) else com_set_parity(com_none,8)
end;

procedure com_install (portnum:Word; var error:word);
var ier:byte;
begin
  if com_installed then error:=3 else
   if (portnum<1) or (portnum>max_port) then error:=1 else begin
      uart_data:=uart_base[portnum];
      uart_ier:=uart_data+1;
      uart_iir:=uart_data+2;
      uart_lcr:=uart_data+3;
      uart_mcr:=uart_data+4;
      uart_lsr:=uart_data+5;
      uart_msr:=uart_data+6;
      uart_spr:=uart_data+7;
      intnum:=intnums [portnum];
      i8259bit:=1 shl i8259levels [portnum];
      old_ier:=port[uart_ier];
      port [uart_ier]:=0;
      if port [uart_ier] <> 0 then
        error:=2 else begin
          error:=0;
          disable_interrupts;
          old_i8259_mask:=port[$21];
          port [$21]:=old_i8259_mask or i8259bit;
          enable_interrupts;
          com_flush_tx;
          com_flush_rx;
          getIntVec (intnum,old_vector);
          setIntVec (intnum,@com_interrupt_driver);
          com_installed:=true;
          port [uart_lcr]:=3;
          disable_interrupts;
          old_mcr:=Port[uart_mcr];
          port [uart_mcr]:=$A or (old_mcr and 1);
          enable_interrupts;
          port [uart_ier]:=1;
          disable_interrupts;
          port [$21]:=port [$21] and not i8259bit;
          enable_interrupts
        end
      end
end;

procedure com_deinstall;
begin
  if com_installed then begin
    com_installed:=false;
    port [uart_mcr]:=old_mcr;
    port [uart_ier]:=old_ier;
    disable_interrupts;
    port [$21]:=port [$21] and not i8259bit or old_i8259_mask and i8259bit;
    enable_interrupts;
    setintvec (intnum,old_vector)
  end
end;

{$F+}
procedure exit_procedure;
{$F-}
begin
  com_deinstall;
  exitproc:=exit_save
end;

begin
  exit_save:=exitproc;
  exitProc:=@exit_procedure
end.