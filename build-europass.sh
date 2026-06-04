#!/usr/bin/env bash
# Entry point for building final-pdfs/europass-cv.pdf from europass/cv.xml.
# Sources .envrc.local for EUROPASS_EMAIL / EUROPASS_PASSWORD if present
# (the file is gitignored so credentials never enter version control).

set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

if [ -f .envrc.local ]; then
  set -a
  . ./.envrc.local
  set +a
fi

if [ -z "${EUROPASS_EMAIL:-}" ] || [ -z "${EUROPASS_PASSWORD:-}" ]; then
  cat >&2 <<EOF
EUROPASS_EMAIL and EUROPASS_PASSWORD must be set.
Either export them in your shell, or create .envrc.local with:

    EUROPASS_EMAIL=you@example.com
    EUROPASS_PASSWORD=...

.envrc.local is gitignored.
EOF
  exit 2
fi

exec python3 europass/build.py "$@"
