
type
 Things =  ( Hero, Grass, Wall, Water, Box, Door, Scroll, TLast );
 ThingRec = Record
              Name : String[15];
              At : Byte;
              Token  : String;
              MGld : Word;
              MLif : Integer;
              Pathlength,
              PathPointer : byte;
              Path : String;
            end;

Const
  ThingArray : array[Ord(Hero)..Ord(TLast)] of ThingRec =
  ( ( Name: 'Hero';   At: $0E; Token: #2 ),
    ( Name: 'Grass';  At: $2A; Token: '.'),
    ( Name: 'Wall';   At: $08; Token: '²'),
    ( Name: 'Water';  At: $1F; Token: '                                   '+
            '                                                           -_'),
    ( Name: 'Box';    At: $0C; Token: 'þ'),
    ( Name: 'Door';   At: $0F; Token: 'ï'),
    ( Name: 'Scroll'; At: $09; Token: '÷'),
    ( Name: 'Last' ) );

