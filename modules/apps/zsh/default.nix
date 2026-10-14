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
        syntaxHighlighting = {
          enable = true;
          styles = {
            # Default text / parameters
            default = "fg=#cdd6f4";

            # Commands and aliases
            command = "fg=#89b4fa";
            builtin = "fg=#89b4fa";
            function = "fg=#89b4fa";
            alias = "fg=#89b4fa";
            hashed-command = "fg=#89b4fa";

            # Keywords
            reserved-word = "fg=#cba6f7";

            # Arguments and strings
            single-quoted-argument = "fg=#a6e3a1";
            double-quoted-argument = "fg=#a6e3a1";
            dollar-quoted-argument = "fg=#a6e3a1";

            # Operators and redirections
            redirection = "fg=#f5c2e7";
            commandseparator = "fg=#fab387";
            named-fd = "fg=#f5c2e7";
            numeric-fd = "fg=#f5c2e7";

            # Comments
            comment = "fg=#7f849c";

            # Errors
            unknown-token = "fg=#f38ba8,bold";

            # Options
            single-hyphen-option = "fg=#a6e3a1";
            double-hyphen-option = "fg=#a6e3a1";

            # Paths and patterns
            path = "fg=#f9e2af";
            path_prefix = "fg=#f9e2af";
            globbing = "fg=#f5c2e7";

            # Escaping and substitutions
            back-quoted-argument = "fg=#eba0ac";
            history-expansion = "fg=#eba0ac";
            assign = "fg=#f2cdcd";
          };
        };

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

        initContent = ''
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
      };

      # Additional command completions
      home.packages = with pkgs; [
        zsh-completions
      ];
    };

}
