B4  = ~/b
PROGS = ./progs
UNITS = ./clean
OTHER = ./other
FPC = fpc  -Mobjfpc  -FE./bin -Fu$(B4) -Fi$(B4) \
	   -Fu./units -Fi/other. -Fu./clean

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
num:  bin/num.ppu

#-- progs -------------------------------------

cedit: ll fs num bin/cedit
	@bin/cedit Makefile
	@echo ok

