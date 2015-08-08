# Ctags p13n Bundle

The ctags p13n bundle provides a clean framework for bundling ctags
configuration files from multiple sources.

This bundle provides:

* Default `~/.ctags`.
* Automatic inclusion into `~/.ctags` of files placed in `~/.ctags.d`.

After installing, your `~/.ctags` file will be backed up (with
`.p13n.<date-time>` appended). This backups should be included in an
appropriate bundle and installed in `~/.ctags.d`. Finally, run:

    p13n refresh
