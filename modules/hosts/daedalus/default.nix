{ self, inputs, ... }: {
  flake.nixosModules.daedalus =
    {
      pkgs,
      modulesPath,
      dotfilesDir,
      username,
      ...
    }:
    {
      imports = with self.nixosModules; [
        "${modulesPath}/virtualisation/amazon-image.nix"

        # services
        docker
        tailscale

        # system
        kernel
        nix-cfg
        users
      ];

      ec2.hvm = true;
      ec2.efi = false;

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

      documentation.nixos.enable = false;

      # setting up tailscale exit node
      services.tailscale = {
        extraSetFlags = [ "--advertise-exit-node" ];
      };

      boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

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
      imports = [
        self.homeModules.shell
        inputs.vscode-server.homeModules.default
        self.homeModules.nh
        self.homeModules.btop
        self.homeModules.git
        self.homeModules.micro
      ];

      home.shellAliases = {
        "..." = "cd ../..";
      };

      home.packages = with pkgs; [
        jdk25
        uv
        github-cli
        awscli2
        nix-output-monitor
        gdu
        jq
        killall
        nixd
        nixfmt
      ];

      services.vscode-server.enable = true;
    };
}
