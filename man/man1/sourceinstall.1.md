sourceinstall(1) -- install from a source tarball
=================================================

## SYNOPSIS

`sourceinstall` _tarball_ [`-b` _bootstrap_] [`-f` _flags_] [`-p` _prefix_] [`-d` _destdir_] [`-i` _install_] [`-c` _command_] [`-h`]  

## DESCRIPTION

Sourceinstall automates the fetch, extract, install cycle frequently encountered when working with source archives.  Options are provided for adding a bootstrap command, customizing the `./configure` command, or customising the destination directory.  The `-c` option bypasses the standard _bootstrap_, `./configure`, `make`, `make install` process entirely and runs _command_ instead.

## OPTIONS

Options may be set multiple times.  In all cases, the last one wins.

* _tarball_:
  Path or URI to a source tarball.
* `-b` _bootstrap_:
  Bootstrap command to run before beginning `./configure`, `make`, `make install`.  This command is run from the root of the extracted tarball.
* `-f` _flags_:
  Flags passed to `./configure`.
* `-p` _prefix_:
  Prefix passed to `./configure`.  Shortcut to the `--prefix` flag which will override any `--prefix` set in _flags_.
* `-d` _destdir_:
  Destination directory passed to `make install` as `DESTDIR`.
* `-i` _install_:
  Make target to run instead of `install`.
* `-c` _command_:
  Command to run instead of `./configure`, `make`, `make install`.  This command is run from the root of the extracted tarball.
* `-h`:
  Show a help message.

## AUTHOR

Richard Crowley <richard@devstructure.com>

## SEE ALSO

Part of `debra`(1).
