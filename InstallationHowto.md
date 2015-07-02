#summary Installation Hints
#labels Featured,Phase-Deploy

# Prerequisites #

Do NOT attempt to build from a checkout from the source code repository: that is for wizards only.  Instead, grab one of the released source tarballs from the [downloads](http://code.google.com/p/mnesiaex/downloads/list) tab.

  1. gnu make
  1. working erlang installation.
    * debian: aptitude install erlang-dev
    * os/x (with [fink](http://www.finkproject.org/)): apt-get install erlang-otp
    * freebsd: pkg\_add -r erlang
    * others: ???
  1. [eunit](http://support.process-one.net/doc/display/CONTRIBS/EUnit) from process one; optional but 'make check' will not do anything without it.

# Installing #

The project uses automake[[1](#1.md)].  The default prefix is /usr; if you don't like that, use the `--prefix` option to configure.
```
% ./configure && make && make check 
```
Running `make check` is strongly suggested.

The project is distributed as a set of patches.  At build time it tries to
find your current version of mnesia and patch it.  If this is successful,
then it will end up creating a version of mnesia with a version equal
to the version you have installed plus ".N" where N is the version of
the extensions.  For instance, right now, version 6 of the extensions
has been released, so on a system running mnesia-4.3.5, a successful
build and install will install as mnesia-4.3.5.6.

# Tested Platforms #

  * Ubuntu 32 bit / 64 bit Linux (gusty) with mnesia-4.4.7 (Erlang R11B5).
  * Ubuntu 32 bit / 64 bit Linux (gusty) with mnesia-4.3.5 (Erlang R12B5).
  * OS/X 10.4 i386 with mnesia-4.3.5 (installed via fink).

# Footnotes #

## 1 ##

More precisely, downloadable source tarballs use automake to build.  A source code checkout of the repository uses [framewerk](http://code.google.com/p/fwtemplates) to build, and if you don't know what that is, you probably want to stick with the tarballs.