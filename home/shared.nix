{
  pkgs,
  ...
}:
{
  apps = {
    bash.enable = true;
    bat.enable = true;
    btop.enable = true;
    direnv.enable = true;
    eza.enable = true;
    fastfetch.enable = true;
    fish.enable = true;
    git.enable = true;
    micro.enable = true;
    starship.enable = true;
    zoxide.enable = true;
  };

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
}
