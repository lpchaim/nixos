{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.my.gui.media;
in {
  options.my.gui.media.enable = lib.mkEnableOption "gui media apps" // {default = config.my.gui.enable;};
  config = lib.mkIf cfg.enable {
    programs = {
      mpv.enable = true;
      spicetify = let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
      in {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          aiBandBlocker
          groupSession
          popupLyrics
          shuffle # shuffle+ (special characters are sanitized out of extension names)
        ];
      };
    };
    home.packages = with pkgs; [
      mpv
      vlc
    ];
  };
}
