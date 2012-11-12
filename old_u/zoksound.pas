Unit ZokSound;
InterFace

  Type
    sbiset = ( modmult, modlev, modAttDec, modSusRel,
               carmult, carlev, carAttDec, carSusRel );
    sbimember = sbiset;
    sbi = array[ sbiset ] of byte;

    SoundSystem = Object
{      soundbuffer : array[ 1 .. 1024 ] of note;}
      sboctave : byte; { for speaker emulation }
      SndOn, SbPresent, SbOn : Boolean;
      Procedure Init;
      procedure sbSetReg( reg, val : byte );
      procedure sbiset( voice : byte; ins : sbi );
      function  sbdetected : boolean;
      Procedure sbInit;
      Procedure Sound(Hz : word);
      Procedure NoSound;
      Procedure Click;
      Procedure SilverSound;
      Procedure Beep;
      Procedure Pop;
      Procedure Zap;
      Procedure Slide;
      Procedure Ansiplay( SoundC : String );
      Procedure On;
      Procedure Off;
    end;

  const
   idefault : sbi = ( $01, $10, $F0, $77, $01, $00, $F0, $77 );
   imarimba : sbi = ( $0c, $27, $f5, $07, $02, $00, $f4, $f7 );


  Var
    Spkr : SoundSystem;
    Spkr2 : SoundSystem; { to access BOTH soundblaster and speaker }

