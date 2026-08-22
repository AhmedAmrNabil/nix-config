{ self, homePath, ... }: {
  flake.homeModules.default = { pkgs, username, ... }: {

    home.username = username;
    home.homeDirectory = homePath;
    home.stateVersion = "25.11";

    programs.home-manager.enable = true;

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
