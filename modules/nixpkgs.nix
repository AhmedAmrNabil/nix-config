{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      localPkgsPath = "/home/btngana/coding/nix/nixpkgs";
      hasLocal = builtins.pathExists localPkgsPath;

      overlays = (import ../overlays) ++ [
        (final: prev: import ../packages { pkgs = prev; })
        (final: prev: {
          inherit (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
        inputs.antigravity-nix.overlays.default
        inputs.helium.overlays.default
      ];
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      pkgsUnstable = import inputs.nixpkgs-unstable {
        inherit system overlays;
        config.allowUnfree = true;
      };
      pkgsLocal =
        if hasLocal then
          import inputs.nixpkgs-local {
            inherit system overlays;
            config.allowUnfree = true;
          }
        else
          null;
    in
    {
      packages = import ../packages { inherit pkgs; };
      _module.args = {
        inherit pkgs pkgsUnstable pkgsLocal;
      };
    };
}
