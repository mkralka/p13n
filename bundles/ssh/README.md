# Ssh p13n Bundle

The ssh p13n bundle provides a clean framework for bundling ssh
configuration files from multiple sources.

This bundle provides:

* Default `~/.ssh/config`.
* Automatic inclusion into `~/.ssh/config` of files placed in
  `~/.ssh/config.d`.

After installing, your `~/.ssh/config` file will be backed up (with
`.p13n.<date-time>` appended). This backup should be included in an
appropriate bundle and installed in `~/.ssh/config.d`.
