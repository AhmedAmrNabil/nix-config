{
  flake.nixosModules.gpu-screen-recorder = {
    programs.gpu-screen-recorder = {
      enable = true;
      ui.enable = true;
    };
  };
}
