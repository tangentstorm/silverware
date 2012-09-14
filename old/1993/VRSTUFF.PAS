Unit VRStuff;
{ VRStuff (c) 1993 ƒS≈Ó‚L≥NGƒS≥LVÓ‚WÍ‚Óƒ       }
{ Unit for Text-Based Virtual Reality Programs }

Interface

 Type
  Skeg = 0 .. 31;
  Types = ( Player, Character, Thing, Feature, Undefined, Scene );
  SubTypes = ( Money, Strategic, Container, Scroll, Potion, Goody,
               Food, Weapon, Armour, UndefinedSub );
  Attributes = ( Strength, Health, Magic, Limit, Size, Weight );
  Flags      = ( AllowLock, Locked, AllowOpen, Opened, AllowHold, Holding );
  Link = Record
   LinkType  : byte;
   LinkedTo  : word;
   LinkValue : skeg;
  end;
  Base = Object
   A : array[ Strength .. Weight ] of Shortint;
   U1,U2,U3 : array[ 0 .. 31 ] of shortint;
   F : array[ AllowLock .. Holding ] of Boolean;
   L : array[ 0 .. 31 ] of link;
  end;

Implementation

End.