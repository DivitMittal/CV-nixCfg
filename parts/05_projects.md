## Significant Projects

### hs-faust: Haskell DSL for Faust Audio Signal Processing
*August 2024 - October 2024*

Google Summer of Code 2025 proposal project, developed independently in collaboration with Faust project maintainers. A domain-specific language providing type-safe Haskell bindings for Faust's Signal API and compiler infrastructure.

- **Haskell DSL:** Type-safe wrapper over Faust's C Signal API, enabling functional construction of audio DSP graphs with compile-time verification
- **Audio DSP:** Professional-grade audio processing supporting signal generators, math operations, delays, filters, and recursive compositions
- **Compiler Integration:** Interfaces with Faust compiler to generate LLVM IR and C++ code from Haskell-defined signal graphs
- **Type Safety:** Leverages Haskell's type system to prevent common DSP errors (feedback loops, sample rate mismatches) at compile time
- **Reproducibility:** Built with Nix Flakes for deterministic builds and dependency management
- **Impact:** Enables functional programmers to access Faust's mature audio compilation infrastructure while maintaining type safety and composability
- **Tech Stack:** Haskell, Foreign Function Interface (FFI), Faust, C/C++ interop, LLVM, Nix

**Link:** https://github.com/DivitMittal/hs-faust

---

### OS-nixCfg: State-of-the-Art Infrastructure as Code Configuration
*April 2024 - Present*

Comprehensive declarative Nix configuration achieving deterministically reproducible operating systems across heterogeneous platforms.

- **Cross-Platform Unification:** Unified configuration for 4+ platforms (macOS via nix-darwin, Android via nix-on-droid, NixOS, WSL2) achieving complete reproducibility
- **Industry Recognition:** Starred by DRW employees, demonstrating industry validation of advanced Nix expertise
- **Technical Depth:** Implements flake-parts modular architecture, agenix/ragenix secrets management, nix-topology network visualization, and CI/CD with GitHub Actions
- **Architecture:** 100+ custom Home Manager modules, custom package derivations, overlays, and declarative system configurations
- **Impact:** Eliminates environment drift across personal infrastructure, enabling instant system recovery and consistent development environments
- **Ecosystem Contributions:** Custom package derivations, overlays, and Home Manager modules spanning development tools, GUI applications, and system services
- **Tech Stack:** Nix, nix-darwin, NixOS, home-manager, flake-parts, agenix, nix-topology

**Link:** https://github.com/DivitMittal/OS-nixCfg (17★)

