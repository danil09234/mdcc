---
description: Install the system dependencies mdcc needs (WeasyPrint libraries, optional Mermaid CLI) and warm the pinned build cache.
---

# mdcc setup

The `mdcc` command itself is provided by this plugin (a pinned build run via `uv`), so it does
**not** need to be installed. This command installs the **system-level dependencies** that the
compiler shells out to, which cannot be bundled in a plugin.

Perform the following on the user's machine, explaining each step and asking before running
anything that modifies the system. Adapt package managers to the platform (assume macOS +
Homebrew unless told otherwise).

## 1. WeasyPrint native libraries (required for PDF output)

WeasyPrint needs Pango/Cairo/GObject shared libraries.

- **macOS:** `brew install weasyprint`
  (The plugin's `mdcc` launcher already exports `DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib`,
  so no manual env setup is required after this.)
- **Linux:** install the distro equivalents (Pango, Cairo, GDK-PixBuf, libffi) — see
  https://doc.courtbouillon.org/weasyprint/stable/first_steps.html

## 2. Mermaid CLI (optional — only for `mermaid` diagram blocks)

`mmdc` renders diagrams by driving a headless Chrome via Puppeteer, so it needs **both** the
CLI and a browser:

1. `npm install -g @mermaid-js/mermaid-cli` (provides `mmdc` on PATH).
2. `npx puppeteer browsers install chrome-headless-shell` — installs the Chrome build Puppeteer
   needs. Without it, `mmdc` fails with `Could not find Chrome` and mdcc falls back to a styled
   code block. If `mmdc` reports a specific required version (e.g. `131.0.6778.204`), install
   that exact one: `npx puppeteer browsers install chrome-headless-shell@<version>`.

Skip this whole section if the user does not use Mermaid diagrams; the code-block fallback is
harmless.

## 3. Verify + warm the cache

Run `mdcc --version` (provided by the plugin's `bin/mdcc` launcher). The first run resolves and
builds the pinned mdcc release via `uv run --with` and caches it, so subsequent compiles are
fast. Confirm it prints a version without library errors.

If `uv` is not installed, direct the user to https://docs.astral.sh/uv/ (`curl -LsSf
https://astral.sh/uv/install.sh | sh`) — it is the only prerequisite the plugin cannot provide.
