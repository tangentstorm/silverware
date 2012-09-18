program c512;

begin
 asm
   mov ax, 1103h
   mov bl, 4
   int 10h
  end;
end.