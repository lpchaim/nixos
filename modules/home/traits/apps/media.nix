{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.traits.apps.media;
in {
  options.my.traits.apps.media.enable = lib.mkEnableOption "media trait";
  config = lib.mkIf cfg.enable {
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
