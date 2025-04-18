#!/bin/sh
#
# install-symlink – Symlink any script into ~/.local/bin (or another dir)
# Usage:  install-symlink   /absolute/or/relative/path/to/script   [link-name]

set -eu

usage() {
    echo "Usage: $(basename "$0") <path-to-script> [link-name]" >&2
    exit 1
}

[ "$#" -ge 1 ] && [ "$#" -le 2 ] || usage

src=$1
[ -f "$src" ] || { echo "Error: '$src' not found." >&2; exit 1; }

link_name=${2:-$(basename "$src")}

chmod 755 "$src"                               # ensure executable

dest_dir="$HOME/.local/bin"
mkdir -p "$dest_dir"

abs_src=$(cd "$(dirname "$src")" && pwd)/$(basename "$src")
ln -sf "$abs_src" "$dest_dir/$link_name"

case ":$PATH:" in *":$dest_dir:"*) ;; *)
    echo >&2 "Notice: $dest_dir isn't on PATH. Add:"
    echo >&2 '  export PATH="$HOME/.local/bin:$PATH"'
    ;;
esac

echo "Installed: $dest_dir/$link_name → $abs_src"

