{ self, ... }: {
  flake.homeModules.default =
    {
      pkgs,
      username,
      homeDir,
      ...
    }:
    {

      home.username = username;
      home.homeDirectory = homeDir;
      home.stateVersion = "25.11";

      programs.home-manager.enable = true;

      home.shell.enableFishIntegration = true;
      home.shell.enableBashIntegration = true;

      imports = with self.homeModules; [
        bash
        bat
        btop
        direnv
        eza
        fastfetch
        fish
        git
        micro
        starship
        zoxide
        devenv
        yazi
      ];

      home.packages = with pkgs; [
        fzf
        gdu
        jq
        killall
        nixd
        nixfmt
      ];
    };
}
