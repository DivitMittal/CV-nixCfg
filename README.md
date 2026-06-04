<div id="top">
    <div align="center">
  <h1 align='center'>CV-nixCfg</h1>
  <strong>A reproducible LaTeX CV framework powered by Nix flakes — personal data lives in a separate private repo.</strong>
    </div>

</div>

---

<div align='center'>
    <a href="https://github.com/DivitMittal/CV-nixCfg/">
  <img src="https://img.shields.io/badge/size-~800KB-orange?style=for-the-badge&logo=github&logoColor=white" alt="size" />
    </a>
    <a href="https://github.com/DivitMittal/CV-nixCfg/blob/main/LICENSE">
  <img src="https://img.shields.io/badge/license-MIT-orange?style=for-the-badge&logo=unlicense&logoColor=white" alt="license"/>
    </a>
    <a href="https://www.latex-project.org/">
  <img src="https://img.shields.io/badge/LaTeX-moderncv-orange?style=for-the-badge&logo=latex&logoColor=white" alt="latex"/>
    </a>
    <img src="https://img.shields.io/badge/language-TeX-orange?style=for-the-badge&logo=latex&logoColor=white" alt="repo-top-language"/>
</div>

---

<div align='center'>
    <a href="https://github.com/DivitMittal/CV-nixCfg/actions/workflows/flake-check.yml">
  <img src="https://github.com/DivitMittal/CV-nixCfg/actions/workflows/flake-check.yml/badge.svg" alt="nix-flake-check"/>
    </a>
    <a href="https://github.com/DivitMittal/CV-nixCfg/actions/workflows/flake-lock-update.yml">
  <img src="https://github.com/DivitMittal/CV-nixCfg/actions/workflows/flake-lock-update.yml/badge.svg" alt="nix-flake-lock-update"/>
    </a>
</div>

---

## Contents

- [Overview](#overview)
- [Using Your Own Data](#using-your-own-data)
- [Dev Environment](#dev-environment)
- [Build](#build)
- [Project Structure](#project-structure)

---

## Overview

A [LaTeX](https://www.latex-project.org/) CV framework using the [moderncv](https://ctan.org/pkg/moderncv) document class. The entire toolchain — `texlive`, formatters, pre-commit hooks, CI, and Europass PDF automation — is declared in a [Nix flake](https://nixos.wiki/wiki/Flakes).

Personal data (name, contact info, CV sections, Europass XML) is supplied via a separate **`cv-data` flake input** so the framework can be open-sourced while keeping your content private.

- **Template**: `tex/cv.tex` — preamble + `\input{cv-data/...}` section hooks
- **Example data**: `data.example/` — placeholder structure showing what your data repo should contain
- **Europass builder**: `europass/build.py` — Playwright automation for rendering via europass.europa.eu

---

## Using Your Own Data

1. Create a private repo (e.g. `you/cv-data`) with the layout shown in `data.example/`:

```
cv-data/
├── tex/
│   ├── header.tex       # \name, \phone, \email, \social, \extrainfo
│   ├── summary.tex
│   ├── skills.tex
│   ├── experience.tex
│   ├── research.tex
│   ├── projects.tex
│   ├── hackathons.tex
│   ├── honours.tex
│   ├── education.tex
│   └── languages.tex
├── europass/
│   └── cv.xml
└── final-pdfs/          # output PDFs written here by build scripts
```

2. Override the `cv-data` input:

```sh
nix flake lock --override-input cv-data "git+ssh://git@github.com/you/cv-data"
```

3. Enter the devshell — it creates `tex/cv-data/` → your data's `tex/` automatically:

```sh
nix develop   # or: direnv allow
```

---

## Dev Environment

```sh
nix develop
# or with direnv:
direnv allow
```

The devshell provides `texlive`, `python3` + Playwright, `xmllint`, `nixd`, `alejandra`, and installs git hooks. It also sets `CV_DATA_DIR` and symlinks `tex/cv-data/` to your data.

---

## Build

Compile the CV to PDF from inside the devshell:

```sh
# Auto-reruns as needed (recommended)
cd tex && latexmk -pdf cv.tex

# Single pass
cd tex && pdflatex cv.tex
# or: xelatex cv.tex
```

Build the Europass PDF (requires `EUROPASS_EMAIL` / `EUROPASS_PASSWORD` or `.envrc.local`):

```sh
./build-europass.sh
```

### Formatting & Checks

```sh
nix fmt          # format all Nix files
nix flake check  # pre-commit hooks + formatting
```

---

## Project Structure

```
.
├── .github/
│   └── workflows/               # Generated GitHub Actions (do not edit)
│       ├── flake-check.yml
│       └── flake-lock-update.yml
├── data.example/                # Placeholder cv-data layout (copy to your private repo)
│   ├── europass/
│   │   └── cv.xml
│   └── tex/
│       ├── header.tex
│       ├── summary.tex
│       ├── skills.tex
│       ├── experience.tex
│       ├── research.tex
│       ├── projects.tex
│       ├── hackathons.tex
│       ├── honours.tex
│       ├── education.tex
│       └── languages.tex
├── europass/
│   ├── build.py                 # Playwright automation for Europass PDF
│   └── schema/                  # Vendored Europass XSD v3.4.0
├── flake/
│   ├── actions/                 # GitHub Actions source (Nix → YAML)
│   │   ├── common.nix
│   │   ├── flake-check.nix
│   │   └── flake-lock-update.nix
│   ├── checks.nix               # Pre-commit hooks via git-hooks.nix
│   ├── devshells.nix            # devshell: texlive, Python, xmllint, Nix tools
│   └── formatters.nix           # treefmt config (alejandra, deadnix, statix)
├── tex/
│   └── cv.tex                   # LaTeX template — \input{cv-data/...} section hooks
├── build-europass.sh            # Entry point for Europass PDF build
├── flake.nix                    # Flake entry point (flake-parts + import-tree)
└── README.md
```

<div align="right">

[![][back-to-top]](#top)

</div>

[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square&color=orange
