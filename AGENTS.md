# Project Summary

## What this repo is

**CV-nixCfg** — an open-source LaTeX CV framework managed with a Nix flake. The framework is generic; personal data (CV sections, contact info, Europass XML) lives in a separate private `cv-data` flake input. The compiled template is `tex/cv.tex` (moderncv class, pdflatex/xelatex) which `\input{}`s section files from the cv-data input via a devshell symlink at `tex/cv-data/`.

- `data.example/` — placeholder cv-data structure (copy to a private repo and override the flake input)
- `europass/build.py` — Playwright automation for Europass PDF, reads from `$CV_DATA_DIR`

## Dev environment

Enter the devshell (provides `texlive`, `python3`+Playwright, `xmllint`, `nixd`, `alejandra`, sets `CV_DATA_DIR`, and creates `tex/cv-data/` symlink):

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

Build the Europass PDF (requires `EUROPASS_EMAIL`/`EUROPASS_PASSWORD` in shell or `.envrc.local`):

```sh
./build-europass.sh
```

## Using your own cv-data

1. Create a private repo matching `data.example/` layout
2. Override the flake input:
   ```sh
   nix flake lock --override-input cv-data "git+ssh://git@github.com/you/cv-data"
   ```

## Formatting & checks

```sh
nix fmt          # format all Nix files
nix flake check  # pre-commit hooks + formatting
```

Pre-commit hooks run automatically on commit: trailing whitespace, merge conflict detection, large file check, and GitHub Actions workflow rendering (`render-workflows` re-generates `.github/workflows/*.yml` from `flake/actions/*.nix`).

## Architecture

```
flake.nix              # Entry point — flake-parts + import-tree; declares cv-data input
flake/
  devshells.nix        # devshell: texlive, Python+Playwright, xmllint, Nix tools
                       #   sets CV_DATA_DIR; symlinks tex/cv-data/ → cv-data input
  checks.nix           # pre-commit hooks via git-hooks.nix
  formatters.nix       # treefmt config (alejandra, deadnix, statix)
  actions/
    common.nix         # Shared GitHub Actions steps/triggers/permissions
    flake-check.nix    # CI: runs `nix flake check`
    flake-lock-update.nix  # CI: updates flake.lock
tex/
  cv.tex               # Template — moderncv preamble + \input{cv-data/...} hooks
  cv-data/             # Symlink → $CV_DATA_DIR/tex/ (gitignored, created by devshell)
europass/
  build.py             # Playwright automation for Europass PDF
  schema/              # Vendored Europass XSD v3.4.0
data.example/          # Placeholder cv-data layout for users forking the framework
  tex/                 # One .tex file per CV section
  europass/cv.xml
```

The flake uses `import-tree` to auto-import all `*.nix` files under `flake/`, so adding a new `.nix` file there is sufficient — no explicit import needed in `flake.nix`.

GitHub Actions workflows are **generated** from `flake/actions/*.nix` by the `render-workflows` pre-commit hook. Edit the Nix sources, not the generated YAML.
