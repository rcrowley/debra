debra(8) -- for building Debian packages
========================================

## SYNOPSIS

`debra create` _name_ [_control_]  
`debra sourceinstall` _name_ _tarball-uri_ [_..._]  
`debra build` _name_ _deb_  
`debra destroy` _name_  

## DESCRIPTION

Debra is for building Debian packages.  The `create` subcommand creates a directory for building Debian packages.  The `DEBIAN/control` file is initialized from the first applicable source: the file named by the next command line argument, `$HOME/.debra`, or an empty template.

It is left to the user to populate `DEBIAN/control`, `DEBIAN/postinst`, `DEBIAN/prerm`, and the fake filesystem presented by Debra.  `sourceinstall`(8) can assist in this process.  The `sourceinstall` subcommand calls `sourceinstall`(8) with all arguments passed by the user plus `-d` _name_ to set the `DESTDIR` argument to `make install` automatically.

When the package is ready, the `build` subcommand creates a Debian package with the specified filename.  `DEBIAN/md5sums` is automatically populated with the hashes of each file that will be part of the archive.

## EXAMPLES

Debra can build a Debian package for itself.  This example shows how you can use `reprepro`(1) to publish the newly-built Debian package to a local Debian archive and install it through `apt-get`(8).

	make deb
	reprepro -b /var/packages/ubuntu includedeb karmic debra_0.1.3-1_all.deb
	apt-get update
	apt-get install debra

`make deb` calls `git-archive`(1), `debra create`, `debra sourceinstall`, `debra build` and `debra destroy`.

## FILES

* `$HOME/.debra`:
  The contents of `$HOME/.debra` will be used to initialize the `DEBIAN/control` file during the `create` action.

## THEME SONG

Beck - "Debra"

## AUTHOR

Richard Crowley <r@rcrowley.org>

## SEE ALSO

Debra's source code is available at <http://github.com/relreso/debra>.

`sourceinstall`(8) details options for installing source tarballs.

`reprepro`(1) plus your favorite HTTP server can together manage a Debian archive to serve the packages built by `debra`(8).
