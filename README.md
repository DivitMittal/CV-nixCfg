<div id="top">
    <div align="center">
  <h1 align='center'>DivitMittal-CV</h1>
  <strong>My personal CV, written in LaTeX (moderncv) and managed with a Nix flake.</strong>
    </div>

</div>

---

<div align='center'>
    <a href="https://github.com/DivitMittal/DivitMittal-CV/stargazers">
  <img src="https://img.shields.io/github/stars/DivitMittal/DivitMittal-CV?&style=for-the-badge&logo=starship&logoColor=white&color=purple" alt="stars"/>
    </a>
    <a href="https://github.com/DivitMittal/DivitMittal-CV/">
  <img src="https://img.shields.io/github/repo-size/DivitMittal/DivitMittal-CV?&style=for-the-badge&logo=github&logoColor=white&color=purple" alt="size" />
    </a>
    <a href="https://github.com/DivitMittal/DivitMittal-CV/blob/main/LICENSE">
  <img src="https://img.shields.io/github/license/DivitMittal/DivitMittal-CV?&style=for-the-badge&logo=unlicense&logoColor=white&color=purple" alt="license"/>
    </a>
    <a href="https://www.latex-project.org/">
  <img src="https://img.shields.io/badge/LaTeX-moderncv-blue.svg?style=for-the-badge&logo=latex&logoColor=white&color=purple" alt="latex"/>
    </a>
    <img src="https://img.shields.io/github/languages/top/DivitMittal/DivitMittal-CV?style=for-the-badge&color=purple" alt="repo-top-language"/>
</div>

---

<div align='center'>
    <a href="https://github.com/DivitMittal/DivitMittal-CV/actions/workflows/flake-check.yml">
  <img src="https://github.com/DivitMittal/DivitMittal-CV/actions/workflows/flake-check.yml/badge.svg" alt="nix-flake-check"/>
    </a>
    <a href="https://github.com/DivitMittal/DivitMittal-CV/actions/workflows/flake-lock-update.yml">
  <img src="https://github.com/DivitMittal/DivitMittal-CV/actions/workflows/flake-lock-update.yml/badge.svg" alt="nix-flake-lock-update"/>
    </a>
</div>

---

## Contents

- [Overview](#overview)
- [Dev Environment](#dev-environment)
- [Build](#build)
- [Project Structure](#project-structure)

---

## Overview

A [LaTeX](https://www.latex-project.org/) CV for [Divit Mittal](https://www.divit.site/), using the [moderncv](https://ctan.org/pkg/moderncv) document class. The entire toolchain — `texlive`, formatters, pre-commit hooks, and CI — is declared in a [Nix flake](https://nixos.wiki/wiki/Flakes), making the build fully reproducible.

- **Source of truth**: `tex/cv.tex` (compiled with `pdflatex` or `xelatex`)
- **Section drafts**: `parts/` — Markdown snapshots for reference and drafting (not compiled)
- **Exported PDFs**: `final-pdfs/`

## Dev Environment

Enter the devshell, which provides `texlive`, `nixd`, `alejandra`, and installs git hooks:

```sh
nix develop
# or with direnv:
direnv allow
```

---

## Build

Compile the CV to PDF from inside the devshell:

```sh
# Basic compilation
cd tex && pdflatex cv.tex

# Better font handling
cd tex && xelatex cv.tex

# Auto-reruns as needed (recommended)
cd tex && latexmk -pdf cv.tex
```

### Formatting & Checks

```sh
# Format all Nix files
nix fmt

# Run all flake checks (pre-commit hooks, formatting)
nix flake check
```

Pre-commit hooks run automatically on commit: trailing whitespace, merge conflict detection, large file check, and GitHub Actions workflow rendering (`render-workflows` re-generates `.github/workflows/*.yml` from `flake/actions/*.nix`).

> **Note**: GitHub Actions workflows are **generated** from `flake/actions/*.nix`. Edit the Nix sources, not the generated YAML.

---

## Project Structure

```
.
├── .claude/                     # Claude AI assistant configuration
│   ├── CLAUDE.md
│   └── settings.json
├── .github/
│   └── workflows/               # Generated GitHub Actions workflows
│       ├── flake-check.yml
│       └── flake-lock-update.yml
├── final-pdfs/                  # Exported PDF snapshots
├── flake/
│   ├── actions/                 # GitHub Actions source definitions (Nix)
│   │   ├── actions.nix
│   │   ├── common.nix
│   │   ├── flake-check.nix
│   │   └── flake-lock-update.nix
│   ├── checks.nix               # Pre-commit hooks via git-hooks.nix
│   ├── devshells.nix            # devshell with full LaTeX toolchain + Nix tools
│   └── formatters.nix           # treefmt config (alejandra, deadnix, statix)
├── parts/                       # Markdown drafts of CV sections (not compiled)
│   ├── 00_header.md
│   ├── 01_summary.md
│   ├── 02_skills.md
│   ├── 03_experience.md
│   ├── 04_research.md
│   ├── 05_projects.md
│   ├── 06_hackathons.md
│   ├── 07_honors.md
│   ├── 08_education.md
│   ├── 09_languages.md
│   ├── 10_additional.md
│   └── 11_notes.md
├── tex/
│   └── cv.tex                   # The CV — moderncv (classic, blue), 11pt, a4paper
├── .editorconfig
├── .envrc
├── .gitattributes
├── .gitignore
├── flake.lock
├── flake.nix                    # Entry point — flake-parts + import-tree
└── README.md
```

The flake uses [`import-tree`](https://github.com/vic/import-tree) to auto-import all `*.nix` files under `flake/`, so adding a new `.nix` file there is sufficient — no explicit import needed in `flake.nix`.


<div align="right">

[![][back-to-top]](#top)

</div>

[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square&color=purple
