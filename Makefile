B4  = ~/b
FPC = fpc -Fu./units -Fi/other. -Mobjfpc  -FE./bin -Fu$(B4) -Fi$(B4)
PROGS = ./progs
UNITS = ./clean
OTHER = ./other

default: cedit

bin/%.ppu: $(UNITS)/%.pas
	$(FPC) $<

bin/%: $(PROGS)/%.pas
	$(FPC) $<


clean:
	rm *~ *.gpi *.o *.pyc

test:
	echo "no tests yet... :("

#-- units -------------------------------------

ll: bin/ll.ppu
fs: stri bin/fs.ppu
stri: bin/stri.ppu

#-- progs -------------------------------------

cedit: ll fs bin/cedit
	@bin/cedit Makefile
	@echo ok

