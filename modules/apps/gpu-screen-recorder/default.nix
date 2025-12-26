{
  lib,
  pkgs,
  localPkgs,
  config,
  username,
  ...
}:
let
  cfg = config.apps.gpu-screen-recorder;
in
{
  options.apps.gpu-screen-recorder = {
    enable = lib.mkEnableOption "GPU Screen Recorder (with UI + hotkeys)";
  };

  config = lib.mkIf cfg.enable {

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

    home-manager.users."${username}" =
      { ... }:
      {
        systemd.user.services.gpu-screen-recorder-ui = {
          Unit = {
            Description = "GPU Screen Recorder UI";
            After = [ "graphical.target" ];
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
          Service = {
            ExecStart = "${lib.getExe' localPkgs.gpu-screen-recorder-ui "gsr-ui"} launch-daemon";
            Restart = "on-failure";
            RestartSec = "5s";
            KillSignal = "SIGINT";
          };
        };
      };
  };
}