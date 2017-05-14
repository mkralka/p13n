# P13n

p13n is a personalization framework to aid in the management of configuration
files on UNIX-like systems (e.g., Linux, MacOS, etc.).


## Motivations The p13n project has the following motivations:

* *Universal*: The `p13n` script should support any UNIX-like environment with a
  bourne-like shell. The starting goal is to depend only features available in
  [POSIX 1003.1](http://pubs.opengroup.org/onlinepubs/9699919799/nfindex.html)
  (specifically the
  [Shell & Utilities](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/contents.html)
  section). If your environment is not POSIX compliant and would like to see
  `p13n` supported, file an issue (or better, send a patch).
* *VCS-Managed Files*: All configuration files should be easily managed by your
  favorite VCS. It should be easy to see if any changes have been made to the
  installed files compared to what is managed by VCS.
* *Easy to update*: Updates to existing configuration files should be easy and
  painless, preferably automatic.


## History
I've always found the process of keeping personalized configuration files
synchronized between multiple machines to be tedious and annoying.  I tend to
work regularly on two or more physical machines (one personal, one or more for
work) and countless VMs. Since most of my computer time is spent in front of a
work computer, customizations and tweaks often start there and slowly migrate
back to my personal computer.

Things tended to get interesting when switching companies. In these scenarios, I
would manually bundle up the latest configuration files into a tarball (e.g.,
`p13n-20140926.tar.gz`) uploaded to the cloud.  This tedious process would
inevitably miss some files and I would lose some customizations. More often than
not, I would miss a file and was forced to roll back to the most recent one
exported to my personal machine. If I was lucky I would only lose a few tweaks
to my `~/.vimrc` configuration and not the entire `~/.tmux.conf` that I spent a
few years tweaking.

The first solution to this was to put configuration files into a git repo. This
was great for ensuring the latest version was in the cloud and had the added
benefit of being able to roll back changes that weren't working. Unfortunately,
this didn't make it any easy to synchronize changes between machines. After
pushing some tweaks to the remote git repo and pulling them down to other
machines, updating the active configuration files was still a manual process.

To simplify the process, I cobbled together some scripts to automate it.  These
scripts evolved from simple scripts that installed single, independent
configuration files into more sophisticated scripts allowing my personal and
machine-specific configurations to be kept separate (while still supporting
tools with rigid configuration files).

This script has served me well over the years and after spending some time to
make the script more universal (i.e., more POSIX compliant), I have decided to
release it into the wild for others that might find it useful.


## Install p13n
To install p13n, first clone this repo:

    git clone https://github.com/mkralka/p13n.git

This will create a `p13n` directory in your current working directory, so be
sure to run the command from an appropriate directory (e.g., `~/dev`).

`p13n` is a standalone script, so installation is nothing more than adding the
`bin` directory in your path. E.g.:

    export PATH=$PATH:$HOME/dev/p13n/bin

or specifying the complete path to the `p13n` script:

    ~/dev/p13n/bin/p13n bash

Before updating your `PATH` to include the `bin` directory, consider installing
the [`p13n-bash`](bundles/bash) bundle. To install the bundle, run the following
from the root of the cloned `p13n` repo:

    bin/p13n install bundles/bash

This bundle will, among other things, automatically add the `p13n` to your
`PATH`.

### Helper Bundles
Included in the `p13n` package are helper bundles for common configuration
files. They do not provide any specific configuration. Instead, they provide
helpers to simplify the process of configuring the associated package from your
own bundles. Helpers are usually in the form of merging configuration files. For
example, the `p13n-ssh` bundle defines a merger for `~/.ssh/config` so multiple
bundles can contribute a single configuration file.

Bundles can be found in the `bundles` directory of the `p13n` project.

* [`p13n-bash`](bundles/bash) (recommended)
* [`p13n-ctags`](bundles/ctags)
* [`p13n-git`](bundles/git)
* [`p13n-ssh`](bundles/ssh)


## Using p13n.
`p13n` uses a git-like CLI, including online help. To get help for the `p13n`
command, including a list of supported subcommands, run:

    p13n -h

To get help for a subcommand, run:

    p13n <subcommand> -h

For example:

    p13n install -h

### Installing bundles
To install a bundle, use the `install` subcommand. For example, to install the
bash framework:

    p13n install bundle/bash

`p13n` will cowardly refuse to install any bundle that was previously installed.

### Updating bundles
If a bundle has been updated to include different files (either files added or
removed), the bundle can be updated using the `update` subcommand:

    p13n update p13n-bash

If no bundle is specified, then all bundles are updated:

    p13n update

### Refreshing bundles
When dynamically generated content (e.g., merged files) changes, the `refresh`
command will make those changes visible.

    p13n refresh

Refreshing affects all installed bundles.

**NOTE: If new files are added to a bundle, refreshing will not cause these new
files to take affect. Use `update` for that.**


## Creating Bundles
For `p13n` to be useful, you will have to define and install a configuration
bundle. Normally, you would define a single bundle but may define a few in
certain circumstances. For example,

* A personal bundle that contains all of your preferences, regardless of what
  machine.
* Machine specific bundles, e.g., one for your work that includes customizations
  for your work environment (such as path to tools, etc.).

_**It is strongly recommended that bundles are maintained under some form of
source control (e.g., `git`). This will allow changes to be tracked, making
rollbacks possible when configuration breaks. This is general advice and is not
specific to `p13n`. Although `p13n` should work with any sensible version
control system, it has been tested with `git`.**_

### Configuring your bundle
At the root of your bundle, create a `p13n.conf` file describing your bundle.
The format of this file is simple:

    key1=value1 key2=value2

The following keys are supported:

| Key      | Status  | Description                                                                                                                                                 |
|:---------|:--------|:------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`name`    |Required |The name of the package. This must be unique.                                                                                                               |
|`filesdir`|Optional†|The directory containing the files to install, verbatim. This directory is relative to the root of the bundle (i.e., the location of the `p13n.conf` file). |
|`mergedir`|Optional†|The directory containing the mergers to install. This directory is relative to the root of the bundle (i.e., the location of the `p13n.conf` file).         |
† At least one of `filesdir` and `mergedir` must be specified.

#### Examples
A configuration file might look similar to the following:

    name=p13n-bash
    filesdir=files
    mergedir=merge

### Creating regular files
All of the files contained within `filesdir` will be "installed".  Installing a
regular file takes the form of a relative symlink from the target location
(underneath `$HOME`) to the bundle's source file. For example:

    $ ls -l ~/.vimrc
    lrwxr-xr-x  1 mkralka  staff  25 Jun 10 23:12 /Users/mkralka/.vimrc -> dev/p13n-mdk/files/_vimrc

Files that begin with an underscore (`_`) will become hidden by renaming them to
begin with a dot (`.`) instead. For example, to install `~/.vimrc`, create a
file `_vimrc` (relative to the `filesdir` value).

`filesdir` is searched recursively. Each component of the path will be
translated by replacing leading underscores (`_`) with leading dots (`.`). For
example, to install `~/.ssh/config`, create a file `_ssh/config` (relative to
the `filesdir` value).

### Creating dynamically generated (merged) files
All of the files contained within `mergedir` define a file to be merged.  The
same rules for determining where a regular file is installed apply to
determining where a merged file is installed. However, merge files contain
details of how the files are merged instead of the content of the file being
installed.

A merge file has the same format as a bundle's `p13n.conf` configuration file
with different supported keys.

| Key    | Description                                                                                                                                |
|:-------|:-------------------------------------------------------------------------------------------------------------------------------------------|
|`merger`| The script for merging files. It is passed all of the files to be merged and produces the merged results. If not specified, `cat` is used. |
|`srcdir`| The directory containing the files to be merged. If not specified, the directory is the same as the merged file with `.d` appended.        |

If `merger` begins with a forward slash (`/`), then `merger` is assumed to be
the absolute path to the merger command. Otherwise, it is assumed to be relative
to the bundle's root (i.e., the location of the `p13n.conf` file).

`srcdir` is relative to your home directory.

#### Examples

An empty `_gitignore` will use `cat` to merge all files under `~/.gitignore.d`.
It is equivalent to:

    merger=/bin/cat
    srcdir=.gitignore.d

A `_gitconfig` file with the following contents:

    merger=exec/merge_gitconfig

Will merge all files under `~/.gitconfig.d` into `~/.gitconfig` using the
`exec/merge_config` script found within the bundle.

## How it works
`p13n` is mostly a glorified symbolic link maintainer. All non-merged
configuration files continue to reside in their respective VCS-maintained
directories. Symbolic links are created from the expected location of the
configuration file (e.g., `~/.vimrc`) to VCS-maintained directory. For example:

    $ ls -l ~/.vimrc
    lrwxr-xr-x  1 mkralka  staff  25 Jun 10 23:12 /Users/mkralka/.vimrc -> dev/p13n-mdk/files/_vimrc

This means that if something updates a configuration file in place (be it a
script or you with an editor), the configuration change can easily be seen using
your VCS tools. This also means that any changes you make (e.g., pulling the
latest configuration from your remote repo) will automatically take effect
(without having to update).

Merged configuration files are slightly more complicated. Some bundles provide
support for merged configuration files. These handle the case where multiple
bundles may need to update a single configuration files (e.g., `~/.ssh/config`
may contain both personal settings and settings for work instances that you
don't want to or can't have on your personal instance).

Depending on the system being configured. Some merged files are merged by
leveraging support in the configuration file for including other files (e.g.,
`~/.gitconfig`). Changes in fragments to files merged this way will
automatically take effect. Some merged files need to be manually merged (e.g.,
`~/.gitignore`). This is done by concatenating the fragments to produce a merged
file.

Fragments for merged files are, by default, stored in a directory whose name is
similar to the configuration file, with `.d` appended. E.g., the fragments for
`~/.gitconfig` are placed in `~/.gitconfig.d`.
