# Bash p13n Bundle

The bash p13n bundle provides a clean framework for bundling bash
configuration files from multiple sources.

This bundle provides:

* Default `~/.bashrc`, `~/.bash_profile`, and `~/.profile`.
* `append_path`, `prepend_path`, `expunge_path` and `expunge_path_re`
  functions for easily manipulating your `PATH` environment variable.
* Automatic inclusion into `~/.bashrc` of files that end in `.sh` and
  are placed in `~/.bashrc.d`.
* Automatic inclusion into `~/.profile` of files that end in `.sh` and are
  placed in `~/.profile.d`.
* Inclusion of `p13n`'s `bin` directory in your path.

After installing, your `~/.bashrc`, `~/.bash_profile` and `~/.profile`
files will be backed up (with `.p13n.<date-time>` appended). These
backups should be included in an appropriate bundle and installed in
`~/.bashrc.d` or `~/.profile.d`.
