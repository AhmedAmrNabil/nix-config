{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.vscode;
in
{
  options.apps.vscode = {
    enable = lib.mkEnableOption "VSCode with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        programs.vscode.enable = true;

        xdg.configFile."Code/User/settings.json".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/apps/vscode/settings.json";

        xdg.configFile."Code/User/keybindings.json".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/apps/vscode/keybindings.json";

        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          adpyke.codesnap
          # alimozdemir.vscode-nuxt-dx-tools
          # antfu.goto-alias
          # arahata.linter-actionlint
          arrterian.nix-env-selector
          bbenoist.nix
          # be5invis.vscode-custom-css
          bradgashler.htmltagwrap
          bradlc.vscode-tailwindcss
          # brandonkirbyson.vscode-animations
          # catppuccin.catppuccin-vsc
          # cheshirekow.cmake-format
          # csstools.postcss
          # cweijan.vscode-postgresql-client2
          dbaeumer.vscode-eslint
          # dlasagno.rasi
          # dsznajder.es7-react-js-snippets
          # dtoplak.vscode-glsllint
          eamodio.gitlens
          editorconfig.editorconfig
          esbenp.prettier-vscode
          # fnando.linter
          # formulahendry.auto-rename-tag
          github.copilot
          github.copilot-chat
          github.vscode-github-actions
          grapecity.gc-excelviewer
          # heybourn.headwind
          # icrawl.discord-vscode
          jnoortheen.nix-ide
          # jorgeserrano.vscode-csharp-snippets
          lokalise.i18n-ally
          mads-hartmann.bash-ide-vscode
          mechatroner.rainbow-csv
          mikestead.dotenv
          mkhl.direnv
          ms-azuretools.vscode-containers
          ms-azuretools.vscode-docker
          ms-dotnettools.vscode-dotnet-runtime
          # ms-python.autopep8
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-pylance
          # ms-python.vscode-python-envs
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow
          ms-vscode-remote.remote-containers
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode-remote.remote-wsl
          ms-vscode-remote.vscode-remote-extensionpack
          ms-vscode.cmake-tools
          ms-vscode.cpptools
          ms-vscode.cpptools-extension-pack
          # ms-vscode.cpptools-themes
          ms-vscode.hexeditor
          ms-vscode.live-server
          ms-vscode.makefile-tools
          ms-vscode.remote-explorer
          # ms-vscode.remote-server
          # ms-vscode.vscode-typescript-next
          mshr-h.veriloghdl
          naumovs.color-highlight
          # nuxt.mdc
          # nuxtr.nuxt-vscode-extentions
          # nuxtr.nuxtr-vscode
          oderwat.indent-rainbow
          # p2l2.vhdl-by-hgb
          # pinage404.nix-extension-pack
          pkief.material-icon-theme
          # postman.postman-for-vscode
          prisma.prisma
          # raczzalan.webgl-glsl-editor
          # sdras.vue-vscode-snippets
          # shakram02.bash-beautify
          # slevesque.shader
          smcpeak.default-keys-windows
          # thang-nm.catppuccin-perfect-icons
          tomoki1207.pdf
          # typespec.typespec-vscode
          usernamehw.errorlens
          # vendicated.vencord-companion
          # vitest.explorer
          vscode-icons-team.vscode-icons
          vue.volar
          wix.vscode-import-cost
        ];
      };
  };
}
