{
  flake.homeModules.btop =
    { pkgs, ... }:
    {
      programs.btop = {
        enable = true;
        package = pkgs.btop-cuda;
        settings = {
          shown_boxes = "cpu mem net proc gpu0";
          update_ms = 200;
        };
      };
    };
}
