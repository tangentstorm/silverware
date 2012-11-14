# you need the xpl library
XPL = ~/x/code
FPC = fpc -Mobjfpc -Fu$(XPL) -Fi$(XPL) \
          -Fi./other. -Fu./units -Fu./old_u \
	  -gl

default: zmenu
always:

apps: bin/cedit bin/cp437-to-utf8

bin/%: apps/%.pas
	@mkdir -p bin
	$(FPC) -gl -FE./bin $<

tmp/%: progs/%.pas
	@mkdir -p tmp
	$(FPC) -gl -FE./tmp $<

clean:
	@delp . apps progs
	@rm -f bin/*
	@rm -f tmp/*

#-- progs ( legacy code ) ---------------------

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

