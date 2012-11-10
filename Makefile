FPC = fpc -Fu./units -Fi/other. -Mobjfpc  -FE./bin
PROGS = ./progs
UNITS = ./units
OTHER = ./other

cedit: pntstuff crtstuff filstuff zokstuff crt  bin/cedit

bin/%: $(PROGS)/%.pas
	$(FPC) $<

#---------------------------------------

pntstuff: $(UNITS)/pntstuff.pas
crtstuff: $(UNITS)/crtstuff.pas
filstuff: $(UNITS)/filstuff.pas
zokstuff: $(UNITS)/zokstuff.pas
crt:

#---------------------------------------

clean:
	rm *~ *.gpi *.o *.pyc

test:
	echo "no tests yet... :("
