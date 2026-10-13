{
  flake.homeModules.zsh =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;

        # Inline Fish-like suggestions
        autosuggestion.enable = true;

        # Highlight commands while typing
        syntaxHighlighting.enable = true;

        # Search history with the arrow keys
        historySubstringSearch = {
          enable = true;
          searchUpKey = [ "^[[A" ];
          searchDownKey = [ "^[[B" ];
        };

        # Interactive fuzzy tab completion
        plugins = [
          {
            name = "fzf-tab";
            src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
          }
        ];

        initExtra = ''
          # Better case-insensitive and partial completion
          zstyle ':completion:*' matcher-list \
            'm:{a-zA-Z}={A-Za-z}' \
            'r:|[._-]=* r:|=*' \
            'l:|=* r:|=*'

          # Use the completion menu supplied by fzf-tab
          zstyle ':completion:*' menu no
        '';
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      # Additional command completions
      home.packages = with pkgs; [
        zsh-completions
      ];
    };

}
