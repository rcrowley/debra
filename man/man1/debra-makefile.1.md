debra-makefile(1) -- generate Makefiles for building packages with Debra
========================================================================

## SYNOPSIS

`debra-makefile` [`-p` _package_] [`-a` _architecture_] [`-h`]  

## DESCRIPTION

`debra-makefile` generates `Makefile.in`, `control`, `install-sh`, `configure.ac`, and `.gitignore` for incorporating `debra`(1) into your project's build system.  The generated files are marked TODO in places that need your attention.

An existing `Makefile.in` will be appended to.  An existing `control` file will be preserved.  An existing `configure.ac` will be preserved.  An existing `.gitignore` will be appended to.

If possible, your Git config will be used to populate name and email address fields.

## OPTIONS

* `-p` _package_:
  Package name.  Defaults to the name of the current directory.
* `-a` _architecture_:
  Architecture.  Defaults to "all".

## THEME SONG

Beck - "Debra"

## AUTHOR

Richard Crowley <richard@devstructure.com>

## SEE ALSO

`debra-makefile`(1) is part of the Debra package.  Debra's source code is available at <http://github.com/devstructure/debra>.

`debra`(1) provides a convenient way to create Debian packages.
