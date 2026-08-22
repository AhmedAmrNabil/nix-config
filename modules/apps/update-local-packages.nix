{
  perSystem =
    { pkgs, ... }:
    {
      packages.update-local-packages = pkgs.writeShellApplication {
        name = "update-local-packages";
        runtimeInputs = [
          pkgs.nix
          pkgs.git
          pkgs.nix-update
        ];
        text = ''
          #bash
          set -Eeu
          root="$(git rev-parse --show-toplevel)"
          cd "$root"/packages

          packages=(
            gpu-screen-recorder
            gpu-screen-recorder-notification
            gpu-screen-recorder-ui
          )

          for pkg in "''${packages[@]}"; do
            echo "--- updating $pkg ---"
            nix-update --flake --use-update-script "$pkg" || echo "  (failed, continuing)"
          done

          if [[ -f "update-git-commits.txt" ]]; then
            rm "update-git-commits.txt"
          fi
        '';
      };
    };
}
