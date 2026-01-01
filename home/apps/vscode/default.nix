{
  config,
  pkgs,
  pkgsUnstable,
  lib,
  ...
}:
let
  cfg = config.apps.vscode;
  vscodeMarketplace = pkgs.nix-vscode-extensions.vscode-marketplace;
in
{
  options.apps.vscode = {
    enable = lib.mkEnableOption "VSCode with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgsUnstable.vscode;
      mutableExtensionsDir = true;
      profiles.default.extensions = [
        vscodeMarketplace.adpyke.codesnap
        vscodeMarketplace.alimozdemir.vscode-nuxt-dx-tools
        vscodeMarketplace.antfu.goto-alias
        vscodeMarketplace.arahata.linter-actionlint
        vscodeMarketplace.arrterian.nix-env-selector
        vscodeMarketplace.bbenoist.nix
        vscodeMarketplace.be5invis.vscode-custom-css
        vscodeMarketplace.bradgashler.htmltagwrap
        vscodeMarketplace.bradlc.vscode-tailwindcss
        vscodeMarketplace.brandonkirbyson.vscode-animations
        vscodeMarketplace.catppuccin.catppuccin-vsc
        vscodeMarketplace.chadalen.vscode-jetbrains-icon-theme
        vscodeMarketplace.cheshirekow.cmake-format
        vscodeMarketplace.csstools.postcss
        vscodeMarketplace.cweijan.vscode-postgresql-client2
        vscodeMarketplace.dbaeumer.vscode-eslint
        vscodeMarketplace.dlasagno.rasi
        vscodeMarketplace.dsznajder.es7-react-js-snippets
        vscodeMarketplace.dtoplak.vscode-glsllint
        vscodeMarketplace.eamodio.gitlens
        vscodeMarketplace.editorconfig.editorconfig
        vscodeMarketplace.esbenp.prettier-vscode
        vscodeMarketplace.ewen-lbh.hyprland
        vscodeMarketplace.ewen-lbh.vscode-hyprls
        vscodeMarketplace.fireblast.hyprlang-vscode
        vscodeMarketplace.fnando.linter
        vscodeMarketplace.formulahendry.auto-rename-tag
        vscodeMarketplace.github.vscode-github-actions
        vscodeMarketplace.grapecity.gc-excelviewer
        vscodeMarketplace.heybourn.headwind
        vscodeMarketplace.icrawl.discord-vscode
        vscodeMarketplace.jeff-hykin.better-nix-syntax
        vscodeMarketplace.jnoortheen.nix-ide
        vscodeMarketplace.kdl-org.kdl
        vscodeMarketplace.lokalise.i18n-ally
        vscodeMarketplace.mads-hartmann.bash-ide-vscode
        vscodeMarketplace.mechatroner.rainbow-csv
        vscodeMarketplace.mikestead.dotenv
        vscodeMarketplace.mkhl.direnv
        vscodeMarketplace.ms-azuretools.vscode-containers
        vscodeMarketplace.ms-azuretools.vscode-docker
        vscodeMarketplace.ms-dotnettools.vscode-dotnet-runtime
        vscodeMarketplace.ms-python.autopep8
        vscodeMarketplace.ms-python.debugpy
        vscodeMarketplace.ms-python.python
        vscodeMarketplace.ms-python.vscode-pylance
        vscodeMarketplace.ms-python.vscode-python-envs
        vscodeMarketplace.ms-toolsai.jupyter
        vscodeMarketplace.ms-toolsai.jupyter-keymap
        vscodeMarketplace.ms-toolsai.jupyter-renderers
        vscodeMarketplace.ms-toolsai.vscode-jupyter-cell-tags
        vscodeMarketplace.ms-toolsai.vscode-jupyter-slideshow
        vscodeMarketplace.ms-vscode-remote.remote-containers
        vscodeMarketplace.ms-vscode-remote.remote-ssh
        vscodeMarketplace.ms-vscode-remote.remote-ssh-edit
        vscodeMarketplace.ms-vscode-remote.remote-wsl
        vscodeMarketplace.ms-vscode-remote.vscode-remote-extensionpack
        vscodeMarketplace.ms-vscode.cmake-tools
        vscodeMarketplace.ms-vscode.cpptools
        vscodeMarketplace.ms-vscode.cpptools-extension-pack
        vscodeMarketplace.ms-vscode.cpptools-themes
        vscodeMarketplace.ms-vscode.hexeditor
        vscodeMarketplace.ms-vscode.live-server
        vscodeMarketplace.ms-vscode.makefile-tools
        vscodeMarketplace.ms-vscode.remote-explorer
        vscodeMarketplace.ms-vscode.remote-server
        vscodeMarketplace.ms-vscode.vscode-typescript-next
        vscodeMarketplace.mshr-h.veriloghdl
        vscodeMarketplace.naumovs.color-highlight
        vscodeMarketplace.nuxt.mdc
        vscodeMarketplace.nuxtr.nuxt-vscode-extentions
        vscodeMarketplace.nuxtr.nuxtr-vscode
        vscodeMarketplace.oderwat.indent-rainbow
        vscodeMarketplace.p2l2.vhdl-by-hgb
        vscodeMarketplace.pinage404.nix-extension-pack
        vscodeMarketplace.pkief.material-icon-theme
        vscodeMarketplace.prisma.prisma
        vscodeMarketplace.raczzalan.webgl-glsl-editor
        vscodeMarketplace.sdras.vue-vscode-snippets
        vscodeMarketplace.shakram02.bash-beautify
        vscodeMarketplace.slevesque.shader
        vscodeMarketplace.smcpeak.default-keys-windows
        vscodeMarketplace.tamasfe.even-better-toml
        vscodeMarketplace.thang-nm.catppuccin-perfect-icons
        vscodeMarketplace.tomoki1207.pdf
        vscodeMarketplace.typespec.typespec-vscode
        vscodeMarketplace.usernamehw.errorlens
        vscodeMarketplace.vendicated.vencord-companion
        vscodeMarketplace.vitest.explorer
        vscodeMarketplace.vscode-icons-team.vscode-icons
        vscodeMarketplace.vue.volar
        vscodeMarketplace.wix.vscode-import-cost
        vscodeMarketplace.yuyichao.digitaljs
      ];
    };

    xdg.configFile."Code/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/apps/vscode/settings.json";

    xdg.configFile."Code/User/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/apps/vscode/keybindings.json";
  };
}
