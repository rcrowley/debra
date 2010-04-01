debra(1) -- build Debian packages
=================================

## SYNOPSIS

`debra` [_command_] [_..._]  

## DESCRIPTION

`debra` programs are used to build Debian packages in a fairly sane manner.

* `debra-create`(1):
  Create a new Debra directory.
* `debra-sourceinstall`(1):
  Install from a source tarball.
* `debra-build`(1):
  Build a Debian package.
* `debra-destroy`(1):
  Destroy a Debra directory.
* `debra-makefile`(1):
  Generate Makefiles for building packages with Debra.
* `sourceinstall`(1):
  Install from a source tarball.

## EXAMPLES

`debra-makefile` generates `Makefile.in`, `control`, `install-sh`, `configure.ac`, and `.gitignore` with installation and package building targets.

Using `debra-makefile`, Debra can build a Debian package for itself.  This example shows how you can use `reprepro`(1) to publish the newly-built Debian package to a local Debian archive and install it through `apt-get`(8).

	./configure
	make deb
	reprepro -b /var/packages/ubuntu includedeb karmic debra_*_all.deb
	apt-get update
	apt-get install debra

`make deb` calls `git-archive`(1), `debra create`, `debra sourceinstall`, `debra build` and `debra destroy`.

## FILES

* `$HOME/.debra`:
  The contents of `$HOME/.debra` is used by `debra-create`(1) to initialize the `DEBIAN/control` file.

## THEME SONG

Beck - "Debra"

## AUTHOR

Richard Crowley <richard@devstructure.com>

## SEE ALSO

`debra-create`(1), `debra-sourceinstall`(1), `debra-build`(1), `debra-destroy`(1), `debra-makefile`(1).

`sourceinstall`(1) is a generic way to automate installation from tarballs.

`reprepro`(1) plus your favorite HTTP server can together manage a Debian archive to serve the packages built by `debra`(1).
