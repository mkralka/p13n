# zsh p13n Bundle

The zsh p13n bundle provides a clean framework for bundling zsh
configuration files from multiple sources.

This bundle provides:

* Default `~/.zshenv`, `~/.zprofile`, `~/.zshrc`, `~/.zlogin`, and `~/.zlogout`.
* `append_path`, `prepend_path`, `expunge_path` and `expunge_path_re`
  functions for easily manipulating your `PATH` environment variable.
* Automatic inclusion into each `~/.zXXX` (e.g., `~/.zshenv`) of files that end
  in `.zsh` and are placed in `~/.zXXX.d` (e.g., `~/.zshevn.d`)
* Inclusion of `p13n`'s `bin` directory in your path (interactive shell's only).
* Automatically delete any variables that begin with `__p13n_`, simplifying the
  use of temporary variables without the need to clean up.

After installing, your `~/.zshenv`, `~/.zprofile`, `~/.zshrc`, `~/.zlogin`, and
`~/.zlogout` files will be backed up (with `.p13n.<date-time>` appended). These
backups can be included in an appropriate bundle and installed in the
appropriate `~/.zXXX.d` directory.
