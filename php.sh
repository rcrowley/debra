ARCH=amd64

for VERSION in 5.2.12 5.3.1; do
	V=$(echo $VERSION | sed -r 's/^([0-9]+\.[0-9]+).*$/\1/')
	debra init /tmp/php-$$

	[ "5.3" != "$V" ] && MYSQL=", libmysqlclient16"
	cat <<EOF >/tmp/php-$$/DEBIAN/control
Package: opt-php-$VERSION
Version: $VERSION-1
Section: devel
Priority: optional
Essential: no
Architecture: amd64
Depends: libc6, libssl0.9.8, libreadline5, zlib1g, libxml2, libexpat1, libcurl3, libicu40$MYSQL
Maintainer: Richard Crowley <r@rcrowley.org>
Description: Standalone PHP $VERSION.
EOF

	# Install PHP itself.
	if [ "5.3" != "$V" ]; then
		MYSQL="--with-mysql=mysqlnd --with-mysqli=mysqlnd"
	else
		MYSQL="--with-mysql --with-mysqli"
	fi
	debra sourceinstall /tmp/php-$$ \
		http://us3.php.net/get/php-$VERSION.tar.bz2/from/this/mirror \
		-f "--enable-cli --enable-cgi --enable-fastcgi --with-openssl --with-curl --with-zlib $MYSQL --enable-pdo --with-pdo-mysql --enable-pcntl --enable-sqlite-utf8 --with-libxml-dir=/usr --with-pear",

	# Build and push a Debian package.
	debra build /tmp/php-$$ opt-php-${VERSION}_${VERSION}-1_$ARCH.deb
	reprepro --basedir=/var/packages/ubuntu includedeb karmic \
		opt-php-${VERSION}_${VERSION}-1_$ARCH.deb

	rm -rf /tmp/php-$$
done
