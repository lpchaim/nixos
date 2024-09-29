{
  config,
  lib,
  pkgs,
  ...
}: let
  namespace = ["my" "modules" "cli" "tealdeer"];
  cfg = lib.getAttrFromPath namespace config;
in {
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "nushell";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.tealdeer];
    home.file.".config/tealdeer/config.toml".source = ./config.toml;
  };
}
