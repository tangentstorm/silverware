Program PigLatin;
Uses Crt;

Function IsVowel( Ch : Char ) : Boolean;
 Begin
   Ch := UpCase(Ch);
   IsVowel := (Ch = 'A') or (Ch = 'E') or
              (Ch = 'I') or (Ch = 'O') or
              (Ch = 'U');

 End;

Begin
End.