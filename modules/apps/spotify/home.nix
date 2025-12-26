{ inputs, pkgs, ... }:
{
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      theme = spicePkgs.themes.text;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        shuffle
        oneko
      ];
    };
}
