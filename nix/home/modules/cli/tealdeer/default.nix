{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.cli.tealdeer;
in {
  options.my.modules.cli.tealdeer.enable = lib.mkEnableOption "nushell";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.tealdeer];
    home.file.".config/tealdeer/config.toml".source = ./config.toml;
  };
}