**Related Infrastructure Projects:**
- [Vim-Cfg](https://github.com/DivitMittal/Vim-Cfg): Pure Lua Neovim configuration deployed via nix4nvchad
- [Emacs-Cfg](https://github.com/DivitMittal/Emacs-Cfg): Elisp doomemacs configuration via nix-doom-emacs-unstraightened
- [TermEmulator-Cfg](https://github.com/DivitMittal/TermEmulator-Cfg): Terminal emulator configuration (Kitty & WezTerm)

---

### TLTR: Cross-Platform Multi-Layer Programmer's Keyboard Layout
*September 2024 - Present*

A bespoke 38-key, 4-layer keyboard layout engineered for programmer ergonomics and cross-platform interoperability, supporting both software remapping and custom QMK firmware.

- **Layout Design:** Colemak Mod-DH (Curl/Wide/Angle) base with four functional layers: English, Navigation & Modifiers, Numbers & Symbols, and Mouse/Media/Display control
- **Cross-Platform Deployment:** Implemented via Kanata (macOS/Windows/Linux), Karabiner-Elements (macOS), and QMK firmware (RP2040-based Piantor split keyboard)
- **Hardware Implementation:** Physically built on a Piantor (Cantor variant) column-staggered ergo-split keyboard with Cherry MX1A Red switches; firmware targeting the RP2040 microcontroller
- **Interoperability:** Designed for seamless use across ANSI US, Corne, Cantor, and Ferris layouts; automated keymap diagram generation via GitHub Actions (keymap-drawer)
- **Impact:** Eliminates mouse dependency, reduces finger travel for symbols/numbers, and enables complex shortcuts without awkward hand positions
- **Tech Stack:** QMK (C), Kanata, Karabiner-Elements, Nix Flakes, keymap-drawer

**Link:** https://github.com/DivitMittal/TLTR (11★)

---

### hammerspoon-nix: Declarative macOS Automation via Nix Home Manager
*June 2025 - Present*

A reusable Nix home-manager module that declaratively manages Hammerspoon — macOS's Lua-scriptable automation framework — alongside a personal pure-Lua Hammerspoon configuration.

- **Nix Module:** First-class `programs.hammerspoon` home-manager option supporting package management, configPath, and declarative Spoon installation from GitHub or local paths
- **Composable API:** Exposes typed NixOS-style options (`enable`, `package`, `configPath`, `spoons`) for reproducible macOS workspace automation across machines
- **Lua Configuration:** Personal Hammerspoon config for window management, hotkeys, and system automation, deployed purely via Nix without manual setup
- **CI:** Automated flake-check and flake-lock-update workflows via GitHub Actions
- **Tech Stack:** Nix, Lua, Hammerspoon, macOS, home-manager, flake-parts

**Link:** https://github.com/DivitMittal/hammerspoon-nix (10★)

---

### firefox-nixCfg: Declarative Firefox Configuration via Nix Home Manager
*June 2025 - Present*

A modular Nix home-manager configuration for Firefox targeting enhanced performance, minimal UI, and keyboard-driven automation — distributed as a reusable flake.

- **Declarative Configuration:** All Firefox preferences, extensions, and userChrome/userContent CSS managed as Nix code; no manual about:config changes required
- **Performance Tuning:** Integrates BetterFox hardened performance profile with privacy and telemetry settings locked declaratively
- **Automation:** Tridactyl (Vim-style keyboard navigation) and Sideberry (tree-style tabs) configured via autoconfig JS/userChrome CSS
- **Distribution:** Standalone flake consumable by any home-manager configuration via flake inputs
- **Tech Stack:** Nix, JavaScript (autoconfig), CSS (userChrome), Firefox, home-manager, flake-parts

**Link:** https://github.com/DivitMittal/firefox-nixCfg (14★)

---

### ghOrg-terraform: Infrastructure as Code for GitHub Organization Management
*March 2026*

Terraform project that declaratively manages the DivitMittal GitHub organization's repositories, branch protections, and access controls via the GitHub Terraform provider.

- **Declarative IaC:** Full repository lifecycle (creation, settings, topics, visibility) and branch protection rules managed as versioned Terraform code
- **Reproducibility:** Nix flake provides a pinned, reproducible development shell with exact Terraform version and provider dependencies
- **GitOps Model:** Infrastructure state tracked in version control; eliminates manual GitHub UI configuration drift across 35+ repositories
- **Tech Stack:** Terraform, HCL, GitHub Provider, Nix Flakes

**Link:** https://github.com/DivitMittal/ghOrg-terraform

---

### tidalcycles-nix: Nix Home Manager Module for TidalCycles Live Coding
*January 2026*

A standalone, comprehensive Nix flake providing a home-manager module for the TidalCycles algorithmic live coding environment for music.

- **Declarative Environment:** Entire TidalCycles stack (SuperCollider, SuperDirt, Haskell runtime, editor integration) managed as a single reproducible Nix derivation
- **Portability:** Self-contained flake with pinned inputs; zero manual dependency installation required across machines
- **Tech Stack:** Nix, Haskell, TidalCycles, SuperCollider, home-manager

**Link:** https://github.com/DivitMittal/tidalcycles-nix (4★)

---

### Programming Languages Documentation Conversational AI
*February 2024* | **IEEE MUJ**

RAG-enhanced LLaMa-like transformer neural network based LLM for assistance on programming languages/frameworks' documentation, with a Streamlit front-end. Everything implemented from scratch.

- **Architecture:** Pre-trained LLaMa-like transformer with capability from tokenization to embedding (positional & word2vec) to output probabilities
- **RAG Implementation:** Implemented via Qdrant vector database on a DigitalOcean Docker container for efficient document retrieval
- **Impact:** Provides context-aware programming assistance with reduced hallucination through grounded retrieval
- **Tech Stack:** Python, Transformers, RAG, Qdrant, Docker, Streamlit, DigitalOcean

**Link:** https://github.com/DivitMittal/DocAssist-LLM

---

### Generation of "Hazard Map" for Lunar Lander Navigation
*October 2023* | **Smart India Hackathon (SIH)**

Hazard detection system utilizing sensory data from ISRO's Chandrayaan-2 TMC2 & OHRC payloads for safe lunar lander navigation.

- **Data Processing:** Wrangled multispectral high-resolution imagery & stereo-triplet panchromatic data of lunar terrain
- **Multi-Modal Fusion:** Fused multiple data streams and analyzed for ground truth via SRGANs & DCNNs
- **Computer Vision:** Applied semantic segmentation and super-resolution techniques for hazard identification
- **Impact:** Provides safe landing site identification for lunar missions
- **Tech Stack:** Python, TensorFlow, SRGANs, DCNNs, Computer Vision, Satellite Imagery

---

### Blinkit Customer Churn Analysis
*April 2025*

Comprehensive churn analysis for e-commerce platform using AutoML techniques and interactive business intelligence dashboards.

- **Business Analytics:** Analyzed customer attrition patterns and identified key churn drivers for targeted retention strategies
- **AutoML:** Utilized H2O.ai for automated feature engineering, model selection, and hyperparameter optimization
- **Data Visualization:** Built interactive PowerBI dashboards enabling stakeholders to explore churn metrics and customer segments
- **Exploratory Analysis:** Employed Sweetviz for comprehensive automated data profiling and feature correlation analysis
- **Impact:** Identified actionable insights for customer retention campaigns, enabling data-driven business decisions
- **Predictive Modeling:** Developed churn prediction models with interpretable feature importance for business strategy
- **Tech Stack:** Python, H2O.ai AutoML, PowerBI, Sweetviz, Data Analysis, Business Intelligence

**Link:** https://github.com/DivitMittal/Blinkit-Churn-Analysis
