{
  lib,
  ...
}:
{
  flake.nixosModules.gpu-screen-recorder =
    {
      config,
      self',
      pkgsUnstable,
      ...
    }:
    {
      environment.systemPackages = with pkgsUnstable; [
        gpu-screen-recorder
        (gpu-screen-recorder-ui.override {
          inherit (config.security) wrapperDir;
        })
        gpu-screen-recorder-notification
      ];

      security.wrappers."gsr-kms-server" = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = lib.getExe' self'.packages.gpu-screen-recorder "gsr-kms-server";
      };

      security.wrappers."gsr-global-hotkeys" = {
        owner = "root";
        group = "root";
        capabilities = "cap_setuid+ep";
        source = lib.getExe' self'.packages.gpu-screen-recorder-ui "gsr-global-hotkeys";
      };
    };
}
