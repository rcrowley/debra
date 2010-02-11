PREFIX=/usr/local
 
all:
	@echo "Nothing to do, maybe you wanted to make install?" >&2
 
install:
	install -c bin/sourceinstall $(PREFIX)/bin/
	install -c bin/debra $(PREFIX)/bin/
 
uninstall:
	rm $(PREFIX)/bin/sourceinstall $(PREFIX)/bin/debra
