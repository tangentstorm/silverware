XPL = ~/x/code
FPC = fpc -Mobjfpc  -FE./bin -Fu$(XPL) -Fi$(XPL) \
          -Fi./other. -Fu./units -Fu./old_u \
	  -gl

default: cedit

bin/%.ppu: /%.pas
	@mkdir -p bin
	$(FPC) $<

bin/%: progs/%.pas
	@mkdir -p bin
	$(FPC) -gl $<

clean:
	@rm -f *~ *.gpi *.o *.pyc
	@rm -f bin/*


test: always run-tests
	@bin/run-tests
run-tests: test/*.pas units/*.pas
	cd test; python gen-tests.py
	@$(FPC) test/run-tests.pas

always:

#-- units -------------------------------------

ll:   bin/ll.ppu
cw:   bin/cw.ppu
fs:   bin/fs.ppu    stri
stri: bin/stri.ppu
num:  bin/num.ppu

#-- progs -------------------------------------

cedit: bin/cedit   cw fs ll num stri
	@bin/cedit README.org
	@echo ok
