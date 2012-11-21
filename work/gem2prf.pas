Program Gem2PRF;

Uses
 CRT,
 DOS;

Type
  BytePtr = ^Byte;
  WordPtr = ^Word;

  gemrecord = Record
    id, size           : Integer;
    name               : Array[0..31] Of Char;
    lo_ade             : Integer;
    hi_ade             : Integer;
    top_dist           : Integer;
    ascent_dist        : Integer;
    half_dist          : Integer;
    descent_dist       : Integer;
    bottom_dist        : Integer;
    widest_char        : Integer;
    widest_cell        : Integer;
    left_offset        : Integer;
    right_offset       : Integer;
    thick              : Integer;
    underline_size     : Integer;
    v1                 : Integer;
    v2                 : Integer;
    v3                 : Integer;
    horiz_table        : LongInt;
    char_offset_table  : LongInt;
    font_data          : LongInt;
    form_width         : Integer;
    form_height        : Integer;
  End;

  PRFontWriteType = (PRBitMapped, PRBGIStroked);
  PRFontJust = (PRFJStart, PRFJCenter, PRFJEnd);
  PRFontDir = (PRFDAcross, PRFDUpDown);
  PRFontMem = (PRFLoaded, PRFLinked, PRFBios);

  PRFDataPtr = ^PRFDataHeader;
  PRFDataHeader = Record
    FontType      : PRFontWriteType;
    NumberOfChar  : Word;  (* Number of characters in font  *)
    FirstChar     : Byte;  (* ASCII code of first character *)
    LastChar      : Byte;  (* ASCII Code of Last Character  *)
    WidestChar    : Byte;  (* Pixel Width of widest character *)

    FontByteWidth : Byte;  (* font width in bytes for bitmapped fonts *)

    (* For bitmapped fonts this gives the height in scan lines of the   *)
    (* font. For Stroked fonts this gives the height scaling of the     *)
    (* font when created.                                               *)
    FHeight       : Byte;

    (* For Stroked fonts only.  This is the width scaling factor.       *)
    FWidth        : Byte;

    (* The next three pointer will just contain garbage for dynamic     *)
    (* Fonts.  For Linked fonts they will contain pointers to the code  *)
    (* segment areas that contain the data.                             *)

    (* Array of widths for each character. For Stroked characters this  *)
    (* gives the number of line segments that it takes to form the      *)
    (* character.  For bitmapped characters this is the width for       *)
    (* porportional fonts                                               *)
    CWidth        : BytePtr;

    (* Gives offsets to where each character's information starts.  For *)
    (* bitmapped sets this is an incremented value that is dependent    *)
    (* upon the width of the bitmap.  For stroked fonts it points to    *)
    (* the start of the line segments.                                  *)
    COffset       : WordPtr;

    FontData      : Pointer;
  End;

Var
  infile, outfile : File;
  outname         : String[12];
  inpath          : PathStr;
  indir           : DirStr;
  inname          : NameStr;
  inext           : ExtStr;
  charblock       : BytePtr;
  charsize        : Word;
  widthtable      : BytePtr;
  widthmark       : LongInt;
  header          : PRFDataHeader;

  gem             : gemrecord;
  gemdata         : BytePtr;
  gemoffset       : WordPtr;

  i               : Word;

(* allocate buffers and set up the font header information *)
Procedure SetFont;
Var
  OTSize  : Word;
  DTSize  : Word;
Begin
  { Set up offset table }
  OTSize := (gem.hi_ade - gem.lo_ade + 2) Shl 1;
  GetMem(gemoffset, OTSize);
  If gemoffset = Nil Then
  Begin
    Halt;
  End;
  DTSize := gem.form_width * gem.form_height;
  GetMem(gemdata, DTSize);
  If gemdata = Nil Then
  Begin
    Halt;
  End;
  With header Do
  Begin
    FontType := PRBitMapped;
    NumberOfChar := gem.hi_ade - gem.lo_ade + 1;
    {If gem.lo_ade > 0 Then
      Inc(NumberOfChar);}
    FirstChar := gem.lo_ade;
    LastChar := gem.hi_ade;
    FHeight := gem.form_height;
    If gem.widest_char > 0 Then
      WidestChar := gem.widest_char
    Else
      WidestChar := gem.widest_cell;
    FontByteWidth := WidestChar Div 8;
    If (WidestChar Mod 8) <> 0 Then
      Inc(FontByteWidth);
    charsize := FontByteWidth * FHeight;
    GetMem(charblock, charsize);
    if charblock = Nil Then
    Begin
      WriteLn('Cannot allocate the character block');
      Halt(1);
    End;
    GetMem(widthtable, NumberOfChar);
    if widthtable = Nil Then
    Begin
      WriteLn('Cannot allocate the width table');
      Halt(1);
    End;
    FillChar(widthtable^, NumberOfChar, 0);
  End;
  Seek(infile, gem.char_offset_table);
  BlockRead(infile, gemoffset^, OTSize);
  Seek(infile, gem.font_data);
  BlockRead(infile, gemdata^, DTSize);
  Close(infile);
End;

Procedure StartPRF;
Var
  strg  : String;
Begin
  strg := 'Powder River Font File' + #0;
  strg[0] := Chr(Ord(strg[0]) - 1);
  BlockWrite(outfile, strg, 26);
  strg := 'GemFont:' + inname + inext + #0;
  strg[0] := Chr(Ord(strg[0]) - 1);
  BlockWrite(outfile, strg, 42);
  BlockWrite(outfile, header, SizeOf(header));
  widthmark := FilePos(outfile);
  BlockWrite(outfile, widthtable^, header.NumberOfChar);
End;

Procedure XlateChar(ch : Word);
Var
  gtemp    : BytePtr;
  goffset  : Word;
  gofptr   : WordPtr;
  gbits    : Word;
  ftemp    : BytePtr;
  gmask,
  fmask    : Byte;
  j, x     : Word;
  cwidth   : Byte;
  gcount   : Word;
  fcount   : Word;
  fwidth   : BytePtr;

  Procedure GetWidth;
  Var
    char_bit_offset   : Word;
    font_offset, tptr : WordPtr;
  Begin
    font_offset := Pointer(LongInt(gemoffset) + (ch Shl 1));
    char_bit_offset := WordPtr(font_offset)^;
    tptr := Pointer(LongInt(font_offset) + 2);
    cwidth := WordPtr(tptr)^ - char_bit_offset;
  End;

Begin
  goffset := WordPtr(LongInt(gemoffset) + (ch Shl 1))^;
  gbits   := goffset And 7;
  goffset := goffset Shr 3;
  fmask := $80;
  fcount := 0;
  FillChar(charblock^, charsize, 0);
  GetWidth;
  fwidth := BytePtr(LongInt(widthtable) + ch);
  fwidth^ := cwidth;
  For j := 0 To header.Fheight - 1 Do
  Begin
    ftemp := BytePtr(LongInt(charblock) + (j * header.FontByteWidth));
    gmask := $80 Shr gbits;
    gcount := gbits;
    gtemp := BytePtr(LongInt(gemdata) + (j * gem.form_width) + goffset);
    For x := 1 To cwidth Do
    Begin
      If (gmask And gtemp^) <> 0 Then
        ftemp^ := ftemp^ Or fmask;
      Inc(gcount);
      If gcount = 8 Then
      Begin
        gcount := 0;
        gmask := $80;
        Inc(gtemp);
      End
      Else
        gmask := gmask Shr 1;

      Inc(fcount);
      If fcount = 8 Then
      Begin
        fcount := 0;
        fmask := $80;
        Inc(ftemp);
      End
      Else
        fmask := fmask Shr 1;
    End;
    fcount := 0;
    fmask := $80;
  End;
  BlockWrite(outfile, charblock^, charsize);
End;

BEGIN
  If ParamCount = 0 Then
  Begin
    WriteLn('USAGE: GEM2PRF <gemfont name> [output name]');
    WriteLn;
    Halt;
  End;
  inpath := ParamStr(1);
  FSplit(inpath, indir, inname, inext);
  If ParamCount = 1 Then
  Begin
    outname := inname + '.PRF';
  End
  Else
  Begin
    outname := ParamStr(2) + '.PRF';
  End;
  Assign(infile, inpath);
  Reset(infile, 1);
  If IOResult <> 0 Then
  Begin
    WriteLn('Cannot open ' + inpath);
    WriteLn('- aborting!!!');
    Halt;
  End;
  Assign(outfile, outname);
  Rewrite(outfile, 1);
  BlockRead(infile, gem, SizeOf(gemrecord));
  SetFont;
  StartPRF;
  For i := 1 To header.NumberOfChar Do
    XlateChar(i - 1);
  Seek(outfile, widthmark);
  BlockWrite(outfile, widthtable^, header.NumberOfChar);
  Close(outfile);
END.
