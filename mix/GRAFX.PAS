Unit Grafx;

InterFace

  Procedure InitGrafx;

Implementation
  Uses Graph,BGIDriv,BGIFont;

procedure Abort(Msg : string);
begin
  Writeln(Msg, ': ', GraphErrorMsg(GraphResult));
  Halt(1);
end;

Procedure InitGrafx;
  var
   grDriver : Integer;
   grMode   : Integer;
   ErrCode  : Integer;
  begin
   if RegisterBGIdriver(@CGADriverProc) < 0 then Abort('CGA');
   if RegisterBGIdriver(@EGAVGADriverProc) < 0 then Abort('EGA/VGA');
   if RegisterBGIdriver(@HercDriverProc) < 0 then Abort('Herc');
   if RegisterBGIdriver(@ATTDriverProc) < 0 then Abort('AT&T');
   if RegisterBGIdriver(@PC3270DriverProc) < 0 then Abort('PC 3270');
   if RegisterBGIfont(@GothicFontProc) < 0 then  Abort('Gothic');
   if RegisterBGIfont(@SansSerifFontProc) < 0 then  Abort('SansSerif');
   if RegisterBGIfont(@SmallFontProc) < 0 then Abort('Small');
   if RegisterBGIfont(@TriplexFontProc) < 0 then Abort('Triplex');
   grDriver := Detect;
   InitGraph(grDriver,grMode,'');
   ErrCode := GraphResult;
   if ErrCode <> grOk then WriteLn('Graphics error:',GraphErrorMsg(ErrCode));
   SetTextStyle(SmallFont,HorizDir,4);
  end;

End.