{
  flake.nixosModules.distrobox = {
    hardware.nvidia-container-toolkit.enable = true;
  };

  flake.homeModules.distrobox =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      home = config.home.homeDirectory;
    in
    {
      programs.distrobox = {
        enable = true;
        settings = {
          container_manager = "docker";
        };
        containers = {
          ros-noetic = {
            # to run gui apps inside the container
            # add this env var before using it
            # LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
            additional_packages = "git";
            additional_flags = "--device nvidia.com/gpu=all";
            image = "docker.io/osrf/ros:noetic-desktop-full";
            home = "${home}/ros-home";
            init_hooks = [
              "ln -sf ${pkgs.fish}/bin/fish /usr/local/bin/fish"
              "grep -qx /usr/local/bin/fish /etc/shells || echo /usr/local/bin/fish >> /etc/shells"
              "chsh -s /usr/local/bin/fish ${config.home.username}"
            ];
            volume = lib.concatStringsSep " " [
              "${home}/.config:${home}/ros-home/.config"
            ];
          };
        };
      };
    };
}
