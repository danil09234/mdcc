#!/usr/bin/env bash
# SessionStart check for the mdcc plugin.
#
# Non-blocking by design: it only inspects the environment and prints a short
# hint if a system dependency is missing. It never installs anything and always
# exits 0 so it cannot disrupt a session.

missing=()

# uv provides the pinned mdcc build (via the bin/mdcc launcher).
if ! command -v uv >/dev/null 2>&1 && ! command -v uvx >/dev/null 2>&1; then
  missing+=("uv (https://docs.astral.sh/uv/ — the mdcc launcher needs it)")
fi

# WeasyPrint's native libraries. On macOS the Homebrew formula drops GObject
# into /opt/homebrew/lib; treat its absence as "system deps not installed yet".
if [[ "$(uname)" == "Darwin" ]]; then
  if ! ls /opt/homebrew/lib/libgobject-2.0*.dylib >/dev/null 2>&1; then
    missing+=("WeasyPrint system libraries (brew install weasyprint)")
  fi
fi

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "mdcc: some dependencies are not set up yet:"
  for m in "${missing[@]}"; do
    echo "  - ${m}"
  done
  echo "Run /mdcc-setup to install them."
fi

exit 0
