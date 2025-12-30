{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    pnpm
    nixfmt
    nixd
    gdu
    direnv
    fzf
  ];
}
