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
with lib;
{
  users.users.bodby = {
    packages =
      with pkgs;
      [
        file
        bc
        killall
        time
        iamb

        age
        sops

        inputs.nvim-btw.packages.${system}.default
      ]
      ++ optionals cfg.desktop.enable [
        # webcord-vencord
        # alsa-utils
        # ghostty
        wl-clipboard
        grim
        slurp
        swaybg
        mpv
        imv
        imagemagick
      ]
      ++ optionals cfg.gaming.enable [
        steam'
        prismlauncher
      ]
      ++ optionals cfg.creative.enable [
        # krita'
        blockbench
        # gimp'
      ];

    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "video"
    ] ++ cfg.extraGroups;
  };
}
