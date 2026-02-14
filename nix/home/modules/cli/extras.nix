{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.my.config) flake;
  cfg = config.my.cli.extras;
in {
  options.my.cli.extras.enable = lib.mkEnableOption "CLI extras";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      asciinema
      ffmpeg
      imagemagick
      inotify-tools
      jocalsend
      nix-output-monitor
      python312Packages.howdoi
      termshot
    ];

    programs = {
      nh = {
        enable = lib.mkDefault true;
        flake = builtins.replaceStrings ["~"] [config.home.homeDirectory] flake.path;
      };
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
    };
  };
}
