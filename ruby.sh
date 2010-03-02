ARCH=amd64
RUBY=ftp://ftp.ruby-lang.org/pub/ruby
RUBYGEMS=http://production.cf.rubygems.org/rubygems

set -e

apt-get -y install libssl-dev libreadline5-dev zlib1g-dev

for VERSION_PATCH in 1.8.7-p249 1.9.1-p378; do
	DESTDIR=/tmp/ruby-$VERSION_PATCH-$$
	VERSION=$(echo $VERSION_PATCH | sed -r 's/^([^-]+).*$/\1/')
	V=$(echo $VERSION | sed -r 's/^([0-9]+\.[0-9]+).*$/\1/')

	debra create $DESTDIR

	cat <<EOF >$DESTDIR/DEBIAN/control
Package: opt-ruby-$VERSION
Version: $VERSION_PATCH-3
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
	mkdir -p $DESTDIR/opt
	debra sourceinstall $DESTDIR $RUBY/$V/ruby-$VERSION_PATCH.tar.gz \
		-b "$BOOTSTRAP" -p /opt/ruby-$VERSION

	# Get set to install RubyGems from DEBIAN/postinst.
	# FIXME The resulting package will be unable to uninstall itself.
	(cd $DESTDIR/opt/ruby-$VERSION && wget $RUBYGEMS/rubygems-1.3.6.tgz)
	cat <<EOF >$DESTDIR/DEBIAN/postinst
#!/bin/sh
set -e
case "\$1" in
	configure)
		(cd /opt/ruby-$VERSION && tar xf rubygems-1.3.6.tgz)
		(cd /opt/ruby-$VERSION/rubygems-1.3.6 && \\
			/opt/ruby-$VERSION/bin/ruby setup.rb)
		rm -rf /opt/ruby-$VERSION/rubygems-1.3.6 \\
			/opt/ruby-$VERSION/rubygems-1.3.6.tgz
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
	debra build $DESTDIR opt-ruby-${VERSION}_$VERSION_PATCH-3_$ARCH.deb

	debra destroy $DESTDIR
done
