Program HyperText;

(***********************************************

 *.HYP:

  filerewrite( thisfile, filename );
  saveword( thisfile, word('HT') );
  saveword( thisfile, number_of_pages );
  saveword( thisfile, number_of_notes );
  offset := filepos( thisfile );
  for x := 0 to number_of_pages do { 0 is title page }
   savelongint( thisfile, 0 ); { reserve space for page index }
  for x := 0 to number_of_notes do { 0 is title (copywrite) note }
   savelongint( thisfile, 0 ); { reserve space for note index }
  for x := 0 to number_of_pages do { 0 is title page }
   begin
    fpos := filepos;
    seek( thisfile, offset + x * sizeof( longint ) );
    savelongint( thisfile, fpos ); { update index }
    seek( thisfile, fpos );
    savebyte( thisfile, change_to_next[ x ] ); { screen changing code }
    savebyte( thisfile, change_to_last[ x ] ); { screen changing code }
    savelongint( thisfile, sizeof( page[ x ] ) );
    saverec( thisfile, page[ x ], sizeof( page[ x ] ) );
   end;
  offset := filepos( thisfile, offset + x * sizeof( longint ));
  for x := 0 to number_of_notes do { 0 is title (copywrite) note }
   begin
    fpos := filepos;
    seek( thisfile, offset + x * sizeof( longint ) );
    savelongint( thisfile, fpos ); { update index }
    seek( thisfile, fpos );
    savestring( thisfile, notes[ x ] );
   end;
  close( thisfile );

***********************************************)

begin
end.