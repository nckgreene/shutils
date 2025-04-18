#!/bin/sh
#
# add-py-shebang  –  Ensure a file begins with “#!/usr/bin/env python3”
#                    and set mode 755 (rwx r‑x r‑x).

set -eu   # stop on errors and unset vars

usage() {
    echo "Usage: $(basename "$0") <file>" >&2
    exit 1
}

[ "$#" -eq 1 ] || usage
file=$1

[ -f "$file" ] || { echo "Error: '$file' is not a regular file." >&2; exit 1; }

# Grab first line (may be empty)
first_line=$(head -n 1 "$file" 2>/dev/null || true)

case "$first_line" in
    '#!/usr/bin/env python3'*) : ;;   # already present → nothing to add
    *)
        tmp=$(mktemp "${TMPDIR:-/tmp}/add_py_shebang.XXXXXX") || exit 1
        { printf '%s\n' '#!/usr/bin/env python3'; cat "$file"; } > "$tmp"
        mv "$tmp" "$file"
        ;;
esac

chmod 755 "$file"
echo "Updated '$file' – now executable with python3 shebang."

