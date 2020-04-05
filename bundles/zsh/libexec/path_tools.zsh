# vim: filetype=zsh:

# TODO: Update to use `path` array
function append_path()
{
	while test $# -gt 0; do
		if ! echo ":$PATH:" | fgrep ":$1:" > /dev/null 2>&1; then
			export PATH="$PATH:$1"
		fi
		shift
	done
}

function prepend_path()
{
	while test $# -gt 0; do
		if ! echo ":$PATH:" | fgrep ":$1:" > /dev/null 2>&1; then
			export PATH="$1:$PATH"
		fi
		shift
	done
}

function expunge_path()
{
	while test $# -gt 0; do
		export PATH="$(echo "$PATH" | tr ':' '\n' | grep -Fxv "$1" | tr '\n' ':' | sed 's/:*$//')"
		shift
	done
}

function expunge_path_re()
{
	while test $# -gt 0; do
		export PATH="$(echo "$PATH" | tr ':' '\n' | grep -Exv "$1" | tr '\n' ':' | sed 's/:*$//')"
		shift
	done
}
