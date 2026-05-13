{
  lib,
  localPkgs,
  config,
  pkgs,
  ...
}:
let
  cfg = config.apps.gpu-screen-recorder;
  package = cfg.package.override {
    inherit (config.security) wrapperDir;
  };

  uiPackage = cfg.ui.package.override {
    gpu-screen-recorder = package;
    inherit (config.security) wrapperDir;
  };
in
{
  options.apps.gpu-screen-recorder = {
    enable = lib.mkEnableOption "GPU Screen Recorder (with UI + hotkeys)";

    package = lib.mkPackageOption pkgs "gpu-screen-recorder" { };

    ui = {
      enable = lib.mkEnableOption "the GPU Screen Recorder overlay UI";
      package = lib.mkPackageOption localPkgs "gpu-screen-recorder-ui" { };
      notifPackage = lib.mkPackageOption localPkgs "gpu-screen-recorder-notification" { };

      autoStart = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to start the GPU Screen Recorder overlay UI automatically
          on login via a systemd user service.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.gpu-screen-recorder.enable = true;
      }

      (lib.mkIf cfg.ui.enable {
        environment.systemPackages = [
          cfg.ui.package
          cfg.ui.notifPackage
        ];

        security.wrappers."gsr-global-hotkeys" = {
          owner = "root";
          group = "root";
          capabilities = "cap_setuid+ep";
          source = lib.getExe' uiPackage "gsr-global-hotkeys";
        };

        systemd.user.services."gpu-screen-recorder-ui" = lib.mkIf cfg.ui.autoStart {
          description = "GPU Screen Recorder UI";
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe' uiPackage "gsr-ui"} launch-daemon";
            Restart = "on-failure";
          };
        };
      })
    ]
  );

}
