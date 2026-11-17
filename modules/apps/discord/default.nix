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
    in
    {
      packages.discord = pkgsDiscord.discord.override {
        withVencord = true;
        enableAutoscroll = true;
        # workaround for keybindings not working in wayland
        commandLineArgs = "--ozone-platform=x11";
        vencord = pkgsDiscord.vencord;
      };
    };
}
