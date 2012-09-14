Unit SndStuff;
InterFace
  Type
    noises = ( nonoise, click, silversound, beep, pop, ding, zap, slide  );
    SoundSystem = Object
      SndOn : Boolean;
      Procedure Sound(Hz : word);
      Procedure NoSound;
      Procedure Click;
      Procedure SilverSound;
      Procedure Beep;
      Procedure Pop;
      Procedure Ding;
      Procedure Zap;
      Procedure Slide;
      procedure makenoise( n : noises );
      Procedure On;
      Procedure Off;
    end;
  Var
    Spkr : SoundSystem;
Implementation
  uses crt;

  Procedure SoundSystem.Sound(Hz : word);
    begin
      if SndOn then Crt.Sound(Hz);
    end;

  Procedure SoundSystem.NoSound;
    begin
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
    sound( 300 ); delay( 100 ); nosound;
   end;

  Procedure Soundsystem.Pop;
    var
      c : byte;
    begin
      for c := 1 to 50 do begin Sound(c*50); delay(1); end;
      Nosound;
    end;

  procedure soundsystem.ding;
   begin
    sound( 800 ); delay( 50 );
    sound( 900 ); delay( 50 );
    sound( 800 ); delay( 50 );
    nosound;
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

  Procedure SoundSystem.Makenoise( n : noises );
   begin
   end;

  Procedure SoundSystem.On;
    begin
      SndOn := True;
    end;

  Procedure SoundSystem.Off;
    begin
      SndOn := False;
    end;
begin
 spkr.on;
End.