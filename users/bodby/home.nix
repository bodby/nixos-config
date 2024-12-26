{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.modules.users.bodby;
in
{
  home-manager.users.bodby = {
    sops = {
      age.keyFile = "/home/bodby/.config/sops/age/keys.txt";
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      secrets."this_is_awesome/really" = {
        path = "/home/bodby/temp/itworks.txt";
      };
    };

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userName = "Baraa Homsi";
        userEmail = "baraa.homsi@proton.me";
        extraConfig = {
          init.defaultBranch = "master";
          url = {
            "git@github.com:".insteadOf = [
              "github:"
              "https://github.com/"
            ];

            "https://gitlab.com/".insteadOf = "gitlab:";
          };
        };
      };

      # bash = {
      #   enable = false;
      #   enableCompletion = true;
      #   historyControl = [ "erasedups" ];
      #   shellAliases.ls = "ls --color=always -h -A -p --time-style=long-iso";
      #   initExtra = "set -o vi";
      # };

      # dircolors = {
      #   enable = true;
      #   enableBashIntegration = true;
      #   enableZshIntegration = false;
      #   enableFishIntegration = false;
      #   settings = {
      #     DIR = "00;37";
      #     LINK = "00;35";
      #     EXEC = "01;97";
      #     RESET = "00;97";
      #   };
      # };

      librewolf = {
        enable = cfg.desktop.enable;
        package = pkgs.librewolf';
        settings = {
          "layout.css.devPixelsPerPx" = "1.125";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          "webgl.disabled" = true;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.resistFingerprinting" = true;

          "middlemouse.paste" = false;
          "general.autoScroll" = true;
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = cfg.desktop.enable;
      xwayland.enable = cfg.desktop.enable;
      plugins = [ pkgs.hyprlandPlugins.hyprscroller ];

      settings = {
        monitor = [
          "DP-2, 2560x1440@239.96Hz, 0x0, 1"
          ", preferred, auto, 1"
        ];
        source = [
          "./programs.conf"
          "./input.conf"
          "./layout.conf"
          "./rules.conf"
          "./theme.conf"
        ] ++ lib.optional (builtins.elem "nvidia" config.services.xserver.videoDrivers) "./nvidia.conf";
      };
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "/home/bodby/.desktop";
      documents = "/home/bodby/docs";
      download = "/home/bodby/temp";
      templates = "/home/bodby/.templates";
      publicShare = "/home/bodby/.public";
      music = "/home/bodby/docs/music";
      pictures = "/home/bodby/docs/images";
      videos = "/home/bodby/docs/videos";
    };

    fonts.fontconfig = {
      enable = cfg.desktop.enable;
      defaultFonts = {
        serif = [ "Ubuntu Sans" ];
        sansSerif = [ "Ubuntu Sans" ];
        monospace = [ "JetBrains Mono" ];
      };
    };

    home = {
      packages = with pkgs; [
        inputs.iosevka-custom.packages.${system}.default
        ubuntu-sans
        jetbrains-mono
      ];

      pointerCursor = {
        gtk.enable = cfg.desktop.enable;
        x11.enable = cfg.desktop.enable;
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };

      username = "bodby";
      homeDirectory = "/home/bodby";
      stateVersion = config.system.stateVersion;
    };
  };
}
