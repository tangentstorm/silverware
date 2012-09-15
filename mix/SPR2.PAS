program SpritesTest;
uses
  Sprites, Crt;

procedure Init;
begin
  SetMode ($93);
  Randomize;
end;

procedure LoadSpriteData;
const
  Sx = 35;
  Sy = 35;
type
  SpriteDataType = record
                     FileName : string [40];
                     x, y,
                     w, h : integer;
                   end;
const
  SpriteData : array [1..4] of SpriteDataType =
               ((FileName:'C:\TP\INC\BUG1.CEL'; x:Sx; y:50; w:35; h: 35),
                (FileName:'C:\TP\INC\BUG2.CEL'; x:Sx; y:50; w:35; h: 35),
                (FileName:'C:\TP\INC\BUG3.CEL'; x:Sx; y:50; w:35; h: 35),
                (FileName:'C:\TP\INC\BUG4.CEL'; x:Sx; y:50; w:35; h: 35));
var
  L : byte;
begin
  for L := 1 to 4 do begin
    with SpriteData [L] do begin
      LoadCEL (FileName, addr (Sprite[L].SpriteData));
      Sprite [L].w := w; Sprite [L].h := h;
      Sprite [L].x := x; Sprite [L].y := y;
      Sprite [L].Active := TRUE;
    end;
  end;
  for L := 1 to 4 do begin
    with Sprite [L] do begin
      ix := random (11) - 5;
      iy := random (11) - 5;
    end;
  end;
end;

procedure UpdateSpriteData;
var
  L : byte;
begin
  for L := 1 to 4 do begin
    with Sprite [L] do begin
      x := x + ix; y := y + iy;
      if (x<=0) or (x >= 320-35) then begin
        ix := -ix;
        x := x + ix;
      end;
      if (y<=0) or (y >= 200-35) then begin
        iy := -iy;
        y := y + iy;
      end;
    end;
  end;
end;

var
  Ch : char;
begin
  Init;
  LoadSpriteData;
  LoadCel('\TP\INC\BUG.CEL',Virtual_Screen);
  LoadCol('\AA\rainbow.COL');
  DrawSprites;
  ShowVirtualScreen;
  delay (2000);
  repeat
    DrawSprites;
    ShowVirtualScreen;
    UpdateSpriteData;
  until keypressed;
  Ch := ReadKey;
  SetMode (3);
end.