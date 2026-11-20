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
            # if gui apps show blackscreen try this env var
            # LD_LIBRARY_PATH=/usr/local/lib/nvidia-compat
            # if it still doesnt work try this env var
            # LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH <app>
            additional_packages = "ros-noetic-moveit ros-noetic-ruckig";
            additional_flags = "--device nvidia.com/gpu=all";
            image = "docker.io/osrf/ros:noetic-desktop-full";
            home = "${home}/ros-home";
            exported_bins = "/usr/local/bin/code-ros";
            init_hooks = [
              "ln -sfn ${code-ros} /usr/local/bin/code-ros"
              "ln -sfn ${home}/.nix-profile/bin/fish /usr/local/bin/fish"
              "grep -qx /usr/local/bin/fish /etc/shells || echo /usr/local/bin/fish >> /etc/shells"
              "chsh -s /usr/local/bin/fish ${config.home.username}"
              # fix nvidia shit
              "mkdir -p /usr/local/lib/nvidia-compat"
              "ln -sfn /usr/lib/x86_64-linux-gnu/libdrm.so.2 /usr/local/lib/nvidia-compat/libdrm.so.2"
              "ln -sfn /usr/lib/x86_64-linux-gnu/libdbus-1.so.3 /usr/local/lib/nvidia-compat/libdbus-1.so.3"
              "ln -sfn /usr/lib/x86_64-linux-gnu/libX11.so.6 /usr/local/lib/nvidia-compat/libX11.so.6"
              "ln -sfn /usr/lib/x86_64-linux-gnu/libxcb.so.1 /usr/local/lib/nvidia-compat/libxcb.so.1"
              "ln -sfn /usr/lib/x86_64-linux-gnu/libXau.so.6 /usr/local/lib/nvidia-compat/libXau.so.6"
              "ln -sfn /usr/lib/x86_64-linux-gnu/libXdmcp.so.6 /usr/local/lib/nvidia-compat/libXdmcp.so.6"
            ];
            volume = lib.concatStringsSep " " [
              "${home}/.config:${home}/ros-home/.config"
            ];
          };
        };
      };
    };
}

# source devel/setup.bash
# export DISABLE_ROS1_EOL_WARNINGS=1

# if [ -n "$CONTAINER_ID" ]; then
#   wrap_dir="$(direnv_layout_dir)/ros-wrappers"
#   mkdir -p "$wrap_dir"

#   for cmd in rviz rqt gazebo gzclient gzserver roslaunch rosrun; do
#     cat > "$wrap_dir/$cmd" <<EOF
# #!/usr/bin/env bash
# # drop this wrapper dir from PATH so we call the real binary, not ourselves
# PATH=\${PATH//$wrap_dir:/}
# export LD_LIBRARY_PATH=/usr/local/lib/nvidia-compat\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}
# exec $cmd "\$@"
# EOF
#     chmod +x "$wrap_dir/$cmd"
#   done

#   PATH_add "$wrap_dir"
# fi