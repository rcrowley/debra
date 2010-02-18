ARCH=amd64
RUBY=ftp://ftp.ruby-lang.org/pub/ruby
RUBYFORGE=http://rubyforge.org/frs/download.php

apt-get -y install libssl-dev libreadline5-dev zlib1g-dev

for VERSION in 1.8.7-p249 1.9.1-p378; do
	DESTDIR=/tmp/ruby-$VERSION-$$
	V=$(echo $VERSION | sed -r 's/^([0-9]+\.[0-9]+).*$/\1/')

	debra create $DESTDIR

	cat <<EOF >$DESTDIR/DEBIAN/control
Package: opt-ruby-$VERSION
Version: $VERSION-1
Section: devel
Priority: optional
Essential: no
Architecture: amd64
Depends: libc6, libssl0.9.8, libreadline5, zlib1g
Maintainer: Richard Crowley <r@rcrowley.org>
Description: Standalone Ruby $VERSION.  This installation includes RubyGems.
EOF

	# Install Ruby itself.
	if [ 1.8 = $V ]; then
		BOOTSTRAP="sh -c 'echo fcntl\\\nreadline\\\nzlib >ext/Setup'"
	else
		BOOTSTRAP="sh -c 'echo fcntl\\\nopenssl\\\nreadline\\\nzlib >ext/Setup'"
	fi
	debra sourceinstall $DESTDIR $RUBY/$V/ruby-$VERSION.tar.gz \
		-b "$BOOTSTRAP"

	# Get set to install RubyGems from DEBIAN/postinst.
	# FIXME The resulting package will be unable to uninstall itself.
	mkdir $DESTDIR/tmp
	(cd $DESTDIR/tmp && wget $RUBYFORGE/60718/rubygems-1.3.5.tgz)
	cat <<EOF >$DESTDIR/DEBIAN/postinst
#!/bin/sh
case "\$1" in
	configure)
		(cd /tmp && tar xf rubygems-1.3.5.tgz)
		(cd /tmp/rubygems-1.3.5 && /opt/ruby-$VERSION/bin/ruby setup.rb)
		rm -rf /tmp/rubygems-1.3.5 /tmp/rubygems-1.3.5.tgz
		;;
	abort-upgrade)
		;;
	abort-remove)
		;;
	abort-deconfigure)
		;;
	*)
		;;
esac
exit 0
EOF

	# Build a Debian package.
	debra build $DESTDIR opt-ruby-${VERSION}_${VERSION}-1_$ARCH.deb

	debra destroy $DESTDIR
done
