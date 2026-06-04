{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.devshell.flakeModule];

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devshells.default = {
      # Tell Playwright where Chromium lives in the Nix store and stop it
      # from trying to download its own browser at runtime.
      env = [
        {
          name = "PLAYWRIGHT_BROWSERS_PATH";
          value = "${pkgs.playwright-driver.browsers}";
        }
        {
          name = "PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS";
          value = "true";
        }
        {
          name = "CV_DATA_DIR";
          value = "${inputs.cv-data}";
        }
      ];
      devshell = rec {
        name = "CV-nixCfg";
        motd = "{202}Welcome to {91}${name} {202}devshell!{reset} \n $(menu)";
        startup = {
          git-hooks.text = ''
            ${config.pre-commit.installationScript}
          '';
          # Symlink cv-data flake input's tex/ into tex/cv-data so LaTeX
          # \input{cv-data/header} etc. resolve without absolute paths.
          link-cv-data.text = ''
            ln -sfn "${inputs.cv-data}/tex" "$PRJ_ROOT/tex/cv-data"
          '';
        };
        packages = lib.attrsets.attrValues {
          inherit
            (pkgs)
            ### LSPs & Formatters
            ## Nix
            nixd
            alejandra
            ### XML tools (xmllint for schema validation of cv.xml)
            libxml2
            ;
          ### Python + Playwright for europass/build.py
          python = pkgs.python3.withPackages (ps: [ps.playwright]);
          ### LaTeX
          texlive = pkgs.texlive.combine {
            inherit
              (pkgs.texlive)
              ## Base (engines: pdflatex, xelatex, lualatex + latexmk)
              scheme-small
              ## CV classes
              moderncv
              ## Icons (email, github, linkedin, phone)
              fontawesome5
              ## Layout
              geometry
              enumitem
              titlesec
              parskip
              ## Typography
              microtype
              lm # Latin Modern fonts
              ## Colors & hyperlinks
              xcolor
              hyperref
              ## Tables
              booktabs
              ## Graphics / timeline
              pgf
              ## Utilities
              etoolbox
              xifthen
              ifmtarg
              ;
          };
        };
      };
    };
  };
}
