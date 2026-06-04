{
  common-permissions,
  common-actions,
  ...
}: {
  flake.actions-nix.workflows.".github/workflows/flake-lock-update.yml" = {
    on.workflow_dispatch = {};
    jobs.locking-flake = {
      permissions =
        common-permissions
        // {
          issues = "write";
          pull-requests = "write";
        };
      steps =
        common-actions
        ++ [
          {
            name = "Update flake.lock";
            uses = "DeterminateSystems/update-flake-lock@main";
            # cv-data is a private SSH repo; skip it so CI doesn't need
            # SSH credentials. Update it locally with nix flake lock.
            "with".inputs = "nixpkgs import-tree flake-parts systems devshell treefmt-nix git-hooks actions-nix";
          }
        ];
    };
  };
}
