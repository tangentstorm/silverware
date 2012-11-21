{$G+,X+}

program MCGA_in_pascal_tutorial_code;


uses crt;


procedure InitGraph; assembler;
asm
        mov     ax,$13
        int     $10
end;

procedure CloseGraph; assembler;
asm
        mov     ax,3
        int     $10
end;


procedure FillScreen(color: byte);
begin
    fillchar(mem[$A000:0], 320*200, color);
end;


procedure PutPixel(x, y: integer; color: byte);
begin
    mem[$A000:(y*320)+x] := color;
end;


procedure ClipPutPixel(x, y: integer; color: byte);
begin
    if (word(x)<320) and (word(y)<200) then
        mem[$A000:(y*320)+x] := color;
end;


procedure Line(x1, y1, x2, y2: integer; color: byte);
var
    d, dx, dy: integer;
    Aincr, Bincr, Yincr: integer;
    j: integer;
begin
    dx := x2 - x1;
    if (dx < 0) then begin
        dx := -dx;
        j := x2;
        x2 := x1;
        x1 := j;
    end;
    dy := y2 - y1;
    Yincr := 1;
    if (dy < 0) then begin
        dy := -dy;
        Yincr := -1;
    end;
    if (dx >= dy) then begin
        d := (2 * dy) - dx;
        Aincr := 2 * (dy - dx);
        Bincr := 2 * dy;
        for j := 0 to dx do begin
            PutPixel(x1, y1, color);
            inc(x1);
            if (d >= 0) then begin
                inc(y1, Yincr);
                inc(d, Aincr);
            end
            else
                inc(d, Bincr);
        end;
    end
    else begin
        d := (2 * dx) - dy;
        Aincr := 2 * (dx - dy);
        Bincr := 2 * dx;
        for j := 0 to dy do begin
            PutPixel(x1, y1, color);
            inc(y1, Yincr);
            if (d >= 0) then begin
                inc(x1);
                inc(d, Aincr);
            end
            else
                inc(d, Bincr);
        end;
    end;
end;


procedure FastLine(x1, y1, x2, y2: integer; color: byte);

{                                                                       }
{ Same as above but writes directly to video memory rather than call    }
{   PutPixel for each pixel                                             }
{                                                                       }

var
    d, dx, dy: integer;
    Aincr, Bincr, Yincr: integer;
    j: integer;
    VidOffset: word;
begin
    dx := x2 - x1;
    if (dx < 0) then begin
        dx := -dx;
        j := x2;
        x2 := x1;
        x1 := j;
    end;
    dy := y2 - y1;
    Yincr := 320;
    if (dy < 0) then begin
        dy := -dy;
        Yincr := -320;
    end;
    VidOffset := 320 * y1 + x1;
    if (dx >= dy) then begin
        d := (2 * dy) - dx;
        Aincr := 2 * (dy - dx);
        Bincr := 2 * dy;
        for j := 0 to dx do begin
            mem[$A000:VidOffset] := color;
            inc(VidOffset);
            if (d >= 0) then begin
                inc(VidOffset, Yincr);
                inc(d, Aincr);
            end
            else
                inc(d, Bincr);
        end;
    end
    else begin
        d := (2 * dx) - dy;
        Aincr := 2 * (dx - dy);
        Bincr := 2 * dx;
        for j := 0 to dy do begin
            mem[$A000:VidOffset] := color;
            inc(VidOffset, Yincr);
            if (d >= 0) then begin
                inc(VidOffset);
                inc(d, Aincr);
            end
            else
                inc(d, Bincr);
        end;
    end;
end;




procedure Circle(Xcenter, Ycenter, Radius: word; color: byte);
var
    x, y, x2, y2: word;
begin
    if Radius = 0 then begin
        mem[$A000:Ycenter*320+Xcenter] := color;
        exit;
    end;
    y := 0;
    y2 := 0;
    x := Radius;
    x2 := Radius;
    repeat
        clipPutPixel(Xcenter+x, Ycenter+y, color);
        clipPutPixel(Xcenter-x, Ycenter+y, color);
        clipPutPixel(Xcenter+x, Ycenter-y, color);
        clipPutPixel(Xcenter-x, Ycenter-y, color);
        clipPutPixel(Xcenter+y, Ycenter+x, color);
        clipPutPixel(Xcenter-y, Ycenter+x, color);
        clipPutPixel(Xcenter+y, Ycenter-x, color);
        clipPutPixel(Xcenter-y, Ycenter-x, color);

        inc(y);
        inc(y2, y+y-1);
        if x2 < y2 then begin
            inc(x2, x+x-1);
            dec(x);
        end;
    until x < y;
