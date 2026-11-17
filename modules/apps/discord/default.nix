{ inputs, ... }: {
  flake.homeModules.discord = {
    imports = [ inputs.nixcord.homeModules.nixcord ];
    programs.nixcord = {
      enable = true;
      discord = {
        enable = true;
        krisp.enable = true;
        equicord.enable = true;
        commandLineArgs = [
          "--ozone-platform=x11"
          "--enable-features=VaapiVideoDecoder,MiddleClickAutoscroll"
        ];
      };

      quickCss = ''
        /*css*/
        .panels_pog62O {
          left: calc(var(--custom-guild-list-width) + 0.5rem);
          width: calc(100% - var(--custom-guild-list-width) - 1rem);
        }

        .guilds_pog62O {
          margin: 0;
        }

        .buttons_g6VwXp {
          gap:0;
        }

        :root {
          --font-primary: "JetbrainsMono Nerd Font", Arial, sans-serif;
          --font-display: "JetbrainsMono Nerd Font", Arial, sans-serif;
          --font-headline: "JetbrainsMono Nerd Font", Arial, sans-serif;
          --font-code: "JetBrainsMono Nerd Font", Arial, monospace;
        }
      '';

      config = {
        autoUpdate = true;
        autoUpdateNotification = true;
        useQuickCss = true;
        themeLinks = [
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha-sky.theme.css"
        ];
        enableReactDevtools = true;
      };
      config.plugins = {
        accountPanelServerProfile.enable = true;
        betterSessions.enable = true;
        betterSettings.enable = true;
        biggerStreamPreview.enable = true;
        callTimer.enable = true;
        characterCounter.enable = true;
        clientTheme.enable = true;
        customSounds.enable = true;
        concatenatedComponentExtractor.enable = true;
        crashHandler.enable = true;
        dearrow.enable = true;
        decor.enable = true;
        experiments.enable = true;
        expressionManager.enable = true;
        fakeNitro.enable = true;
        fakeProfileThemes.enable = true;
        fixDiscordCss.enable = true;
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        forceOwnerCrown.enable = true;
        gameActivityToggle.enable = true;
        imageZoom.enable = true;
        ircColors.enable = true;
        messageLatency.enable = true;
        messageLogger = {
          enable = true;
          collapseDeleted = true;
          ignoreBots = false;
        };
        moreCommands.enable = true;
        moyai = {
          enable = true;
          volume = 0.2869718309859155;
          quality = "HD";
          triggerWhenUnfocused = false;
        };
        noMiddleClickPaste.enable = true;
        noTrack.enable = true;
        noTypingAnimation.enable = true;
        openInApp.enable = true;
        partyMode.enable = true;
        permissionFreeWill.enable = true;
        petpet.enable = true;
        pictureInPicture.enable = true;
        pinDms.enable = true;
        plainFolderIcon.enable = true;
        platformIndicators.enable = true;
        quickReply.enable = true;
        readAllNotificationsButton.enable = true;
        secretRingToneEnabler.enable = true;
        serverInfo.enable = true;
        settings.enable = true;
        shikiCodeblocks = {
          theme = "https://cdn.jsdelivr.net/gh/shikijs/textmate-grammars-themes@bc5436518111d87ea58eb56d97b3f9bec30e6b83/packages/tm-themes/themes/dark-plus.json";
        };
        showHiddenChannels.enable = true;
        showHiddenThings.enable = true;
        showMeYourName = {
          mode = "user";
          displayNames = true;
          inReplies = true;
        };
        spotifyControls = {
          hoverControls = true;
          useSpotifyUris = true;
        };
        spotifyCrack.enable = true;
        spotifyShareCommands.enable = true;
        supportHelper.enable = true;
        typingTweaks.enable = true;
        userVoiceShow.enable = true;
        usrbg.enable = true;
        viewRaw.enable = true;
        whoReacted.enable = true;
        youtubeAdblock.enable = true;
      };

      userPlugins = {
        customSounds = "github:ScattrdBlade/customSounds/5da9fc7ba7726ce8160971b9ca7cd5329785f223";
      };

      extraConfig.plugins = {
        customSounds = {
          overrides = {
            message1 = {
              enabled = true;
              selectedSound = "halloween_message1";
              volume = 100;
            };
            call_calling = {
              enabled = true;
              selectedSound = "halloween_call_calling";
              volume = 100;
            };
            call_ringing = {
              enabled = true;
              selectedSound = "halloween_call_ringing";
              volume = 100;
            };
            deafen = {
              enabled = true;
              selectedSound = "halloween_deafen";
              volume = 100;
            };
            disconnect = {
              enabled = true;
              selectedSound = "halloween_disconnect";
              volume = 100;
            };
            mute = {
              enabled = true;
              selectedSound = "halloween_mute";
              volume = 100;
            };
            undeafen = {
              enabled = true;
              selectedSound = "halloween_undeafen";
              volume = 100;
            };
            unmute = {
              enabled = true;
              selectedSound = "halloween_unmute";
              volume = 100;
            };
            user_join = {
              enabled = true;
              selectedSound = "halloween_user_join";
              volume = 100;
            };
            user_leave = {
              enabled = true;
              selectedSound = "halloween_user_leave";
              volume = 100;
            };
          };
        };
        showHiddenThings = {
          disableDiscoveryFilters = true;
          disableDisallowedDiscoveryFilters = true;
        };
      };
    };
  };

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
        commandLineArgs = "--ozone-platform=x11 --enable-features=VaapiVideoDecoder";
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
