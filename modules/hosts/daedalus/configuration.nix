{
  flake.nixosModules.daedalus =
    {
      pkgs,
      modulesPath,
      dotfilesDir,
      username,
      ...
    }:
    {
      imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
      ec2.hvm = true;
      ec2.efi = true;
      system.autoUpgrade = {
        enable = true;
        flake = "${dotfilesDir}#daedalus";
        dates = "daily";
        allowReboot = true;
      };

      users.users.${username} = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJ+WAmsc1SMShL55nTIeaWfW2Y74hkGaXm71biK6zMG ahmedamr24680@gmail.com"
        ];
      };

      # --------- Networking ------------------
      # Hostname is defined in mkSystem, so it can be set per-host.

      # amazon-image already have networking setup
      # networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
      # networking.modemmanager.enable = false; # disable unused, speeds up boot

      # for tailscale exit node
      networking.firewall.checkReversePath = false;

      networking.firewall.allowedTCPPorts = [
        25565 # minecraft
        80 # http
        443 # https
      ];

      networking.firewall.allowedUDPPorts = [
        25565 # minecraft
      ];

      # --------- Timezone and clock ------------------
      time.timeZone = "UTC";

      # --------- Services ------------------
      services.openssh.enable = true;

      # disable some services that are not needed
      systemd.services.Networkmanager-wait-online.enable = false;
      services.fwupd.enable = false;

      # --------- Packages ------------------
      environment.systemPackages = with pkgs; [
        nano
      ];

      system.stateVersion = "25.05";
    };

  flake.homeModules.daedalus =
    {
      pkgs,
      ...
    }:
    {
      home.shellAliases = {
        "..." = "cd ../..";
      };

      home.packages = with pkgs; [
        jdk25
        uv
        github-cli
        awscli2
        nix-output-monitor
      ];

      programs.nix-your-shell = {
        enable = true;
      };
    };
}
