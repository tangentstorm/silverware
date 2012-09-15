uses crt,crtstuff,vgastuff,dos,filstuff;

begin
 if paramcount <> 1 then begin
   cwriteln('|wUsage: |WSHOWCEL |w<|Wfilename|w>'); halt;
 end;
 setmode( 19 );
 if fileexists( paramstr(1)) then loadcel( paramstr(1))
  else
   cwriteln('|RFile not found');
 getenter;
 setmode( 2 );
end.