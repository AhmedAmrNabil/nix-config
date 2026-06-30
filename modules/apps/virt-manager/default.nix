{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.apps.virt-manager;
in
{
  options.apps.virt-manager = {
    enable = mkEnableOption "Virtualization manager";
  };
  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;
    users.users.${username}.extraGroups = [ "libvirtd" ];

    virtualisation.libvirtd = {
      enable = true;
      extraConfig = ''
        log_filters="3:qemu 1:libvirt"
        log_outputs="2:file:/var/log/libvirt/libvirtd.log"
      '';

      qemu = {
        # Runs QEMU as your user to avoid permission issues
        runAsRoot = false;
        swtpm.enable = true; # needed for Windows 11 TPM
      };
      hooks.qemu = {
        "win11-passthrough" = pkgs.writeShellScript "win11-passthrough" ''
          #bash
          GUEST="$1"
          PHASE="$2"   # prepare / start / started / stopped / release / migrate / restore / reconnect / attach
          DISPMGR="plasmalogin"

          [[ "$GUEST" != "win11" ]] && exit 0

          case "$PHASE" in
            prepare)
              systemctl stop "$DISPMGR.service"
              while systemctl is-active --quiet "$DISPMGR.service"; do
                sleep 1
              done
              sleep 2
              modprobe -r nvidia_uvm
              modprobe -r nvidia_drm
              modprobe -r nvidia_modeset
              modprobe -r nvidia
              modprobe -r i2c_nvidia_gpu
              modprobe vfio
              modprobe vfio_pci
              modprobe vfio_iommu_type1
              ;;
            release)
              modprobe -r vfio_pci
              modprobe -r vfio
              modprobe -r vfio_iommu_type1
              modprobe i2c_nvidia_gpu
              modprobe nvidia
              modprobe nvidia_modeset
              modprobe nvidia_drm
              modprobe nvidia_uvm
              systemctl start "$DISPMGR.service"
              ;;
          esac
        '';
      };
    };

    environment.systemPackages = with pkgs; [
      dnsmasq
      virtiofsd # for virtiofs shared folders
    ];

    boot.initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    boot.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    boot.kernelParams = [
      "amd_iommu=on"
      "iommu=pt" # passthrough mode — reduces overhead for devices not being passed through
    ];
    environment.sessionVariables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };
  };
}
