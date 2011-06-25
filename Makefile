VERSION=0.2.9
BUILD=2

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
	m4 -D__VERSION__=$(VERSION)-$(BUILD) control.m4 >control
	bin/debra create debian control
	make install DESTDIR=debian prefix=/usr
	chown -R root:root debian
	bin/debra build debian debra_$(VERSION)-$(BUILD)_all.deb
	bin/debra destroy debian

deploy:
	scp -i ~/production.pem debra_$(VERSION)-$(BUILD)_all.deb ubuntu@packages.devstructure.com:
	ssh -i ~/production.pem -t ubuntu@packages.devstructure.com "sudo freight add debra_$(VERSION)-$(BUILD)_all.deb apt/lenny apt/squeeze apt/lucid apt/maverick apt/natty && rm debra_$(VERSION)-$(BUILD)_all.deb && sudo freight cache apt/lenny apt/squeeze apt/lucid apt/maverick apt/natty"

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

.PHONY: all install uninstall deb deploy man gh-pages
