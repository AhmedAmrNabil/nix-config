{
  virtualisation.vmVariant = {
    virtualisation.memorySize = 8192; # 8GB
    virtualisation.cores = 4;
    virtualisation.qemu.options = [
      "-vga none"
      "-device virtio-vga-gl"
      "-display gtk,gl=on"
    ];
  };
}
