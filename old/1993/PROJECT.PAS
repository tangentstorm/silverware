Program Project;

{ The Project BBS (c)1993 ÄSÅîâL³NGÄS³LVîâWêâîÄ }

uses
 crtstuff;

{- general stuff -}

const
 success = true;
 failure = false;

procedure pwriteln( s : string );
 begin
  cwriteln( '!|k|WpWrite|w:@' + s );
 end;

type
 tasks = (asdf,wer,wee );

{- line object -}

type
 lineobj = object
  task : tasks;
 end;

{- main program -}

Begin
End.