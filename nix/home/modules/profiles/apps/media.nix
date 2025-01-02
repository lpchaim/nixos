{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.apps.media;
in {
  options.my.profiles.apps.media = lib.mkEnableOption "media profile";
  config = lib.mkIf cfg {
    programs = {
      mpv.enable = true;
      spicetify = let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          popupLyrics
          shuffle # shuffle+ (special characters are sanitized out of extension names)
        ];
      };
    };
    home.packages = with pkgs; [
      jellyfin-media-player
      vlc
    ];
  };
}
