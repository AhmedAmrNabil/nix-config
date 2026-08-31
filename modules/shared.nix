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
      ];

      home.shellAliases = {
        restart-windows = "sudo systemctl reboot --boot-loader-entry=auto-windows";
      };

      home.packages = with pkgs; [
        comma
        fzf
        gdu
        jq
        killall
        nixd
        nixfmt
        nodejs_22
        pnpm
        python3
        usbutils
        pciutils
        wayland-utils
        wl-clipboard
      ];
    };
}
