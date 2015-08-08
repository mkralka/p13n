# P13n

p13n is a personalization framework to aid in the management of
configuration files on UNIX-like systems (e.g., Linux, MacOS, etc.).

## History
Trying to keep personalized configuration files synchronized between
multiple machines is annoying. In the past, I have had two or more
physical machines (one personal, one or more from work). Since most of
my time in front of a computer is spent at a work computer,
customizations and tweaks often start there and slowly migrate back to
my personal machine.

Things tended to get interested when switching companies. I would
manually bundle up the latest configuration files into a tarball (e.g.,
`p13n-20140926.tar.gz`). I would inevitably miss files, forcing me to
start over again.

The first solution to this was to put configuration files under source
control. This was great, but updating was a pain. After making a change
to on one machine, pushing the changes to the cloud, and pulling the
changes to other machines, I would have to move these changes into
place. I cobbled together some scripts to automate this for me, which
made things better.

This script has been refined over the years to make things easier and to
support more complicated scenarios. After spending some time to make the
script more universal (POSIX compliant), I decided to release it into
the wild.

## Motivations
The p13n project has the following motivations:

* *Universal*: The `p13n` script should support any UNIX-like
  environment with a bourne-like shell. The starting goal is to depend
  only features available in [POSIX 1003.1](http://pubs.opengroup.org/onlinepubs/9699919799/nfindex.html)
  (specifically the [Shell & Utilities](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/contents.html)
  section). If your environment is not POSIX compliant and would like to
  see `p13n` supported, file an issue (or better, send a patch).
* *VCS-Managed Files*: All configuration files should be easily managed
  by your favorite VCS. It should be easy to see if any changes have
  been made to the installed files compared to what is managed by VCS.
* *Easy to update*: Updates to existing configuration files should be
  easy and painless, preferably automatic.
  
## Install p13n
To install p13n, first clone this repo:

    git clone https://github.com/mkralka/p13n.git

This will create a `p13n` directory in your current working directory,
so be sure to run the command from an appropriate directory (e.g.,
`~/dev`).

p13n is a standalone script, so should work by putting the `bin`
directory in your path. E.g.:

    export PATH=$PATH:$HOME/dev/p13n/bin

Before update your shell configuration files to include this, consider
installing the `p13n-bash` bundle. This bundle automatically adds `p13n`
to your path.

Include in the p13n package are helper bundles for common configuration
files. They do not provide any specific configuration, only frameworks
for aiding in the configuration (mostly for merging configuration
files).

Bundles can be found in the `bundles` directory of the `p13n` project.

* [`p13n-bash`](bundles/bash/README.md) (recommended)
* [`p13n-ctags`](bundles/ctags/README.md)
* [`p13n-git`](bundles/git/README.md)
* [`p13n-ssh`](bundles/ssh/README.md)

## Using p13n.
`p13n` uses a git-like CLI, including online help. To get help for the
`p13n` command, including a list of supported subcommands, run:

    p13n -h

To get help for a subcommand, run:

    p13n <subcommand> -h

E.g.,

    p13n install -h

### Installing bundles
To install a bundle, use the `install` subcommand. E.g., to install the
bash framework:

    p13n install bundle/bash

`p13n` will cowardly refuse to install any bundle that was previously
installed.

### Updating bundles
If a bundle has been updated to include different files (either files
added or removed), the bundle can be updated using the `update`
subcommand:

    p13n update p13n-bash

If no bundle is specified, then all bundles are updated:

    p13n update

### Refreshing bundles
When dynamically generated content (e.g., merged files) changes, the
`refresh` command will make those changes visible.

    p13n refresh

Refreshing affects all installed bundles.

**NOTE: If new files are added to a bundle, refreshing will not cause
these new files to take affect. Use `update` for that.**


## Creating Bundles
p13n is a framework that does not include any configuration files.
Instead, it manages configuration bundles. Normally, you would define a
single configuration bundle containing all of your customizations and
tweaks. However, multiple bundles makes it possible to install
customizations that are machine-specific or written by others.

_**It's strongly recommended that you maintain your bundle under source
control. This will allow you to track your changes and undo anything
that breaks your configuration. This is general advice and is not
specific to p13n.**_

At the root of your bundle, create a `p13n.conf` file describing your
bundle. The format of this file is simple:

    key1=value1
    key2=value2

The following keys are supported:

| Key       | Description                                                                                                                                                 |
|:----------|:------------------------------------------------------------------------------------------------------------------------------------------------------------|
| name      | The name of the package. This must be unique.                                                                                                               |
| filesdir  | The directory containing the files to install, verbatim. This directory is relative to the root of the bundle (i.e., the location of the `p13n.conf` file). |
| mergedir  | The directory containing the mergers to install. This directory is relative to the root of the bundle (i.e., the location of the `p13n.conf` file).         |

### Creating regular files
All of the files contained within `filesdir` will be installed (a
symlink from your home directory to the file will be created). Files
that begin with an underscore (`_`) will become hidden by renaming them
to begin with a dot (`.`) instead. For example, to install `~/.vimrc`,
create a file `_vimrc` (relative to the `filesdir` value).

`filesdir` is searched recursively. Each component of the path will be
translated (e.g., replacing leading underscores (`_`) with leading dots
(`.`). For example, to install `~/.ssh/config`, create a file
`_ssh/config` (relative to the filesdir` value).

### Creating merge files
All of the files contained within `mergedir` define a file to be merged.
The same rules from regular files for determining where the merged file
is installed are used for determining where the merged files are
installed. However, instead of containing content, the merged file
contains instructions on how to perform the merge. The merge file is the
same format as the bundle's configuration file, except with different
keys.

| Key    | Description                                                                                                                                |
|:-------|:-------------------------------------------------------------------------------------------------------------------------------------------|
| merger | The script for merging files. It is passed all of the files to be merged and produces the merged results. If not specified, `cat` is used. |
| srcdir | The directory containing the files to be merged. If not specified, the directory is the same as the merged file with `.d` appended.        |

If `merger` beings with a forward slash (`/`), then the merge is assumed
to be the absolute path to the merger command. Otherwise, it is assumed
to be relative to the bundle's root (i.e., the location of the
`p13n.conf` file).

`srcdir` is relative to your home directory.

#### Examples

An empty `_gitignore` will use `cat` to merge all files under
`~/.gitignore.d`. It is equivalent to:

    merger=/bin/cat
    srcdir=.gitignore.d

A `_gitconfig` file with the following contents:

    merger=exec/merge_gitconfig

Will merge all files under `~/.gitconfig` using the `exec/merge_config`
script found within the bundle.

## How it works
p13n is mostly a glorified symbolic link maintainer. All non-merged
configuration files continue to reside in their respective
VCS-maintained directories. Symbolic links are created from the expected
location of the configuration file (e.g., `~/.vimrc`) to VCS-maintained
directory. E.g.:

    $ ls -l ~/.vimrc
    lrwxr-xr-x  1 mkralka  staff  25 Jun 10 23:12 /Users/mkralka/.vimrc -> dev/p13n-mdk/files/_vimrc

This means that if something updates a configuration file in place (be
it a script or you with an editor), the configuration change can easily
be seen using your VCS tools. This also means that any changes you make
(e.g., pulling the latest configuration from your remote repo) will
automatically take effect (without having to update).

Merged configuration files are slightly more complicated. Some bundles
provide support for merged configuration files. These handle the case
where multiple bundles may need to update a single configuration files
(e.g., `~/.ssh/config` may contain both personal settings and settings
for work instances that you don't want to or can't have on your personal
instance).

Depending on the system being configured. Some merged files are merged
by leveraging support in the configuration file for including other
files (e.g., `~/.gitconfig`). Changes in fragments to files merged this
way will automatically take effect. Some merged files need to be
manually merged (e.g., `~/.gitignore`). This is done by concatenating the
fragments to produce a merged file.

Fragments for merged files are stored in a directory whose name is
similar to the configuration file, with `.d` appended. E.g., the
fragments for `~/.gitconfig` are placed in `~/.gitconfig.d`.
configuration file 
