{ inputs, ... }: {
  perSystem =
    { system, ... }:
    let
      pkgsDiscord = import inputs.nixpkgs-discord {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      customSounds = pkgsDiscord.fetchFromGitHub {
        owner = "ScattrdBlade";
        repo = "customSounds";
        rev = "5da9fc7ba7726ce8160971b9ca7cd5329785f223";
        sha256 = "sha256-FmXQKDaEB8dlJevQPWQiw+cjEAzu1Da0uN5IuWTV/K4=";
      };
    in
    {
      packages.discord = pkgsDiscord.discord.override {
        withVencord = true;
        enableAutoscroll = true;
        # workaround for keybindings not working in wayland
        commandLineArgs = "--ozone-platform=x11";
        # vencord with customSounds userplugin
        vencord = (
          pkgsDiscord.vencord.overrideAttrs (oldAttrs: {
            postPatch = (oldAttrs.postPatch or "") + ''
              mkdir -p src/userplugins
              cp -r ${customSounds} src/userplugins/customSounds
            '';
          })
        );
      };
    };
}
