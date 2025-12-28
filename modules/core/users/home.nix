{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    pnpm
    eza
    nixfmt
    nixd
    gdu
    direnv
    fzf
    tree
  ];
}
