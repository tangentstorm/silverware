{ Robot.Pas - Program to control SERVO-BOT }
Type
 Parts =
  ( RadioOvr, { this first switch - radio override - is unavailable }
    PowrCtrl, { main power controller }
    Steering, { rear wheels }
    ForwdRev, { front wheels }
    BaseSwiv, { swivel the base }
    BasePivt, { pivot the camera }
    SholPivt, { pivot the shoulder }
    ElboPivt, { pivot the elbow }
    WrstSwiv, { swivel the wrist }
    WrstPivt, { pivot the wrist }
    HandCtrl  { control for the hand }
  )
Setting = Integer;  { or whatever we end up having to use }
Voltage = Setting;  { setting and voltage are same thing  }
Poistion = record
 Name : String;   { this is so it has a name the parser can look up }
 Part : Array[ PowrCtrl .. HandCtrl ] of Setting;
end;
SomeObj = object
 Name : string; { for the parser / dictionary }
 RightNow : Setting;
 PinNum : Byte;
 PinAdr : Word;
 Procedure Init( N : String; PN : byte; PA : word; RN : setting );
 Procedure SetTo( s : setting );  { or voltage, whatever }
 Procedure Send( s : setting ); { sends s to pinAdr }
end;

Begin
 Init;
 Repeat
 Until
 MoveTo( Quit );
End;