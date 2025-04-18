#!/bin/sh
#
# install-symlink – Symlink any script into ~/.local/bin
#                   Default link name = filename minus its final extension.
#
# Usage:  install-symlink  /path/to/script[.ext]  [link-name]

set -eu

usage() {
    echo "Usage: $(basename "$0") <path-to-script> [link-name]" >&2
    exit 1
}

# ---------- parse args -------------------------------------------------------
[ "$#" -ge 1 ] && [ "$#" -le 2 ] || usage

src=$1
[ -f "$src" ] || { echo "Error: '$src' not found." >&2; exit 1; }

# ---------- derive default link name (strip trailing extension) -------------
base=$(basename "$src")
case "$base" in
    .* | *.*.*) link_default="$base" ;;        # dot‑file or multiple dots → keep full name
    *.*)        link_default=${base%.*} ;;     # strip last “.ext”
    *)          link_default="$base" ;;
esac

link_name=${2:-$link_default}

# ---------- ensure source is executable -------------------------------------
chmod 755 "$src"

# ---------- make the symlink -------------------------------------------------
dest_dir="$HOME/.local/bin"
mkdir -p "$dest_dir"

abs_src=$(cd "$(dirname "$src")" && pwd)/$(basename "$src")
ln -sf "$abs_src" "$dest_dir/$link_name"

# ---------- warn if ~/.local/bin isn’t on PATH ------------------------------
case ":$PATH:" in
    *":$dest_dir:"*) ;;
    *)
        echo >&2 "Notice: $dest_dir is not on PATH. Add this to your shell rc:"
        echo >&2 '  export PATH="$HOME/.local/bin:$PATH"'
        ;;
esac

echo "Installed: $dest_dir/$link_name → $abs_src"

