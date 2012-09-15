program databook;

uses crtstuff, zokstuff, crt, filstuff;

type
 phonerec = record
  last, first : string[30];
  middle : char;
  ad1, ad2 : string[ 40 ];
  city : string[ 30 ];
  state : string[2];
  zip : string[9];
  phone: string[15];
  handle : string[30];
  note1, note2, note3 : string[ 70 ];
 end;
 phonebook = file of phonerec;

{$I dbscr.PAS}

var
 data : phonebook;

begin
 setupcrt;
 screen := screentype( dbscr );
 getenter;
end.