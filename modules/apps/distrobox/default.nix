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
      code-ros = pkgs.writeShellScript "code-ros" ''
        exec ${home}/.nix-profile/bin/code \
          --user-data-dir=/run/host${home}/.config/Code \
          --extensions-dir=/run/host${home}/.vscode/extensions \
          "$@"
      '';
      vscode = config.programs.vscode.package;

      code-ros-desktop = pkgs.runCommand "code-ros.desktop" { } ''
        mkdir -p $out
        sed \
          -e '0,/^Name=/s|^Name=.*|Name=Visual Studio Code (ROS)|' \
          -e 's|^Exec=code |Exec=distrobox enter ros -- ${code-ros} |' \
          -e '/^MimeType=/d' \
          ${vscode}/share/applications/code.desktop > $out/code-ros.desktop
      '';
    in
    {
      xdg.dataFile."applications/code-ros.desktop".source = "${code-ros-desktop}/code-ros.desktop";
      programs.distrobox = {
        enable = true;
        enableSystemdUnit = true;
        settings = {
          container_manager = "docker";
        };
        containers = {
          ros = {
            # to run gui apps inside the container
            # add this env var before using it
            # export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
            # I need to find a way to automate this later but
            # to get vscode desktop entry:
            #  distrobox-export --bin /usr/local/bin/code-ros
            additional_packages = "git";
            additional_flags = "--device nvidia.com/gpu=all";
            image = "docker.io/osrf/ros:noetic-desktop-full";
            home = "${home}/ros-home";
            init_hooks = [
              "ln -sfn ${code-ros} /usr/local/bin/code-ros"
              "ln -sfn ${home}/.nix-profile/bin/fish /usr/local/bin/fish"
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
