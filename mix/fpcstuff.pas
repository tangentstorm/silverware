{$mode objfpc}
unit fpcstuff;
interface uses keyboard, video, mouse;

implementation

initialization
 keyboard.initkeyboard;
 video.initvideo;
 mouse.initmouse;
finalization
 keyboard.donekeyboard;
 video.donevideo;
 mouse.donemouse;
end.