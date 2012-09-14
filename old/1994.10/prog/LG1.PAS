{ Pascal Miniadventure }
{ adventure #1 }
{ This is an example of adventure writing, }
{ not a hard-core adventure game. }

const
 ew    =  12;
 nw    =   9;
 ne    =   5;
 sew   =  14;
 nonly =   1;
 nsew  =  15;
 newud =  61;
 sw    =  10;
 ns    =   3;
 donly =  32;
 dn    =  33;
 ud    =  48;
 su    =  18;

type
 rooms = ( start, grandroom, vestibule, narrow1, lakeshore, island, brink,
	   iceroom, ogreroom, narrow2, pit, crystal, batscave, steam,
	   deadend, ladder, maze, flames );
 directions = (n,s,e,w,u,d);
 byte = 0..255;

var
 command : string;
 ch : char;
 dchars : set of char;
 location,
 ogreloc : rooms;
 visited : array[ start..flames] of boolean;
 next : directions;
 twopow : array[n..d] of integer;
 turns : integer;
 done,
 quit,
 eaten,
 awake,
 readmsg,
 carrying,
 dropped,
 trapped,
 cooked : boolean;

procedure wipe;
 var
  ff : byte;
 begin
  for ff := 1 to 52 do writeln;
 end;

procedure introduction;
 begin
  wipe;
  writeln(' Weclome to miniadventure! ');
  writeln(' Your goal will be  to find a treasure and bring it to the ');
  writeln(' starting point. You will also get points for finding each ');
  writeln(' location  in the  adventure.  Points will be deducted for ');
  writeln(' various undesireable happenings: waking the ogre, getting ');
  writeln(' eaten, being toasted, etc. ');
  writeln;
  writeln(' I will guide you and be your eyes and ears. I''ll describe ');
  writeln(' your location and give you special instructions from time ');
  writeln(' to time. ');
  writeln;
  writeln(' To command me, tell me a direction to take - north, south ');
  writeln(' east, west, up, or down. I only look at the  first letter ');
  writeln(' of the command, so abbreviations are okay by me. ');
  writeln;
  writeln(' When you are ready to begin the adventure, press <Enter>. ');
  readln(command);
  wipe;
 end;

procedure initialize;
 var
  loc : rooms;
 begin
  location := start;
  dchars := ['q','n','s','e','w','u','d'];
  done := false;
  quit := false;
  cooked := false;
  eaten := false;
  awake := false;
  readmsg := false;
  carrying := false;
  trapped := false;
  dropped := false;
  turns := 0;
  twopow[n] := 1;
  twopow[s] := 2;
  twopow[e] := 4;
  twopow[w] := 8;
  twopow[u] := 16;
  twopow[d] := 32;
  for loc := start to flames do
   visited[ loc ] := false;
 end;

function whichway : directions;
 begin
  turns := turns + 1;
  repeat
   repeat
    writeln;
    write(' Which way? => ');
    readln(command);
   until length( command ) > 0;
   ch := command[1];
   case ch of
    'n' : whichway := n;
    's' : whichway := s;
    'e' : whichway := e;
    'w' : whichway := w;
    'u' : whichway := u;
    'd' : whichway := d;
    'q' : quit := true;
   end;
  until ch in dchars;
  writeln;
 end;

procedure noway;
 begin
  writeln;
  writeln(' You cannot go in that direction. ');
 end;

procedure pstart;
 begin
  if carrying
   then done := true
  else
   begin
    writeln(' You are standing near a hole in the ground.  It looks big ');
    writeln(' enough to climb down.');
    case whichway of
     n,s,e,w : noway;
     u : writeln(' You can''t jump to the clouds!');
     d : location := vestibule;
    end;
   end;
 end;

procedure pvestibule;
 begin
  writeln(' You are in the entrance  to a cave of passageways.  There ');
  writeln(' are  halls  leading  off to the north,  south,  and east. ');
  writeln(' Above you, a tunnel leads to the surface. ');
  if dropped then
   begin
    writeln(' To  the north,  through a  narrow crack,  you can see the ');
    writeln(' treasure.  If you stretch your arm through,  you might be ');
    writeln(' able to reach it. Would you like to try? ');
    writeln;
    write(' Try to reach it? => ');
    readln( command );
    if command[1] = 'y' then
     begin
      carrying := true;
      dropped := false;
      writeln;
      writeln(' Got it! ');
     end;
   end;
   Case whichway of
    n : location := narrow1;
    s : location := grandroom;
    e : location := iceroom;
    w,d : noway;
    u : location := start;
   end;
 end;


begin
 introduction;
 initialize;
 repeat
  visited[ location ] := true;
  case Location of
   start : pstart;
(*   grandroom : pgrandroom; *)
   vestibule : pvestibule;
(*   narrow1 : pnarrow1;
   lakeshore : plakeshore;
   island : pisland;
   brink : pbrink;
   iceroom : piceroom;
   ogreroom : pogreroom;
   narrow2 : pnarrow2;
   pit : ppit;
   crystal : pcrystal;
   batscave : pbatscave;
   steam : psteam;
   deadend : pdeadend;
   ladder : pladder;
   maze : pmaze;
   flames : pflames;
*)  end;
 until Quit or Done;
(* congratulations; *)
end.