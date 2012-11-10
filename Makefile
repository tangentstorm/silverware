FPC = fpc -Fu./units -Fi/other. -Mobjfpc  -FE./bin
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

#-- progs -------------------------------------

cedit: ll bin/cedit
	@bin/cedit Makefile
	@echo ok

