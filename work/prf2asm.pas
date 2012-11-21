Program PRF_Font_to_ASM;

Uses
  {TPString,}
  PRFont;

Type
  BytePtr = ^Byte;

Const
  asmheader : Array[1..6] Of String[51] =
    ('BIT_MAPPED EQU 0',
     'STROKED EQU 1',
     '',
     '.MODEL small',
     '.CODE',
     'db      21, ''Powder River Font File'', 0, ''      '''
     );
  dbprefix : String[4] = '  db';

Var
  outfile  : Text;
  infile   : File;
  infname,
  outfname : String[20];
  basename : String[8];
  ReadFont : PRFontObj;
  Desc_str : String[41];
  x        : Word;
  numstr   : String[10];

Function Open_PRF_File : Boolean;
Var
  i : Word;
  s : String[50];
Begin
  Open_PRF_File := False;
  i := Pos('.', infname);
  If i = 0 Then
  Begin
    basename := infname;
    infname := infname + '.PRF';
  End
  Else
    Basename := Copy(infname, 1, i - 1);
  Assign(infile, infname);
  {$I-}Reset(infile, 1);{$I+}
  If IOResult <> 0 Then
    Exit;
  BlockRead(infile, s, 26);
  If s <> 'Powder River Font File' Then
    Exit;

  BlockRead(infile, desc_str, 42);
  With ReadFont Do
  Begin
    BlockRead(infile, Data, SizeOf(PRFDataHeader));
    GetMem(Data.CWidth, Data.NumberOfChar);
    BlockRead(infile, Data.CWidth^, Data.NumberOfChar);
    FontDataSize := Data.FontByteWidth * Data.FHeight * Data.NumberOfChar;
    GetMem(Data.FontData, FontDataSize);
    BlockRead(infile, Data.FontData^, FontDataSize);
  End;
  Close(infile);
  Open_PRF_File := True;
End;

Procedure WriteDescription;
Var
  combstr : String[80];
  numstr  : String[2];
Begin
  combstr := dbprefix;
  Str(Ord(desc_str[0]), numstr);
  combstr := combstr + '  ' + numstr + ', ''';
  combstr := combstr + desc_str + ''', 0, ''                     ''';
  WriteLn(outfile, combstr);
End;

Procedure WriteHeaderInfo;
Var
  bytestr  : String[20];
  wordstr  : String[20];
  numstr   : String[4];
Begin
  wordstr := dbprefix;
  wordstr[4] := 'w';
  wordstr := wordstr + '    ';
  bytestr := dbprefix + '    ';
  WriteLn(outfile, bytestr + 'BIT_MAPPED');
  Str(ReadFont.Data.NumberOfChar, numstr);
  WriteLn(outfile, wordstr + numstr);
  Str(ReadFont.Data.FirstChar, numstr);
  WriteLn(outfile, bytestr + numstr);
  Str(ReadFont.Data.LastChar, numstr);
  WriteLn(outfile, bytestr + numstr);
  Str(ReadFont.Data.WidestChar, numstr);
  WriteLn(outfile, bytestr + numstr);
  Str(ReadFont.Data.FontByteWidth, numstr);
  WriteLn(outfile, bytestr + numstr);
  Str(ReadFont.Data.FHeight, numstr);
  WriteLn(outfile, bytestr + numstr);

  WriteLn(outfile, wordstr + 'OFFSET fwidth');
  WriteLn(outfile, wordstr + 'SEG fwidth');
  WriteLn(outfile, '  dd    ?');
  WriteLn(outfile, wordstr + 'OFFSET fdata');
  WriteLn(outfile, wordstr + 'SEG fdata');
  WriteLn(outfile);
End;

Procedure WriteWidthTable;
Var
  bytestr : String[20];
  numstr  : String[4];
  x       : Word;
  bptr    : BytePtr;
  counter : Word;
Begin
  bytestr := dbprefix + '    ';
  bptr := BytePtr(ReadFont.Data.CWidth);
  WriteLn(outfile, 'fwidth:');
  counter := ReadFont.Data.FirstChar;
  For x := 1 To ReadFont.Data.NumberOfChar Do
  Begin
    Str(bptr^, numstr);
    Write(outfile, bytestr + numstr);
    Write(outfile, '    #');
    str(counter, numstr);
    WriteLn(outfile, numstr);
    Inc(bptr);
    Inc(counter);
  End;
  WriteLn(outfile);
End;

Const
  Digits : Array[0..$F] Of Char = '0123456789ABCDEF';

Function BinaryB(B : Byte) : String;
{-Return binary string for byte}
Var
  I, N : Word;
Begin
  N := 1;
  BinaryB[0] := #8;
  For I := 7 Downto 0 Do
  Begin
    BinaryB[N] := Digits[Ord(B and (1 shl I) <> 0)]; {0 or 1}
    Inc(N);
  End;
End;

Procedure WriteDataTable;
Var
  outstr  : String[80];
  numstr  : String[15];
  bytestr : String[20];
  bptr    : BytePtr;
  i, h, w : Word;
  charnum : Word;
Begin
  bytestr := dbprefix + '    ';
  bptr := BytePtr(ReadFont.Data.FontData);
  charnum := ReadFont.Data.FirstChar;
  WriteLn(outfile, 'fdata:');
  For i := 1 To ReadFont.Data.NumberOfChar Do
  Begin
    Str(charnum, numstr);
    outstr := ';  #' + numstr + '  ';
    If Charnum <> 26 Then
      outstr := outstr + Chr(charnum);
    WriteLn(outfile, outstr);
    For h := 1 To ReadFont.Data.FHeight Do
    Begin
      outstr := bytestr;
      For w := 1 To ReadFont.Data.FontByteWidth Do
      Begin
        numstr := BinaryB(bptr^) + 'b';
        outstr := outstr + numstr;
        If w <> ReadFont.Data.FontByteWidth Then
          outstr := outstr + ', ';
        Inc(bptr);
      End;
      WriteLn(outfile, outstr);
    End;
    Inc(charnum);
    WriteLn(outfile);
  End;
  WriteLn(outfile);
End;

BEGIN
  If ParamCount < 1 Then
  Begin
    WriteLn('USAGE: SDF2ASM <filename>');
    WriteLn('where filename is the name of the PRF file to process.');
    Exit;
  End;
  infname := Paramstr(1);
  If Not Open_PRF_File Then
  Begin
    WriteLn;
    WriteLn('Cannot Open ', infname, '. Exiting');
    Halt(1);
  End;
  outfname := basename + '.ASM';
  Assign(outfile, outfname);
  Rewrite(outfile);
  For x := 1 To 6 Do
    WriteLn(outfile, asmheader[x]);
  WriteLn(outfile);
  WriteDescription;
  WriteLn(outfile, 'PUBLIC ' + basename);
  WriteLn(outfile, basename + ':');
  WriteHeaderInfo;
  WriteWidthTable;
  WriteDataTable;
  WriteLn(outfile, 'END');
  Close(outfile);
END.
