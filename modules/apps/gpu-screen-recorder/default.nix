{
  lib,
  ...
}:
{
  flake.nixosModules.gpu-screen-recorder =
    {
      config,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.gpu-screen-recorder
        (pkgs.gpu-screen-recorder-ui.override {
          inherit (config.security) wrapperDir;
        })
        pkgs.gpu-screen-recorder-notification
      ];

      security.wrappers."gsr-kms-server" = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = lib.getExe' pkgs.gpu-screen-recorder "gsr-kms-server";
      };

      security.wrappers."gsr-global-hotkeys" = {
        owner = "root";
        group = "root";
        capabilities = "cap_setuid+ep";
        source = lib.getExe' pkgs.gpu-screen-recorder-ui "gsr-global-hotkeys";
      };
    };
}
