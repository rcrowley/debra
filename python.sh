ARCH=amd64
PYTHON=http://python.org/ftp/python
PYPI=http://pypi.python.org/packages

apt-get -y install libssl-dev libreadline5-dev zlib1g-dev

for VERSION in 2.5.5 2.6.4 3.1.1; do
	V=$(echo $VERSION | sed -r 's/^([0-9]+\.[0-9]+).*$/\1/')
	debra init /tmp/python-$$

	cat <<EOF >/tmp/python-$$/DEBIAN/control
Package: opt-python-$VERSION
Version: $VERSION-1
Section: devel
Priority: optional
Essential: no
Architecture: amd64
Depends: libc6, libssl0.9.8, libreadline5, zlib1g
Maintainer: Richard Crowley <r@rcrowley.org>
Description: Standalone Python $VERSION.  This installation includes the setuptools and pip packages from PyPI.
EOF

	# Install Python itself.
	debra sourceinstall /tmp/python-$$ \
		$PYTHON/$VERSION/Python-$VERSION.tar.bz2

	# Install setuptools and pip unless this is Python 3000, which still
	# hasn't gotten any love.
	if echo $VERSION | egrep '^2' >/dev/null; then
		(cd /tmp/python-$$ && wget \
			$PYPI/$V/s/setuptools/setuptools-0.6c11-py$V.egg)
		PATH="/tmp/python-$$/opt/Python-$VERSION/bin:$PATH" sh \
			/tmp/python-$$/setuptools-0.6c11-py$V.egg \
			--prefix=/tmp/python-$$/opt/Python-$VERSION
		sourceinstall /tmp/python-$$/opt/Python-$VERSION \
			$PYPI/source/p/pip/pip-0.6.2.tar.gz \
			-c "/tmp/python-$$/opt/Python-$VERSION/bin/python setup.py install"
	fi

	# Replace path to the temporary home of this Python interpreter with
	# the path where it will be installed.
	for PATHNAME in $(grep -rlI /tmp/python-$$ /tmp/python-$$); do
		mv $PATHNAME $PATHNAME.sav
		sed s/\\/tmp\\/python-$$// <$PATHNAME.sav >$PATHNAME
		rm $PATHNAME.sav
	done

	# Build and push a Debian package.
	debra build /tmp/python-$$ opt-python-${VERSION}_${VERSION}-1_$ARCH.deb
	reprepro --basedir=/var/packages/ubuntu includedeb karmic \
		opt-python-${VERSION}_${VERSION}-1_$ARCH.deb

	rm -rf /tmp/python-$$
done
