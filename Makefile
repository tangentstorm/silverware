# XPL will be downloaded automatically when you run make
XPL = ./lib/xpl/code
FPC = fpc -Mobjfpc -Fu$(XPL) -Fi$(XPL) \
          -Fi./other -Fu./other -Fu./old_u \
	  -gl

targets: init
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

init:
	@mkdir -p bin
	@mkdir -p tmp
	@git submodule init
	@git submodule update

apps: bin/cedit bin/cp437-to-utf8

bin/%: apps/%.pas always init
	$(FPC) -gl -B -FE./bin $<

tmp/%: work/%.pas always init
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

