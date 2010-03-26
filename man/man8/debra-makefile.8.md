debra-makefile(8) -- generate Makefiles for building packages with Debra
========================================================================

## SYNOPSIS

`debra-makefile` [`-a`]

## DESCRIPTION

Use this program to generate a basic Makefile and control file for incorporating `debra`(8) into your project's build system.  The generated files are marked TODO in places that need your attention.  Any existing Makefile or Makefile.in will be appended to rather than overwritten.

## OPTIONS

* `-a`:
  When given, Makefile.in will be generated in anticipation of an `autoconf`(1)-aware build system.

## THEME SONG

Beck - "Debra"

## AUTHOR

Richard Crowley <r@rcrowley.org>

## SEE ALSO

`debra-makefile`(8) is part of the Debra package.  Debra's source code is available at <http://github.com/devstructure/debra>.

`debra`(8) provides a convenient way to create Debian packages.
