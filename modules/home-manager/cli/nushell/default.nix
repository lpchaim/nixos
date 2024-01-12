{ config, lib, pkgs, ... }:

let
  namespace = [ "my" "modules" "cli" "nushell" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "nushell";
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      configFile.text = "";
      envFile.text = "";
      extraConfig = (builtins.readFile ./config.nu);
      extraEnv = (builtins.readFile ./env.nu);
    };
  };
}
