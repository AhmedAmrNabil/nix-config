{
  lib,
  pkgs,
  localPkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk
    gpu-screen-recorder
    localPkgs.gpu-screen-recorder-ui
    localPkgs.gpu-screen-recorder-notification
  ];
  security.wrappers.gsr-kms-server = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+ep";
    source = lib.getExe' pkgs.gpu-screen-recorder "gsr-kms-server";
  };

  security.wrappers.gsr-global-hotkeys = {
    owner = "root";
    group = "root";
    capabilities = "cap_setuid+ep";
    source = lib.getExe' localPkgs.gpu-screen-recorder-ui "gsr-global-hotkeys";
  };
}