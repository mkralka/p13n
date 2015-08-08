# vim: filetype=sh:

append_path()
{
	while test $# -gt 0; do
		if ! echo ":$PATH:" | fgrep ":$1:" > /dev/null 2>&1; then
			export PATH="$PATH:$1"
		fi
		shift
	done
}

prepend_path()
{
	while test $# -gt 0; do
		if ! echo ":$PATH:" | fgrep ":$1:" > /dev/null 2>&1; then
			export PATH="$1:$PATH"
		fi
		shift
	done
}

expunge_path()
{
	while test $# -gt 0; do
		export PATH="$(echo "$PATH" | tr ':' '\n' | grep -Fxv "$1" | tr '\n' ':' | sed 's/:*$//')"
		shift
	done
}

expunge_path_re()
{
	while test $# -gt 0; do
		export PATH="$(echo "$PATH" | tr ':' '\n' | grep -Exv "$1" | tr '\n' ':' | sed 's/:*$//')"
		shift
	done
}
