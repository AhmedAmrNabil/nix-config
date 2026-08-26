{
  ...
}:
{
  flake.nixosModules.users =
    {
      pkgs,
      username,
      homeDir,
      ...
    }:
    {
      programs.fish.enable = true;
      users.users.${username} = {
        isNormalUser = true;
        description = "User ${username}";
        home = homeDir;
        extraGroups = [
          "wheel"
          "networkmanager"
          "input"
          "dialout"
          "audio"
          "video"
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
          message = "users requires `username` to be defined.";
        }
      ];
    };
}