end;


procedure FastCircle(Xcenter, Ycenter, Radius: word; color: byte);

{                                                                       }
{ Same as above but writes directly to video memory rather than call    }
{   PutPixel for each pixel and doesn't do clipping.  This is THE       }
{   FASTEST circle algorithm in pure pascal.                            }
{                                                                       }

var
    x, y, x2, y2, VidOffset, x320, y320: word;
begin
    VidOffset := Ycenter * 320 + Xcenter;
    if Radius = 0 then begin
        mem[$A000:VidOffset] := color;
        exit;
    end;
    y := 0;
    y2 := 0;
    x := Radius;
    x2 := Radius;
    x320 := Radius * 320;
    y320 := 0;
	repeat
        mem[$A000:VidOffset+y320+x] := color;
        mem[$A000:VidOffset+y320-x] := color;
        mem[$A000:VidOffset-y320+x] := color;
        mem[$A000:VidOffset-y320-x] := color;
        mem[$A000:VidOffset+x320+y] := color;
        mem[$A000:VidOffset+x320-y] := color;
        mem[$A000:VidOffset-x320+y] := color;
        mem[$A000:VidOffset-x320-y] := color;

        inc(y);
        inc(y2, y+y-1);
        inc(y320, 320);
        if x2 < y2 then begin
            inc(x2, x+x-1);
            dec(x);
            dec(x320, 320);
        end;
    until x < y;
end;


procedure HorzLine(x1, x2, y: integer; color: byte);
var
    temp: integer;
begin
    if x1 > x2 then begin
        temp := x1;
        x1 := x2;
        x2 := temp;
    end;
    fillchar(mem[$A000:y*320+x1], x2-x1+1, color);
end;

procedure FillCircle(Xcenter, Ycenter, Radius: word; color: byte);
var
    x, y: integer;
    x2, y2, VidOffset, x320, y320: word;
begin
    y := 0;
    y2 := 0;
    x := Radius;
    x2 := Radius;
    VidOffset := Ycenter * 320 + Xcenter;
    x320 := Radius * 320;
    y320 := 0;
	repeat
        fillchar(mem[$A000:VidOffset-y320-x], x+x+1, color);
        fillchar(mem[$A000:VidOffset-x320-y], y+y+1, color);
        fillchar(mem[$A000:VidOffset+y320-x], x+x+1, color);
        fillchar(mem[$A000:VidOffset+x320-y], y+y+1, color);

        inc(y);
        inc(y2, y+y-1);
        inc(y320, 320);
        if x2 < y2 then begin
            inc(x2, x+x-1);
            dec(x);
            dec(x320, 320);
        end;
	until x < y;
end;



procedure FillBox(x1, y1, x2, y2: integer; color: byte);
var
    temp, width: integer;
    VidOffset: word;
begin
    if y1 > y2 then begin
        temp := y2;
        y2 := y1;
        y1 := temp;
    end;
    VidOffset := y1*320+x1;
    width := x2-x1;
    if width < 0 then begin
        inc(VidOffset, width);
        width := -width;
    end;
    inc(width);

    repeat
        fillchar(mem[$A000:VidOffset], width, color);
        inc(y1);
        inc(VidOffset, 320);
    until y1>=y2;
end;




begin
    InitGraph;
    randomize;

    FillScreen(0);
    repeat
        PutPixel(random(320), random(200), random(256));
    until keypressed;
    readkey;

    FillScreen(0);
    repeat
        Line(random(320),random(200), random(320),random(200), random(256));
    until keypressed;
    readkey;

    FillScreen(0);
    repeat
        FastLine(random(320),random(200), random(320),random(200), random(256));
    until keypressed;
    readkey;

    FillScreen(0);
    repeat
        Circle(random(240)+40, random(120)+40, random(80), random(256));
    until keypressed;
    readkey;

    FillScreen(0);
    repeat
        FastCircle(random(240)+40, random(120)+40, random(40), random(256));
    until keypressed;
    readkey;

    FillScreen(0);
    repeat
        FillCircle(random(240)+40, random(120)+40, random(40), random(256));
    until keypressed;
    readkey;

    FillScreen(0);
    repeat
        FillBox(random(320),random(200), random(320),random(200), random(256));
    until keypressed;
    readkey;

    CloseGraph;
end.
