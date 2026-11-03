## career-ops (https://github.com/career-ops-hq/career-ops): AI job-search agent.
##
## The source is pinned by the `career-ops` flake input; bump it by editing the
## tag in flake.nix and running `nix flake lock --update-input career-ops`.
##
## career-ops expects a writable checkout (node_modules, per-run logs, an AI CLI
## started from its root), so the pinned store copy is mirrored into the
## gitignored `.career-ops/` working copy whenever the pin changes. Personal
## data (cv.md, profile, tracker, reports) lives in $CAREER_OPS_ROOT, outside
## this public repo, and survives every re-sync.
{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    playwrightVersion = pkgs.playwright-driver.version;

    # nixpkgs 26.05 names the binary `playwright-mcp`; career-ops' doctor and
    # docs look for `mcp-server-playwright`, the name the npm package installs.
    mcp-server-playwright = pkgs.writeShellScriptBin "mcp-server-playwright" ''
      exec ${lib.getExe pkgs.playwright-mcp} "$@"
    '';

    career-ops = pkgs.writeShellApplication {
      name = "career-ops";
      # bun installs deps and runs package.json scripts; the scripts themselves
      # still invoke `node`, which Playwright needs (it does not support Bun).
      runtimeInputs = [pkgs.bun pkgs.nodejs pkgs.rsync pkgs.coreutils];
      text = ''
        src="${inputs.career-ops}"
        app="''${PRJ_ROOT:?run inside the CV-nixCfg devshell}/.career-ops"
        stamp="$app/.nix-source"

        sync() {
          echo "career-ops: syncing pinned source into $app" >&2
          mkdir -p "$app"
          # node_modules and .mcp.json are excluded so --delete keeps them.
          rsync -a --delete --chmod=u+w \
            --exclude /node_modules --exclude /.mcp.json --exclude /.nix-source \
            "$src/" "$app/"

          # postinstall would try `playwright install`, which cannot run against
          # the Nix store; browsers come from PLAYWRIGHT_BROWSERS_PATH instead.
          (cd "$app" && bun install --ignore-scripts)
          # npm Playwright must match the nixpkgs browser revision exactly;
          # --no-save leaves package.json identical to upstream.
          (cd "$app" && bun add --no-save --exact --ignore-scripts \
            "playwright@${playwrightVersion}")

          # Absolute store path, so the MCP server resolves even if the AI CLI
          # is started without the devshell PATH.
          cat > "$app/.mcp.json" <<EOF
        {
          "mcpServers": {
            "playwright": { "command": "${lib.getExe mcp-server-playwright}" }
          }
        }
        EOF
          echo "$src" > "$stamp"
        }

        ensure_synced() {
          if [ "$(cat "$stamp" 2>/dev/null)" != "$src" ] || [ ! -d "$app/node_modules" ]; then
            sync
          fi
          mkdir -p "''${CAREER_OPS_ROOT:?CAREER_OPS_ROOT is not set}"
        }

        case "''${1:-}" in
          sync)
            sync
            ;;
          run)
            shift
            ensure_synced
            cd "$app" && exec bun run "$@"
            ;;
          path)
            echo "$app"
            ;;
          -h | --help | help)
            cat <<EOF
        Usage:
          career-ops [agent args...]   start \''${CAREER_OPS_AGENT:-claude} in the career-ops workspace
          career-ops run <script> ...  bun run <script> (e.g. doctor, scan)
          career-ops sync              force re-sync from the pinned source
          career-ops path              print the working-copy path
        EOF
            ;;
          *)
            ensure_synced
            agent="''${CAREER_OPS_AGENT:-claude}"
            command -v "$agent" >/dev/null || {
              echo "career-ops: '$agent' not found on PATH (set CAREER_OPS_AGENT)" >&2
              exit 1
            }
            cd "$app" && exec "$agent" "$@"
            ;;
        esac
      '';
    };
  in {
    devshells.default = {
      env = [
        {
          # Export it before entering the shell to use another location,
          # e.g. a private git repo (career-ops docs/BACKUP_STRATEGIES.md).
          name = "CAREER_OPS_ROOT";
          eval = "\${CAREER_OPS_ROOT:-$HOME/career-data}";
        }
        {
          name = "PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD";
          value = "1";
        }
      ];
      commands = [
        {
          package = career-ops;
          category = "job search";
          help = "AI job-search agent (career-ops run doctor | sync | path)";
        }
      ];
      devshell.packages = [
        pkgs.bun
        pkgs.nodejs
        mcp-server-playwright
        ## pdftotext / pdftoppm for reading a PDF CV during onboarding
        pkgs.poppler-utils
      ];
    };
  };
}
