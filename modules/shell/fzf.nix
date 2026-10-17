{
  flake.homeModules.fzf = {
    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
      defaultOptions = [
        "--height=40%"
        "--layout=reverse"
        "--border"
      ];
      # Ctrl-T: files and dirs
      fileWidget.options = [
        "--preview 'test -d {}; and eza --tree --level=2 --color=always {}; or bat --color=always --line-range=:200 {}'"
      ];
      # Alt-C: dirs only
      changeDirWidget.options = [
        "--preview 'eza --tree --level=2 --color=always {}'"
      ];
    };
  };
}
