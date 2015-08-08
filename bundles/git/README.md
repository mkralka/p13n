# Git p13n Bundle

The git p13n bundle provides a clean framework for bundling git
configuration files from multiple sources.

This bundle provides:

* Default `~/.gitconfig` and `~/.gitignore` files.
* Automatic inclusion into `~/.gitconfig` of files placed in
  `~/.gitconfig.d`.
* Automatic inclusion into `~/.gitignore` of files placed in
  `~/.gitignore.d`.

After installing, your `~/.gitignore` and `~/.gitconfig` files will
be backed up (with `.p13n.<date-time>` appended). These backups should
be included in an appropriate bundle and installed in `~/.gitignore.d`
or `~/.gitconfig.d` (respectively). Finally, run:

    p13n refresh
