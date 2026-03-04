{
  config,
  lib,
  username,
  pkgs,
  ...
}:
let
  cfg = config.core.users;
in
{
  options.core.users = {
    enable = lib.mkEnableOption "User account management";
  };
  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
    users.users."${username}" = {
      isNormalUser = true;
      description = "User ${username}";
      home = "/home/${username}";
      extraGroups = [
        "wheel"
        "networkmanager"
        "input"
        "dialout"
      ];
      shell = pkgs.fish;
    };

    security.sudo.enable = true;
    security.sudo.extraConfig = ''
      Defaults pwfeedback
    '';

    assertions = [
      {
        assertion = username != null;
        message = "core.users requires `username` to be defined.";
      }
    ];
  };

}
