# you need the xpl library
XPL = ~/x/code
FPC = fpc -Mobjfpc -Fu$(XPL) -Fi$(XPL) \
          -Fi./other -Fu./other -Fu./old_u \
	  -gl

targets:
	@echo
	@echo 'available targets:'
	@echo
	@echo '  test    : run test cases'
	@echo '  clean   : delete compiled binaries and backup files'
	@echo
	@echo 'also:'
	@echo '   bin/%   : compiles apps/%.pas'
	@echo '   tmp/%   : compiles work/%.pas'
	@echo

apps: bin/cedit bin/cp437-to-utf8

bin/%: apps/%.pas always
	@mkdir -p bin
	$(FPC) -gl -B -FE./bin $<

tmp/%: work/%.pas always
	@mkdir -p tmp
	$(FPC) -gl -FE./tmp $<

clean:
	@delp . apps work
	@rm -f bin/*
	@rm -f tmp/*

.PHONY: always

#-- work ( legacy code ) ---------------------

zmenu: tmp/zmenu
	tmp/zmenu
ymenu: tmp/ymenu
xmenu: tmp/xmenu
life:  tmp/life
doth:  tmp/doth_2
dmm:   tmp/dmm
adl:   tmp/adl

#-- apps ( modern / refactored ) --------------

cedit: bin/cedit
	@bin/cedit README.org

