ARCH=amd64
RUBY=ftp://ftp.ruby-lang.org/pub/ruby
RUBYFORGE=http://rubyforge.org/frs/download.php

apt-get install libssl-dev libreadline5-dev zlib1g-dev

for VERSION in 1.8.7-p249 1.9.1-p378; do
	V=$(echo $VERSION | sed -r 's/^([0-9]+\.[0-9]+).*$/\1/')
	debra init /tmp/ruby-$$

	cat <<EOF >/tmp/ruby-$$/DEBIAN/control
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
	debra sourceinstall /tmp/ruby-$$ $RUBY/$V/ruby-$VERSION.tar.gz \
		-b "sh -c 'echo fcntl\\\nopenssl\\\nreadline\\\nzlib >ext/Setup'"

	# Install RubyGems.
	sourceinstall /tmp/python-$$/opt/ruby-$VERSION \
		$RUBYFORGE/60718/rubygems-1.3.5.tgz \
		-c "/tmp/ruby-$$/opt/ruby-$VERSION/bin/ruby setup.rb"

	# Replace path to the temporary home of this Python interpreter with
	# the path where it will be installed.
	for PATHNAME in $(grep -rlI /tmp/ruby-$$ /tmp/ruby-$$); do
		mv $PATHNAME $PATHNAME.sav
		sed s/\\/tmp\\/ruby-$$// <$PATHNAME.sav >$PATHNAME
		rm $PATHNAME.sav
	done

	# Build and push a Debian package.
	debra build /tmp/ruby-$$ opt-ruby-${VERSION}_${VERSION}-1_$ARCH.deb
	reprepro --basedir=/var/packages/ubuntu includedeb karmic \
		opt-ruby-${VERSION}_${VERSION}-1_$ARCH.deb

	rm -rf /tmp/ruby-$$
done
