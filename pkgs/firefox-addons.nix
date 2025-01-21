{
  lib,
  fetchurl,
  stdenv,
}:
let
  mkFirefoxExtension =
    {
      pname,
      version,
      addonId,
      url,
      sha256,
      permissions,
      meta,
    }:
    stdenv.mkDerivation (finalAttrs: {
      inherit pname version addonId meta permissions;

      src = fetchurl { inherit url sha256; };
      passthru = { inherit (finalAttrs) addonId; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      # FIXME: Build hooks.
      buildCommand = /* bash */ ''
        # Why is this weird hash hard-coded?? What does it even do???
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        install -D -m644 "$src" "$dst/${finalAttrs.addonId}.xpi"
      '';
    });
in
{
  # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/generated-firefox-addons.nix
  # TODO: Figure out how rycee automatically updates these.
  ublock-origin = mkFirefoxExtension {
    pname = "ublock-origin";
    version = "1.62.0";
    addonId = "uBlock0@raymondhill.net";

    url = "https://addons.mozilla.org/firefox/downloads/file/4412673/ublock_origin-1.62.0.xpi";
    sha256 = "8a9e02aa838c302fb14e2b5bc88a6036d36358aadd6f95168a145af2018ef1a3";

    permissions = [
      "alarms"
      "dns"
      "menus"
      "privacy"
      "storage"
      "tabs"
      "unlimitedStorage"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "<all_urls>"
      "http://*/*"
      "https://*/*"
      "file://*/*"
      "https://easylist.to/*"
      "https://*.fanboy.co.nz/*"
      "https://filterlists.com/*"
      "https://forums.lanik.us/*"
      "https://github.com/*"
      "https://*.github.io/*"
      "https://github.com/uBlockOrigin/*"
      "https://ublockorigin.github.io/*"
      "https://*.reddit.com/r/uBlockOrigin/*"
    ];

    meta = {
      homepage = "https://github.com/gorhill/uBlock";
      description = "An efficient blocker for Chromium and Firefox";
      license = lib.licenses.gpl3;
      platforms = lib.platforms.all;
    };
  };

  vimium = mkFirefoxExtension {
    pname = "vimium";
    version = "2.1.2";
    addonId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";

    url = "https://addons.mozilla.org/firefox/downloads/file/4259790/vimium_ff-2.1.2.xpi";
    sha256 = "3b9d43ee277ff374e3b1153f97dc20cb06e654116a833674c79b43b8887820e1";

    permissions = [
      "tabs"
      "bookmarks"
      "history"
      "storage"
      "sessions"
      "notifications"
      "scripting"
      "webNavigation"
      "clipboardRead"
      "clipboardWrite"
      "<all_urls>"
      "file:///"
      "file:///*/"
    ];

    meta = {
      homepage = "https://github.com/philc/vimium";
      description = "The Hacker's Browser";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  };
}