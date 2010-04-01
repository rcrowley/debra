debra-sourceinstall(1) -- install from a source tarball
=======================================================

## SYNOPSIS

`debra sourceinstall` _name_ _tarball_ [_..._] [`-h`]  

## DESCRIPTION

`debra-sourceinstall` is a frontend to `sourceinstall`(1) that automatically sets _prefix_ and _destdir_ such that the package will be installed in `<name>/opt/$PACKAGE` where `$PACKAGE` is determined from the _tarball_ name.

## OPTIONS

* _name_:
  Name of a Debra directory.
* _tarball_:
  Path or URI to a source tarball.
* [_..._]:
  `sourceinstall`(1) arguments.
* `-h`, `--help`:
  Show a help message.

## THEME SONG

Beck - "Debra"

## AUTHOR

Richard Crowley <richard@devstructure.com>

## SEE ALSO

Part of `debra`(1).

`debra-create`(1), `debra-sourceinstall`(1), `debra-build`(1), `debra-destroy`(1), `debra-makefile`(1).

`sourceinstall`(1) is a generic way to automate installation from tarballs.
