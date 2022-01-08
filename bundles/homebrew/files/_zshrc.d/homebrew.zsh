# vim: set filetype=zsh:

# On Apple Silicon, homebrew is installed in /opt/homebrew rather than
# /usr/local, which means that its directories are not automatically
# picked up by PATH, man, etc. homebrew provides a command to determine
# what changes are needed.
if [[ -x /opt/homebrew/bin/brew ]]; then
	# This command should be idempotent
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