Implementation
  uses crt;

 var
      Vari, Octave, Numb : integer;
      Test, Dly, Intern, DlyKeep : longInt;
      Flager, ChartoPlay : char;
      Typom, Min1, Adder : real;


   PROCEDURE AnsiPlay(SoundC : string);  {from PC magazine}
      FUNCTION IsNumber(ch : char) : boolean;
         BEGIN
            IsNumber := (CH >= '0') AND (CH <= '9');
         END;

   {Converts a string to an integer}
      FUNCTION value(s : string) : integer;
         VAR
            ss, sss : integer;
         BEGIN
            Val(s, ss, sss);
            value := ss;
         END;

   {Plays the selected note}
      PROCEDURE sounder(key : char; flag : char);
         VAR
            old, New, new2 : Real;
         BEGIN
            adder := 1;
            old := dly;
            New := dly;
            intern := Pos(key, 'C D EF G A B')-1;
            IF (flag = '+') AND (key <> 'E') AND (key <> 'B') {See if note}
               THEN Inc(intern);                              {is sharped }
            IF (flag = '-') AND (key <> 'F') AND (key <> 'C')
               THEN Dec(intern);                              {or a flat. }
            WHILE SoundC[vari+1] = '.' DO
               BEGIN
                  Inc(vari);
                  adder := adder/2;
                  New := New+(old*adder);
               END;
            new2 := (New/typom)*(1-typom);
            spkr.sound(Round(Exp((octave+intern/12)*Ln(2)))); {Play the note}
            Delay(Trunc(New));
            spkr.Nosound;
            Delay(Trunc(new2));
         END;

   {Calculate delay for a specified note length}
      FUNCTION delayer1 : integer;
         BEGIN
            numb := value(SoundC[vari+1]);
            delayer1 := Trunc((60000/(numb*min1))*typom);
         END;

   {Used as above, except reads a number >10}

      FUNCTION delayer2 : Integer;
         BEGIN
            numb := value(SoundC[vari+1]+SoundC[vari+2]);
            delayer2 := Trunc((60000/(numb*min1))*typom);
         END;

      BEGIN                           {Play}
         SoundC := SoundC+' ';
         FOR vari := 1 TO Length(SoundC) DO
            BEGIN                     {Go through entire string}
               SoundC[vari] := Upcase(SoundC[vari]);
               CASE SoundC[vari] OF
{Check to see}    'C','D','E',
{if char is a}    'F','G','A',
{note}            'B' : BEGIN
                           flager := ' ';
                           dlykeep := dly;
                           chartoplay := SoundC[vari];
                           IF (SoundC[vari+1] = '-') OR
                              (SoundC[vari+1] = '+') THEN
{Check for flats & sharps}    BEGIN
                                 flager := SoundC[vari+1];
                                 Inc(vari);
                              END;
                           IF IsNumber(SoundC[vari+1]) THEN
                              BEGIN
                                 IF IsNumber(SoundC[vari+2]) THEN
                                    BEGIN
                                       test := delayer2;
{Make sure # is legal}                 IF numb < 65 THEN
                                          dly := test;
                                       Inc(vari, 2);
                                    END
                                 ELSE
                                    BEGIN
                                       test := delayer1;
{Make sure # is legal}                 IF numb > 0 THEN
                                          dly := test;
                                       Inc(vari);
                                    END;
                              END;
                           sounder(chartoplay, flager);
                           dly := dlykeep;
                        END;
{Check for}       'O' : BEGIN
{octave change}            Inc(vari);
                           CASE SoundC[vari] OF
                              '-' : IF octave > 1 THEN Dec(octave);
                              '+' : IF octave < 7 THEN Inc(octave);
                              '1','2','3',
                              '4','5','6',
                              '7' : octave := value(SoundC[vari])+4;
                           ELSE Dec(vari);
                           END;
                        END;
{Check for a}     'L' : IF IsNumber(SoundC[vari+1]) THEN
{change in length}         BEGIN
{for notes}                   IF IsNumber(SoundC[vari+2]) THEN
                                 BEGIN
                                    test := delayer2;
                                    IF numb < 65 THEN
{Make sure # is legal}                 dly := test;
                                    Inc(vari, 2);
                                 END
                              ELSE
                                 BEGIN
                                    test := delayer1;
                                    IF numb > 0 THEN
{Make sure # is legal}                 dly := test;
                                    Inc(vari);
                                 END;
                           END;
{Check for pause} 'P' : IF IsNumber(SoundC[vari+1]) THEN
{and it's length}          BEGIN
                              IF IsNumber(SoundC[vari+2]) THEN
                                 BEGIN
                                    test := delayer2;
                                    IF numb < 65 THEN
{Make sure # is legal}                 Delay(test);
                                    Inc(vari, 2);
                                 END
                              ELSE
                                 BEGIN
                                    test := delayer1;
                                    IF numb > 0 THEN
{Make sure # is legal}                 Delay(test);
                                    Inc(vari);
                                 END;
                           END;
{Check for}       'T' : IF IsNumber(SoundC[vari+1]) AND
{tempo change}             IsNumber(SoundC[vari+2]) THEN
                           BEGIN
                              IF IsNumber(SoundC[vari+3]) THEN
                                 BEGIN
                                    min1 := value(SoundC[vari+1]+
                                            SoundC[vari+2]+SoundC[vari+3]);
                                    Inc(vari, 3);
                                    IF min1 > 255 THEN
{Make sure # isn't too big}            min1 := 255;
                                 END
                              ELSE
                                 BEGIN
                                    min1 := value(SoundC[vari+1]+
                                            SoundC[vari+2]);
                                    IF min1 < 32 THEN
{Make sure # isn't too small}          min1 := 32;
                                 END;
                              min1 := min1/4;
                           END;
{Check for music} 'M' : BEGIN
{type}                     Inc(vari);
                           CASE Upcase(SoundC[vari]) OF
{Normal}                      'N' : typom := 7/8;
{Legato}                      'L' : typom := 1;
{Staccato}                    'S' : typom := 3/4;
                           END;
                        END;
               END;
            END;
      END;

{=====}

 procedure soundsystem.sbSetReg( reg, val : byte );
  var
   sbcounter, sbnothing : byte;
  begin
   port[ $0388 ] := reg;
   for sbcounter := 1 to 6 do sbnothing := port[ $0388 ];
   port[ $0389 ] := val;
   for sbcounter := 1 to 35 do sbnothing := port[ $0388 ];
  end;

 procedure soundsystem.sbiset( voice : byte; ins : sbi );
  begin
    sbSetReg( $20 + voice, ins[modmult] );
    sbSetReg( $40 + voice, ins[modlev] );
    sbSetReg( $60 + voice, ins[modAttDec] );
    sbSetReg( $80 + voice, ins[modSusRel] );
    sbSetReg( $23 + voice, ins[carMult]);
    sbSetReg( $43 + voice, ins[carlev] );
    sbSetReg( $63 + voice, ins[carAttDec] );
    sbSetReg( $83 + voice, ins[carSusRel] );
  end;

 function soundsystem.sbdetected : boolean;
  var
   sbstatus1, sbstatus2 : byte;
  begin
   sbSetReg( $04, $60 ); {reset timers}
   sbSetReg( $04, $80 ); {turn interrupts on}
   sbstatus1 := port[ $0388 ];
   sbSetReg( $02, $FF ); {set timer 1}
   sbSetReg( $04, $21 ); {start timer 1}
   delay( 8 );
   sbstatus2 := port[ $0388 ];
   sbdetected := (sbstatus1 and $E0 = 00) and (sbstatus2 and $E0 = $C0);
  end;

  Procedure soundsystem.sbInit;
   var
    sbcounter : byte;
   begin
    for sbcounter := $01 to $F5 do
     sbSetReg( sbcounter, 0 );
    sbiset( 0, idefault );
   end;


  Procedure SoundSystem.Init; {û's for sb & sets up : called by this unit}
   begin
    sboctave := 5;
    sbpresent := sbdetected;
    if sbpresent then sbinit;
    sbon := sbpresent;
    on;
    nosound;
   end;


  Procedure SoundSystem.Sound(Hz : word);
    begin
      if
       SndOn
      then
       if
        SbOn
       then
        begin
         sbSetreg( $A0, lo( hz ));
         sbSetreg( $B0, 32 + sboctave shl 2 + (hi( hz ) and $03) );
        end
       else
        Crt.Sound(Hz);
    end;

  Procedure SoundSystem.NoSound;
    begin
     if
      sbon
     then
      sbsetreg( $B0, $00 )
     else
      Crt.NoSound;
    end;

  Procedure SoundSystem.Click;
    begin
       Sound(400);
       Delay(2);
       NoSound;
    end;

  Procedure SoundSystem.SilverSound;
    begin
      sound(3300); delay(50);
      sound(1200); delay(90);
      sound(945); delay(80);
      sound(1469); delay(74);
      nosound;
    end;

  Procedure SoundSystem.Beep;
    begin
    end;

  Procedure Soundsystem.Pop;
    var
      c : byte;
    begin
      for c := 1 to 50 do begin Sound(c*50); delay(1); end;
      Nosound;
    end;

  Procedure SoundSystem.Zap;
    var
      c : byte;
    begin
      For c := 1 to 50 do begin sound(c*150); delay(1); sound($FFFF-(C*150));
                            delay(1); end;
    end;

  Procedure SoundSystem.Slide;
    begin
      sound(50);
      delay(100);
      nosound;
    end;

  Procedure SoundSystem.Ansiplay( SoundC : String );
   begin
    If SndOn then Zoksound.Ansiplay( soundc );
   end;

  Procedure SoundSystem.On;
    begin
      SndOn := True;
    end;

  Procedure SoundSystem.Off;
    begin
      SndOn := False;
    end;
Begin
 {init ansi stuff}
      Octave := 4;
      ChartoPlay := 'N';
      Typom := 7/8;
      Min1 := 120;
      ansiplay('t280 o3 p2 l4');
 {init my stuff}
 Spkr.Init;
End.