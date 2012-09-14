Program Controller;
uses crt, crtstuff, zokstuff;
{$I radio.PAS}

Type
 settings = ( top, up, neutral, down, bottom );
 Parts =
  ( first,
    RadioOvr, { this first switch - radio override - is unavailable }
    PowrCtrl, { main power controller }
    Steering, { rear wheels }
    ForwdRev, { front wheels }
    BaseSwiv, { swivel the base }
    BasePivt, { pivot the camera }
    SholPivt, { pivot the shoulder }
    ElboPivt, { pivot the elbow }
    WrstSwiv, { swivel the wrist }
    WrstPivt, { pivot the wrist }
    HandCtrl,  { control for the hand }
    last
  );
 Controlrec = record
  enabled : boolean;
  setting : settings;
 end;

Var
 controlset : array[ radioovr .. wrstpivt  ] of controlrec;
 active : parts;

procedure drawradio;
 begin
  stamp( 0, 1, 80, 19, @radiopic );
 end;

function confirmquit : boolean;
 var
  z : zconfirmbox;
 begin
  z.init( 25, 8, '|WD|Go |WY|Gou |WR|Gea|WLL|Gy |WW|Ga|WNT |WT|Go |WQ|Gui|WT|Y?', '|B(|WY|w/|WN|B)' );
  confirmquit := z.get;
 end;

procedure run;
 var
  ch : char;
  quit : boolean;
 begin
  quit := false;
  repeat
   ch := readkey;
   case upcase( ch ) of
    'Q' : if confirmquit then quit := true;
    #0  : case readkey of
           #72 {U}: if
                     pred( controlset[ active ].setting ) <> top
                    then
                     controlset[ active ].setting
                      := pred( controlset[ active ].setting );
           #80 {D}: if
                     succ( controlset[ active ].setting ) <> bottom
                    then
                     controlset[ active ].setting
                      := succ( controlset[ active ].setting );
           #75 {L}: if pred( active ) <> first then active := pred( active );
           #77 {R}: if succ( active ) <> last then active := succ( active );
          end;
   end;
   drawradio;
  until quit;
 end;

procedure init;
 begin
  setupcrt;
  drawradio;
  rectangle( 1, 21, 80, 24, $01 );
  ccenterxy( 40, 21, '|B=|C=|b[|WCONTROLS|b]|C=|B=');
  cwritexy( 3, 22,  '|K[|W|K]|w Left ');
  cwritexy( 3, 23,  '|K[|W'#26'|K]|w Right ');
  cwritexy( 16, 22, '|K[|W|K]|w up');
  cwritexy( 16, 23, '|K[|W|K]|w down');
  cwritexy( 62, 22, '|K[|WQ|K]|w Quit ');
  active := radioovr;
 end;

procedure shutdown;
 begin
  doscursoron;
 end;

begin
 init;
 run;
 shutdown;
end.