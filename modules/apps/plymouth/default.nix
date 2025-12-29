{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.apps.plymouth;
in
{
  options.apps.plymouth = {
    enable = lib.mkEnableOption "Plymouth with themes";
  };
  config = lib.mkIf cfg.enable {
    boot = {
      plymouth = {
        enable = true;
        # theme = "rings";
        # themePackages = with pkgs; [
        #   # By default we would install all themes
        #   (adi1090x-plymouth-themes.override {
        #     selected_themes = [ "rings" ];
        #   })
        # ];
        font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
        logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
      };
      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
    };
  };
}
