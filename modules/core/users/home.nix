{ pkgs, ... }:
{
  home.packages = [
    pkgs.nodejs_22
    pkgs.pnpm
    pkgs.nixfmt
    pkgs.nixd
    pkgs.gdu
    pkgs.direnv
    pkgs.fzf
  ];
}
