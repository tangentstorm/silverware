Program TestVGA;
Uses
  Common,
  ModeX,
  CRT;

Var
  bf : PrFontObj;
  p  : PictHeader;
  ev : EventRec;
  mask : BytePtr;


BEGIN
  SetMode(MODE200, 0, 0);

  InitEvents;
  SolidBox(0, 0, 319, 239, 2);
  Line(0, 0, 319, 239, 15);
  Line(0, 239, 310, 0, 73);
  p.height := 16;
  p.width := 16;
  p.bytewidth := 4;
  p.data := rodent.curr_crsr^.bm;
  PutPic(30, 30, p);

  UsePage(VPAGE3);
  PutPic(0, 2, p);
  mask := GetPicMask(p);
  UsePage(VPAGE1);
  rodent.savebg := True;
  SetEventMask(KEY_EVENT Or LB_OFF);
  BlockPageToPage(VPAGE3, VPAGE1, 0, 2, 4, 16, 20, 20);
  CopyScreenToScreenMaskedX(VPAGE3, 0, 2, 4, 16,
                            99, 120, VPAGE1, mask);

  MouseShow;
  While Not GetEvent(ev) Do ;
  MouseHide;
  CloseEvents;
  SetTextMode;
END.
