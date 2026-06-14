{
  pkgs,
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ../desktop/vm.nix # only used for testing as i am building on desktop
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_7_0;
  boot.loader.timeout = lib.mkForce 10;
  boot.zfs.forceImportRoot = false;

  de.kde = {
    enable = true;
    autoLogin = true;
  };
  core.fonts.enable = true;
  core.users.enable = true;
  core.hardware.nvidia.enable = true;

  environment.systemPackages = with pkgs; [
    micro
    git
    firefox
    killall
    usbutils
    wayland-utils
    wl-clipboard
  ];

  services.speechd.enable = lib.mkForce false;
}
