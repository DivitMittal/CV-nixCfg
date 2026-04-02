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
      devshell = rec {
        name = "DivitMittal-CV";
        motd = "{202}Welcome to {91}${name} {202}devshell!{reset} \n $(menu)";
        startup = {
          git-hooks.text = ''
            ${config.pre-commit.installationScript}
          '';
        };
        packages = lib.attrsets.attrValues {
          inherit
            (pkgs)
            ### LSPs & Formatters
            ## Nix
            nixd
            alejandra
            ;
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
