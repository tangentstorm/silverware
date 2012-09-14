PROGRAM Atype;

   USES
      ANSIIO,
      DOS,
      CRT;

   VAR
      F : text;
      S, L : string;
      Ch : char;
      i : integer;
      Rec : searchrec;

   FUNCTION PathOnly(p1 : string) : string;
      VAR
         s, p : string;
         i, t : integer;
      BEGIN
         p := p1;
         i := 0;
         REPEAT
            t := i;
            i := pos('\',p);
            IF i > 0 THEN
               p[i] := '|';
         UNTIL i = 0;
         IF t = 0 THEN
            t := pos(':',p);
         p1 := copy(p1,1,t);
         IF length(p1) > 2 THEN
            IF p1[length(p1)] <> '\' THEN
               p1 := p1+'\';
         PathOnly := p1;
      END;

   BEGIN
      IF ParamCount < 1 then
         BEGIN
            writeln;
            writeln('Usage : ATYPE file1 file2 file3 ...',
                    '                       (Wildcards are OK)');
            EXIT;
         END;
{$I-} FOR i := 1 to ParamCount DO
         BEGIN
            s := PathOnly(ParamStr(i));
            FindFirst(ParamStr(i),AnyFile,Rec);
            WHILE DosError = 0 do
               BEGIN
                  assign(f,s+Rec.name);
                  reset(f);
                  WHILE (not eof(f)) and (IOResult = 0) do
                     BEGIN
                        readln(f,l);
                        ANSIWriteln(l);
                     END;
                  close(f);
                  While KeyPressed do
                     ch := readkey;
                  Repeat until KeyPressed;
                  FindNext(Rec);
               END;
         END;
{$I+}
   END.
