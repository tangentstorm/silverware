B4  = ~/b
PROGS = ./progs
CLEAN = ./clean
OTHER = ./other
FPC = fpc  -Mobjfpc  -FE./bin -Fu$(B4) -Fi$(B4) \
	   -Fu./units -Fi/other. -Fu./clean \
	   -gl

default: cedit

bin/%.ppu: $(CLEAN)/%.pas
	@mkdir -p bin
	$(FPC) $<

bin/%: $(PROGS)/%.pas
	@mkdir -p bin
	$(FPC) $<



cleanup:
	@rm -f *~ *.gpi *.o *.pyc
	@rm -f bin/*

test:
	echo "no tests yet... :("

#-- units -------------------------------------

ll:   bin/ll.ppu
cw:   bin/cw.ppu
fs:   bin/fs.ppu       stri
stri: bin/stri.ppu
num:  bin/num.ppu

#-- progs -------------------------------------

cedit: bin/cedit   cw fs ll num stri
	@bin/cedit README.org
	@echo ok

