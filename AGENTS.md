# Project Summary

## What this repo is

A LaTeX CV for Divit Mittal, managed with a Nix flake. The source of truth is `tex/cv.tex` (moderncv class, pdflatex/xelatex). The `parts/` directory contains Markdown snapshots of CV sections for reference/drafting; the canonical renderable file is `tex/cv.tex`. Compiled PDFs are saved to `final-pdfs/`.

## Dev environment

Enter the devshell (provides `texlive`, `nixd`, `alejandra`, and installs git hooks):

```sh
nix develop
# or with direnv: direnv allow
```

## Build

Compile the CV to PDF from inside the devshell:

```sh
cd tex && pdflatex cv.tex
# or for better font handling:
cd tex && xelatex cv.tex
# or with latexmk (auto-reruns as needed):
cd tex && latexmk -pdf cv.tex
```

## Formatting & checks

```sh
# Format all Nix files
nix fmt

# Run all flake checks (pre-commit hooks, formatting)
nix flake check
```

Pre-commit hooks run automatically on commit: trailing whitespace, merge conflict detection, large file check, and GitHub Actions workflow rendering (`render-workflows` re-generates `.github/workflows/*.yml` from `flake/actions/*.nix`).

## Architecture

```
flake.nix              # Entry point — uses flake-parts + import-tree to load flake/
flake/
  devshells.nix        # devshell with full LaTeX toolchain + Nix tools
  checks.nix           # pre-commit hooks via git-hooks.nix
  formatters.nix       # treefmt config (alejandra, deadnix, statix)
  actions/
    common.nix         # Shared GitHub Actions steps/triggers/permissions
    flake-check.nix    # CI: runs `nix flake check`
    flake-lock-update.nix  # CI: updates flake.lock
tex/
  cv.tex               # The CV — moderncv (classic, blue), 11pt, a4paper
parts/                 # Markdown drafts of CV sections (not compiled)
final-pdfs/            # Exported PDF snapshots
```

The flake uses `import-tree` to auto-import all `*.nix` files under `flake/`, so adding a new `.nix` file there is sufficient — no explicit import needed in `flake.nix`.

GitHub Actions workflows are **generated** from `flake/actions/*.nix` by the `render-workflows` pre-commit hook. Edit the Nix sources, not the generated YAML.
