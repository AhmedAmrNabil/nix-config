{
  config,
  lib,
  username,
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
    users.users."${username}" = {
      isNormalUser = true;
      description = "User ${username}";
      home = "/home/${username}";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };

    assertions = [
      {
        assertion = username != null;
        message = "core.users requires `username` to be defined.";
      }
    ];
  };

}
