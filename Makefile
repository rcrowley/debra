VERSION=0.2.7-1

prefix=/usr/local
bindir=${prefix}/bin
mandir=${prefix}/share/man

all:
	@true

install:
	install -d $(DESTDIR)$(bindir)
	install \
		bin/debra bin/debra-* \
		bin/sourceinstall \
		$(DESTDIR)$(bindir)/
	install -d $(DESTDIR)$(mandir)/man1
	install -m644 \
		man/man1/debra.1 \
		man/man1/debra-*.1 \
		man/man1/sourceinstall.1 \
		$(DESTDIR)$(mandir)/man1/
 
uninstall:
	rm -f \
		$(DESTDIR)$(bindir)/debra \
		$(DESTDIR)$(bindir)/debra-* \
		$(DESTDIR)$(bindir)/sourceinstall \
		$(DESTDIR)$(mandir)/man1/debra.1 \
		$(DESTDIR)$(mandir)/man1/debra-*.1 \
		$(DESTDIR)$(mandir)/man1/sourceinstall.1

deb:
	[ "$$(whoami)" = "root" ] || false
	m4 -D__VERSION__=$(VERSION) control.m4 >control
	bin/debra create debian control
	make install DESTDIR=debian prefix=/usr
	chown -R root:root debian
	bin/debra build debian debra_$(VERSION)_all.deb
	bin/debra destroy debian

man:
	find man -name \*.ronn | xargs -n1 ronn --manual=Debra --style=toc

gh-pages: man
	mkdir -p gh-pages
	find man -name \*.html | xargs -I__ mv __ gh-pages/
	git checkout -q gh-pages
	cp -R gh-pages/* ./
	rm -rf gh-pages
	git add .
	git commit -m "Rebuilt manual."
	git push origin gh-pages
	git checkout -q master

.PHONY: all install uninstall deb man gh-pages
