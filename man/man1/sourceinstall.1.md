sourceinstall(1) -- install from a source tarball URL
=====================================================

## SYNOPSIS

`sourceinstall` _tarball-uri_ [`-b` _bootstrap_] [`-f` _flags_] [`-p` _prefix_] [`-d` _destdir_] [`-c` _command_] [`-h`]  

## DESCRIPTION

Sourceinstall automates the fetch, extract, install cycle frequently encountered when working with source archives.  Options are provided for adding a bootstrap command, customizing the `./configure` command, or customising the destination directory.  The `-c` option bypasses the standard _bootstrap_, `./configure`, `make`, `make install` process entirely and runs _command_ instead.

## OPTIONS

Options may be set multiple times.  In all cases, the last one wins.

* `-b` _bootstrap_:
  Command to run before beginning the `./configure`, `make`, `make install` sequence.  This command is run from the root of the extracted tarball.

* `-f` _flags_:
  Flags to be passed to `./configure`.

* `-p` _prefix_:
  Shortcut to the `--prefix` flag to `./configure`.  If provided after `-f`, this will override any `--prefix` flag set there.

* `-d` _destdir_:
  The directory to be passed as `DESTDIR` to `make install`.

* `-c` _command_:
  A command to be run instead of the _bootstrap_, `./configure`, `make`, `make install` sequence.

* `-h`:
  Show a help message.

## AUTHOR

Richard Crowley <richard@devstructure.com>

## SEE ALSO

`sourceinstall`(1) is part of the Debra package.  Debra's source code is available at <http://github.com/devstructure/debra>.

`debra`(1) provides a convenient way to create Debian packages, optionally using `sourceinstall`(1) in the process.
