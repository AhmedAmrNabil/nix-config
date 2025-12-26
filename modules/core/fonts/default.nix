{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    noto-fonts
  ];

  # Optional: Enable fontconfig tweaks
  fonts.fontconfig = {
    enable = true;
  };
}
