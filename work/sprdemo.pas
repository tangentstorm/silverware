program SpritesTest;
uses
  Sprites, Crt;

procedure Init;
begin
  SetMode ($13);
  Randomize;
end;

procedure LoadSpriteData;
const
  Sx = 30;
type
  SpriteDataType = record
                     FileName : string [40];
                     x, y,
                     w, h : integer;
                   end;
const
  SpriteData : array [1..7] of SpriteDataType =
               ((FileName:'S2320R.CEL'; x:Sx; y:50; w:23; h: 20),
                (FileName:'P2320.CEL'; x:Sx+30; y:50; w:23; h: 20),
                (FileName:'R2320.CEL'; x:Sx+60; y:50; w:23; h: 20),
                (FileName:'I620.CEL'; x:Sx+90; y:50; w:6; h: 20),
                (FileName:'T2420.CEL'; x:Sx+105; y:50; w:24; h: 20),
                (FileName:'E2320.CEL'; x:Sx+135; y:50; w:23; h: 20),
                (FileName:'S2320G.CEL'; x:Sx+165; y:50; w:23; h: 20));
var
  L : byte;
begin
  for L := 1 to 7 do begin
    with SpriteData [L] do begin
      LoadCEL (FileName, addr (Sprite[L].SpriteData));
      Sprite [L].w := w; Sprite [L].h := h;
      Sprite [L].x := x; Sprite [L].y := y;
      Sprite [L].Active := TRUE;
    end;
  end;
  for L := 8 to 14 do begin
    with SpriteData [L-7] do begin
      LoadCEL (FileName, addr (Sprite[L].SpriteData));
      Sprite [L].w := w; Sprite [L].h := h;
      Sprite [L].x := x + 70; Sprite [L].y := y + 90;
      Sprite [L].Active := TRUE;
    end;
  end;
  for L := 1 to 14 do begin
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
  for L := 1 to 14 do begin
    with Sprite [L] do begin
      x := x + ix; y := y + iy;
      if (x<=0) or (x >= 320-25) then begin
        ix := -ix;
        x := x + ix;
      end;
      if (y<=0) or (y >= 200-25) then begin
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
  LoadCOL ('SPRDEMO.COL');
  LoadCEL ('SPRDEMO.CEL', Virtual_Screen);
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