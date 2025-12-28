# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  pkgs,
  ...
}:

{

  imports = [
    ../../home/profiles/wsl.nix
  ];

  core.nix-cfg.enable = true;
  wsl.enable = true;
  wsl.defaultUser = "btngana";
  wsl.wslConf.network.hostname = "wsl-nixos";
  wsl.wslConf.automount.root = "/";
  wsl.docker-desktop.enable = true;
  wsl.startMenuLaunchers = true;

  environment.systemPackages = with pkgs; [
    nano
    micro
    wget
  ];
  systemd.tmpfiles.rules = [
    "L+ /tmp/.X11-unix - - - - /wslg/.X11-unix"
  ];

  # enable remote vscode
  programs.nix-ld.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
