{
  config,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.modules.users.bodby.desktop;
in
{
  home-manager.users.bodby.programs.librewolf = {
    enable = cfg.enable;
    package = pkgs.librewolf';

    profiles.bodby = {
      isDefault = true;
      extensions = with inputs.nur.legacyPackages.${system}.repos.rycee.firefox-addons; [
        ublock-origin
        vimium
      ];

      # TODO: Transparent title bar and also proper styles for websites.
      userContent = builtins.readFile ./userContent.css;
      userChrome = builtins.readFile ./userChrome.css;

      search.default = "DuckDuckGo";
      search.force = true;

      settings = {
        "layout.css.devPixelsPerPx" = cfg.libreWolfScaleFactor;
        "browser.tabs.allow_transparent_browser" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.theme.content-theme" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "webgl.disabled" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads" = false;
        "privacy.resistFingerprinting" = true;

        "middlemouse.paste" = false;
        "general.autoScroll" = true;
      };
    };

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab";
      DisplayMenuBar = "default-off";
      SearchBar = "separate";

      Cookies.Allow = [
        "https://github.com"
        "https://discord.com"
        "https://design.penpot.app"
      ];
    };
  };
}