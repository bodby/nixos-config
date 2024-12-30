{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.users.bodby;
  dirs = config.home-manager.users.bodby.xdg.userDirs;
in
{
  home-manager.users.bodby.wayland.windowManager.hyprland = {
    enable = cfg.desktop.enable;
    xwayland.enable = cfg.desktop.enable;
    plugins = [ pkgs.hyprlandPlugins.hyprscroller ];

    settings = {
      monitor = [
        "desc:Samsung Electric Company LC32G7xT HNATC00129, 2560x1440@239.96Hz, 0x0, 1"
        ", preferred, auto, 1"
      ];

      general = {
        layout = "scroller";
        no_focus_fallback = true;
        gaps_in = 4;
        gaps_out = 48;
        border_size = 0;
      };

      decoration = {
        rounding = 12;
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        blur = {
          enabled = true;
          size = 12;
          passes = 3;
          noise = 0.0;
          contrast = 1.0;
          brightness = 1.0;
          ignore_opacity = true;
          vibrancy = 2.0;
          special = false;
          xray = true;
        };

        layerrule = [
          "blur, waybar"
          "ignorezero, waybar"
        ];
      };

      plugin.scroller = {
        column_default_width = "twothirds";
        focus_wrap = false;
        center_row_if_space_available = true;
        column_widths = "onethird onehalf twothirds one";
      };

      "$mod" = "SUPER";
      "$grimscr" = "grim -t png ${dirs.pictures}/screenshots/$(date -dnow +%Y-%m-%d_%I-%M-%S).png";
      "$grimsec" = "grim -g \"$(slurp)\" -t png ${dirs.pictures}/screenshots/$(date -dnow +%Y-%m-%d_%I-%M-%S).png";

      input = {
        kb_layout = "us";
        kb_options = "grp:caps_switch";
        repeat_rate = 30;
        repeat_delay = 250;
        sensitivity = -0.2;
        accel_profile = "flat";
        follow_mouse = 2;
      };

      cursor.hide_on_key_press = true;
      cursor.no_warps = true;
      cursor.no_hardware_cursors = lib.mkIf (builtins.elem "nvidia" (config.services.xserver.videoDrivers)) true;

      bind = [
        "$mod, Q, exec, foot"
        "$mod, E, exec, librewolf"
        "$mod, C, killactive"
        "$mod SHIFT, M, exit"
        # 61 is forward slash. You can get this using either 'wev' or 'xev'.
        "$mod, code:61, exec, $grimsec"
        "$mod SHIFT, code:61, exec, $grimscr"

        "$mod, T, togglefloating"
        "$mod, F, fullscreen, 1"
        "$mod SHIFT, F, fullscreen, 0"
        "$mod, S, pin"

        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        "$mod, G, scroller:movefocus, end"
        "$mod, B, scroller:movefocus, begin"
        "$mod, R, scroller:cyclewidth, next"
        "$mod SHIFT, R, scroller:cycleheight, next"

        "$mod SHIFT, C, scroller:alignwindow, c"
        "$mod, P, scroller:pin"
        "$mod, tab, scroller:toggleoverview"

        "$mod, I, scroller:admitwindow"
        "$mod, O, scroller:expelwindow"

        "$mod, U, workspace, e-1"
        "$mod, D, workspace, e+1"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
      ];

      exec-once = "swaybg -m fill -i ${dirs.pictures}/wallpapers/house.jpg";
      # FIXME: Do I need this when I have HM configuring Waybar?
      # I see that enables systemd units but I've never seen them actually work.
      # exec-once = "waybar";

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "rounding 0, class:^(steam)$"
        "noshadow on, class:^(steam)$"
        "workspace 4 silent, class:^(steam)$"
        "workspace 3 silent, class:^(WebCord)$"
      ];

      animations = {
        enabled = true;
        bezier = [
          "snappy, 0.0, 1.0, 0.0, 1.0"
          "linear, 0.0, 0.0, 0.0, 1.0"
        ];
        animation = [
          "windowsIn, 1, 4, snappy, popin 50%"
          "windowsOut, 1, 4, snappy, popin 50%"
          "windowsMove, 1, 4, snappy"
          "fade, 1, 1, linear"
          "workspaces, 1, 4, snappy, slidefadevert 10%"
          "specialWorkspace, 1, 4, snappy, slidevert"
        ];
      };

      misc = {
        background_color = "rgb(080808)";
        animate_manual_resizes = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        enable_swallow = true;
        swallow_regex = "^(foot)$";
        middle_click_paste = false;
        disable_hyprland_qtutils_check = true;
        vfr = true;
      };

      env = [
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,24"
      ]
      ++ lib.optionals (builtins.elem "nvidia" config.services.xserver.videoDrivers) [
        "LIBVA_DRIVER_NAME,nvidia"
        # "XDG_SESSION_TYPE,wayland"
        # "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];

      ecosystem.no_update_news = true;
    };
  };
}