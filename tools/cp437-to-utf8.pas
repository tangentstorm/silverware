{$mode objfpc}
program cp437_to_utf8; { transcode cp437 text to utf-8
----------------------------------------------------------------

Codepage 437 was the default IBM PC / MS-DOS character set in
the united states. Byte values 32-127 implement the standard
7-bit ascii character set. The other values mapped to a bunch
of mathematical symbols and european characters:

  http://en.wikipedia.org/wiki/Code_page_437

this program updates cp437-encoded text files, replacing each
special character with its utf-8 equivalent, based on the table
available here:

 http://unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP437.TXT
			 ----------------------------------------------------------------
Copyright (c) 2012, Michal J. Wallace - http://tangentstorm.com/

Permission to use, copy, modify, and/or distribute this software
for any purpose with or without fee is hereby granted, provided
that the above copyright notice and this permission notice
appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
---------------------------------------------------------------}

  const tr : array[ byte ] of cardinal = (
  //
  //    Name		: cp437_DOSLatinUS to Unicode table
  //    Unicode version	: 2.0
  //    Table version	: 2.00
  //    Table format	: Format A
  //    Date		: 04/24/96
  //    Contact		: Shawn.Steele@microsoft.com
  //
  //    General notes	: none
  //
  //    Format		: Three tab-separated columns
  //        Column #1 is the cp437_DOSLatinUS code (in hex)
  //        Column #2 is the Unicode (in hex as $XXXX)
  //        Column #3 is the Unicode name (follows a comment sign, '#')
  //
  //    The entries are in cp437_DOSLatinUS order
  //
  { $00 } $0000, // NULL
  { $01 } $0001, // START OF HEADING
  { $02 } $0002, // START OF TEXT
  { $03 } $0003, // END OF TEXT
  { $04 } $0004, // END OF TRANSMISSION
  { $05 } $0005, // ENQUIRY
  { $06 } $0006, // ACKNOWLEDGE
  { $07 } $0007, // BELL
  { $08 } $0008, // BACKSPACE
  { $09 } $0009, // HORIZONTAL TABULATION
  { $0a } $000a, // LINE FEED
  { $0b } $000b, // VERTICAL TABULATION
  { $0c } $000c, // FORM FEED
  { $0d } $000d, // CARRIAGE RETURN
  { $0e } $000e, // SHIFT OUT
  { $0f } $000f, // SHIFT IN
  { $10 } $0010, // DATA LINK ESCAPE
  { $11 } $0011, // DEVICE CONTROL ONE
  { $12 } $0012, // DEVICE CONTROL TWO
  { $13 } $0013, // DEVICE CONTROL THREE
  { $14 } $0014, // DEVICE CONTROL FOUR
  { $15 } $0015, // NEGATIVE ACKNOWLEDGE
  { $16 } $0016, // SYNCHRONOUS IDLE
  { $17 } $0017, // END OF TRANSMISSION BLOCK
  { $18 } $0018, // CANCEL
  { $19 } $0019, // END OF MEDIUM
  { $1a } $001a, // SUBSTITUTE
  { $1b } $001b, // ESCAPE
  { $1c } $001c, // FILE SEPARATOR
  { $1d } $001d, // GROUP SEPARATOR
  { $1e } $001e, // RECORD SEPARATOR
  { $1f } $001f, // UNIT SEPARATOR
  { $20 } $0020, // SPACE
  { $21 } $0021, // EXCLAMATION MARK
  { $22 } $0022, // QUOTATION MARK
  { $23 } $0023, // NUMBER SIGN
  { $24 } $0024, // DOLLAR SIGN
  { $25 } $0025, // PERCENT SIGN
  { $26 } $0026, // AMPERSAND
  { $27 } $0027, // APOSTROPHE
  { $28 } $0028, // LEFT PARENTHESIS
  { $29 } $0029, // RIGHT PARENTHESIS
  { $2a } $002a, // ASTERISK
  { $2b } $002b, // PLUS SIGN
  { $2c } $002c, // COMMA
  { $2d } $002d, // HYPHEN-MINUS
  { $2e } $002e, // FULL STOP
  { $2f } $002f, // SOLIDUS
  { $30 } $0030, // DIGIT ZERO
  { $31 } $0031, // DIGIT ONE
  { $32 } $0032, // DIGIT TWO
  { $33 } $0033, // DIGIT THREE
  { $34 } $0034, // DIGIT FOUR
  { $35 } $0035, // DIGIT FIVE
  { $36 } $0036, // DIGIT SIX
  { $37 } $0037, // DIGIT SEVEN
  { $38 } $0038, // DIGIT EIGHT
  { $39 } $0039, // DIGIT NINE
  { $3a } $003a, // COLON
  { $3b } $003b, // SEMICOLON
  { $3c } $003c, // LESS-THAN SIGN
  { $3d } $003d, // EQUALS SIGN
  { $3e } $003e, // GREATER-THAN SIGN
  { $3f } $003f, // QUESTION MARK
  { $40 } $0040, // COMMERCIAL AT
  { $41 } $0041, // LATIN CAPITAL LETTER A
  { $42 } $0042, // LATIN CAPITAL LETTER B
  { $43 } $0043, // LATIN CAPITAL LETTER C
  { $44 } $0044, // LATIN CAPITAL LETTER D
  { $45 } $0045, // LATIN CAPITAL LETTER E
  { $46 } $0046, // LATIN CAPITAL LETTER F
  { $47 } $0047, // LATIN CAPITAL LETTER G
  { $48 } $0048, // LATIN CAPITAL LETTER H
  { $49 } $0049, // LATIN CAPITAL LETTER I
  { $4a } $004a, // LATIN CAPITAL LETTER J
  { $4b } $004b, // LATIN CAPITAL LETTER K
  { $4c } $004c, // LATIN CAPITAL LETTER L
  { $4d } $004d, // LATIN CAPITAL LETTER M
  { $4e } $004e, // LATIN CAPITAL LETTER N
  { $4f } $004f, // LATIN CAPITAL LETTER O
  { $50 } $0050, // LATIN CAPITAL LETTER P
  { $51 } $0051, // LATIN CAPITAL LETTER Q
  { $52 } $0052, // LATIN CAPITAL LETTER R
  { $53 } $0053, // LATIN CAPITAL LETTER S
  { $54 } $0054, // LATIN CAPITAL LETTER T
  { $55 } $0055, // LATIN CAPITAL LETTER U
  { $56 } $0056, // LATIN CAPITAL LETTER V
  { $57 } $0057, // LATIN CAPITAL LETTER W
  { $58 } $0058, // LATIN CAPITAL LETTER X
  { $59 } $0059, // LATIN CAPITAL LETTER Y
  { $5a } $005a, // LATIN CAPITAL LETTER Z
  { $5b } $005b, // LEFT SQUARE BRACKET
  { $5c } $005c, // REVERSE SOLIDUS
  { $5d } $005d, // RIGHT SQUARE BRACKET
  { $5e } $005e, // CIRCUMFLEX ACCENT
  { $5f } $005f, // LOW LINE
  { $60 } $0060, // GRAVE ACCENT
  { $61 } $0061, // LATIN SMALL LETTER A
  { $62 } $0062, // LATIN SMALL LETTER B
  { $63 } $0063, // LATIN SMALL LETTER C
  { $64 } $0064, // LATIN SMALL LETTER D
  { $65 } $0065, // LATIN SMALL LETTER E
  { $66 } $0066, // LATIN SMALL LETTER F
  { $67 } $0067, // LATIN SMALL LETTER G
  { $68 } $0068, // LATIN SMALL LETTER H
  { $69 } $0069, // LATIN SMALL LETTER I
  { $6a } $006a, // LATIN SMALL LETTER J
  { $6b } $006b, // LATIN SMALL LETTER K
  { $6c } $006c, // LATIN SMALL LETTER L
  { $6d } $006d, // LATIN SMALL LETTER M
  { $6e } $006e, // LATIN SMALL LETTER N
  { $6f } $006f, // LATIN SMALL LETTER O
  { $70 } $0070, // LATIN SMALL LETTER P
  { $71 } $0071, // LATIN SMALL LETTER Q
  { $72 } $0072, // LATIN SMALL LETTER R
  { $73 } $0073, // LATIN SMALL LETTER S
  { $74 } $0074, // LATIN SMALL LETTER T
  { $75 } $0075, // LATIN SMALL LETTER U
  { $76 } $0076, // LATIN SMALL LETTER V
  { $77 } $0077, // LATIN SMALL LETTER W
  { $78 } $0078, // LATIN SMALL LETTER X
  { $79 } $0079, // LATIN SMALL LETTER Y
  { $7a } $007a, // LATIN SMALL LETTER Z
  { $7b } $007b, // LEFT CURLY BRACKET
  { $7c } $007c, // VERTICAL LINE
  { $7d } $007d, // RIGHT CURLY BRACKET
  { $7e } $007e, // TILDE
  { $7f } $007f, // DELETE
  { $80 } $00c7, // LATIN CAPITAL LETTER C WITH CEDILLA
  { $81 } $00fc, // LATIN SMALL LETTER U WITH DIAERESIS
  { $82 } $00e9, // LATIN SMALL LETTER E WITH ACUTE
  { $83 } $00e2, // LATIN SMALL LETTER A WITH CIRCUMFLEX
  { $84 } $00e4, // LATIN SMALL LETTER A WITH DIAERESIS
  { $85 } $00e0, // LATIN SMALL LETTER A WITH GRAVE
  { $86 } $00e5, // LATIN SMALL LETTER A WITH RING ABOVE
  { $87 } $00e7, // LATIN SMALL LETTER C WITH CEDILLA
  { $88 } $00ea, // LATIN SMALL LETTER E WITH CIRCUMFLEX
  { $89 } $00eb, // LATIN SMALL LETTER E WITH DIAERESIS
  { $8a } $00e8, // LATIN SMALL LETTER E WITH GRAVE
  { $8b } $00ef, // LATIN SMALL LETTER I WITH DIAERESIS
  { $8c } $00ee, // LATIN SMALL LETTER I WITH CIRCUMFLEX
  { $8d } $00ec, // LATIN SMALL LETTER I WITH GRAVE
  { $8e } $00c4, // LATIN CAPITAL LETTER A WITH DIAERESIS
  { $8f } $00c5, // LATIN CAPITAL LETTER A WITH RING ABOVE
  { $90 } $00c9, // LATIN CAPITAL LETTER E WITH ACUTE
  { $91 } $00e6, // LATIN SMALL LIGATURE AE
  { $92 } $00c6, // LATIN CAPITAL LIGATURE AE
  { $93 } $00f4, // LATIN SMALL LETTER O WITH CIRCUMFLEX
  { $94 } $00f6, // LATIN SMALL LETTER O WITH DIAERESIS
  { $95 } $00f2, // LATIN SMALL LETTER O WITH GRAVE
  { $96 } $00fb, // LATIN SMALL LETTER U WITH CIRCUMFLEX
  { $97 } $00f9, // LATIN SMALL LETTER U WITH GRAVE
  { $98 } $00ff, // LATIN SMALL LETTER Y WITH DIAERESIS
  { $99 } $00d6, // LATIN CAPITAL LETTER O WITH DIAERESIS
  { $9a } $00dc, // LATIN CAPITAL LETTER U WITH DIAERESIS
  { $9b } $00a2, // CENT SIGN
  { $9c } $00a3, // POUND SIGN
  { $9d } $00a5, // YEN SIGN
  { $9e } $20a7, // PESETA SIGN
  { $9f } $0192, // LATIN SMALL LETTER F WITH HOOK
  { $a0 } $00e1, // LATIN SMALL LETTER A WITH ACUTE
  { $a1 } $00ed, // LATIN SMALL LETTER I WITH ACUTE
  { $a2 } $00f3, // LATIN SMALL LETTER O WITH ACUTE
  { $a3 } $00fa, // LATIN SMALL LETTER U WITH ACUTE
  { $a4 } $00f1, // LATIN SMALL LETTER N WITH TILDE
  { $a5 } $00d1, // LATIN CAPITAL LETTER N WITH TILDE
  { $a6 } $00aa, // FEMININE ORDINAL INDICATOR
  { $a7 } $00ba, // MASCULINE ORDINAL INDICATOR
  { $a8 } $00bf, // INVERTED QUESTION MARK
  { $a9 } $2310, // REVERSED NOT SIGN
  { $aa } $00ac, // NOT SIGN
  { $ab } $00bd, // VULGAR FRACTION ONE HALF
  { $ac } $00bc, // VULGAR FRACTION ONE QUARTER
  { $ad } $00a1, // INVERTED EXCLAMATION MARK
  { $ae } $00ab, // LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
  { $af } $00bb, // RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
  { $b0 } $2591, // LIGHT SHADE
  { $b1 } $2592, // MEDIUM SHADE
  { $b2 } $2593, // DARK SHADE
  { $b3 } $2502, // BOX DRAWINGS LIGHT VERTICAL
  { $b4 } $2524, // BOX DRAWINGS LIGHT VERTICAL AND LEFT
  { $b5 } $2561, // BOX DRAWINGS VERTICAL SINGLE AND LEFT DOUBLE
  { $b6 } $2562, // BOX DRAWINGS VERTICAL DOUBLE AND LEFT SINGLE
  { $b7 } $2556, // BOX DRAWINGS DOWN DOUBLE AND LEFT SINGLE
  { $b8 } $2555, // BOX DRAWINGS DOWN SINGLE AND LEFT DOUBLE
  { $b9 } $2563, // BOX DRAWINGS DOUBLE VERTICAL AND LEFT
  { $ba } $2551, // BOX DRAWINGS DOUBLE VERTICAL
  { $bb } $2557, // BOX DRAWINGS DOUBLE DOWN AND LEFT
  { $bc } $255d, // BOX DRAWINGS DOUBLE UP AND LEFT
  { $bd } $255c, // BOX DRAWINGS UP DOUBLE AND LEFT SINGLE
  { $be } $255b, // BOX DRAWINGS UP SINGLE AND LEFT DOUBLE
  { $bf } $2510, // BOX DRAWINGS LIGHT DOWN AND LEFT
  { $c0 } $2514, // BOX DRAWINGS LIGHT UP AND RIGHT
  { $c1 } $2534, // BOX DRAWINGS LIGHT UP AND HORIZONTAL
  { $c2 } $252c, // BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
  { $c3 } $251c, // BOX DRAWINGS LIGHT VERTICAL AND RIGHT
  { $c4 } $2500, // BOX DRAWINGS LIGHT HORIZONTAL
  { $c5 } $253c, // BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
  { $c6 } $255e, // BOX DRAWINGS VERTICAL SINGLE AND RIGHT DOUBLE
  { $c7 } $255f, // BOX DRAWINGS VERTICAL DOUBLE AND RIGHT SINGLE
  { $c8 } $255a, // BOX DRAWINGS DOUBLE UP AND RIGHT
  { $c9 } $2554, // BOX DRAWINGS DOUBLE DOWN AND RIGHT
  { $ca } $2569, // BOX DRAWINGS DOUBLE UP AND HORIZONTAL
  { $cb } $2566, // BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL
  { $cc } $2560, // BOX DRAWINGS DOUBLE VERTICAL AND RIGHT
  { $cd } $2550, // BOX DRAWINGS DOUBLE HORIZONTAL
  { $ce } $256c, // BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL
  { $cf } $2567, // BOX DRAWINGS UP SINGLE AND HORIZONTAL DOUBLE
  { $d0 } $2568, // BOX DRAWINGS UP DOUBLE AND HORIZONTAL SINGLE
  { $d1 } $2564, // BOX DRAWINGS DOWN SINGLE AND HORIZONTAL DOUBLE
  { $d2 } $2565, // BOX DRAWINGS DOWN DOUBLE AND HORIZONTAL SINGLE
  { $d3 } $2559, // BOX DRAWINGS UP DOUBLE AND RIGHT SINGLE
  { $d4 } $2558, // BOX DRAWINGS UP SINGLE AND RIGHT DOUBLE
  { $d5 } $2552, // BOX DRAWINGS DOWN SINGLE AND RIGHT DOUBLE
  { $d6 } $2553, // BOX DRAWINGS DOWN DOUBLE AND RIGHT SINGLE
  { $d7 } $256b, // BOX DRAWINGS VERTICAL DOUBLE AND HORIZONTAL SINGLE
  { $d8 } $256a, // BOX DRAWINGS VERTICAL SINGLE AND HORIZONTAL DOUBLE
  { $d9 } $2518, // BOX DRAWINGS LIGHT UP AND LEFT
  { $da } $250c, // BOX DRAWINGS LIGHT DOWN AND RIGHT
  { $db } $2588, // FULL BLOCK
  { $dc } $2584, // LOWER HALF BLOCK
  { $dd } $258c, // LEFT HALF BLOCK
  { $de } $2590, // RIGHT HALF BLOCK
  { $df } $2580, // UPPER HALF BLOCK
  { $e0 } $03b1, // GREEK SMALL LETTER ALPHA
  { $e1 } $00df, // LATIN SMALL LETTER SHARP S
  { $e2 } $0393, // GREEK CAPITAL LETTER GAMMA
  { $e3 } $03c0, // GREEK SMALL LETTER PI
  { $e4 } $03a3, // GREEK CAPITAL LETTER SIGMA
  { $e5 } $03c3, // GREEK SMALL LETTER SIGMA
  { $e6 } $00b5, // MICRO SIGN
  { $e7 } $03c4, // GREEK SMALL LETTER TAU
  { $e8 } $03a6, // GREEK CAPITAL LETTER PHI
  { $e9 } $0398, // GREEK CAPITAL LETTER THETA
  { $ea } $03a9, // GREEK CAPITAL LETTER OMEGA
  { $eb } $03b4, // GREEK SMALL LETTER DELTA
  { $ec } $221e, // INFINITY
  { $ed } $03c6, // GREEK SMALL LETTER PHI
  { $ee } $03b5, // GREEK SMALL LETTER EPSILON
  { $ef } $2229, // INTERSECTION
  { $f0 } $2261, // IDENTICAL TO
  { $f1 } $00b1, // PLUS-MINUS SIGN
  { $f2 } $2265, // GREATER-THAN OR EQUAL TO
  { $f3 } $2264, // LESS-THAN OR EQUAL TO
  { $f4 } $2320, // TOP HALF INTEGRAL
  { $f5 } $2321, // BOTTOM HALF INTEGRAL
  { $f6 } $00f7, // DIVISION SIGN
  { $f7 } $2248, // ALMOST EQUAL TO
  { $f8 } $00b0, // DEGREE SIGN
  { $f9 } $2219, // BULLET OPERATOR
  { $fa } $00b7, // MIDDLE DOT
  { $fb } $221a, // SQUARE ROOT
  { $fc } $207f, // SUPERSCRIPT LATIN SMALL LETTER N
  { $fd } $00b2, // SUPERSCRIPT TWO
  { $fe } $25a0, // BLACK SQUARE
  { $ff } $00a0  // NO-BREAK SPACE
  );

  const gr : array[ 0 .. 31 ] of cardinal = (
    $0000, $263a, $263B, $2665,    $2666, $2663, $2660, $2022,
    $25D8, $25CB, $25D9, $2642,    $2640, $266A, $266b, $263c,
    $25BA, $25C4, $2195, $203C,    $00B6, $00A7, $25AC, $21A8,
    $2191, $2193, $2192, $2190,    $221F, $2194, $25B2, $25BC
  );

  { highest code in cp437 is $25a0 ( #$fe - the black square ),
    or ($266b - the eigth note) if you treat 0..31 as graphical.
    either way, you need 3 bytes to encode the highest value }
  type utf8 = string[ 3 ];


  function encode( u : cardinal ) : utf8;
  begin
    // http://www.herongyang.com/Unicode/UTF-8-UTF-8-Encoding-Algorithm.html
    case u of
         0 ..   $7f : result := '' + chr( u );
       $80 ..  $7ff : result := '' + chr( u shr  6 and $1F or $c0 )
				   + chr( u        and $3F or $80 );
      $800 .. $ffff : result := '' + chr( u shr 12 and $1F or $e0 )
				   + chr( u shr  6 and $3F or $80 )
				   + chr( u        and $3F or $80 );
      else begin
	writeln('outside cp437 range!');
	halt
      end
    end
  end;

  function transcode( ch : char; graphical : boolean) : utf8;
    var u : cardinal;
  begin
    u := tr[ ord( ch )];
    if graphical then
      case ch of
	#0 .. #31 : u := gr[ ord( ch )];
	#127      : u := $2302;
	else // pass
      end;
    result := encode( u );
  end;

  var ch : char; u : cardinal = 0; i, j : byte; usegr : boolean = false;
begin
  if paramstr( 1 ) = '--high' then begin
    for i := 0 to 255 do if tr[ i ] > u then u := tr[ i ];
    writeln( 'highest code is: ', u );
  end
  else if paramstr( 1 ) = '--chars' then begin
    for i := 0 to 15 do begin
      for j := 0 to 16 do begin
	write( transcode( chr( i * 16 + j ), true ))
      end;
      writeln;
    end
  end
  else begin
    if paramstr( 1 ) = '--graphic' then usegr := true;
    while not eof do begin
      read( ch );
      write( transcode( ch, usegr ))
    end
  end
end.
