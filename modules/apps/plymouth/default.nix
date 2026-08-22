{
  flake.nixosModules.plymouth =
    {
      pkgs,
      ...
    }:
    {
      boot.plymouth = {
        enable = true;
        logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
        extraConfig = ''
          DeviceScale = 1;
        '';
      };

      boot.kernelParams = [
        "quiet"
        "splash"
      ];
    };
}
