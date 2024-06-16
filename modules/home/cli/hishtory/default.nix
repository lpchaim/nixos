{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "cli" "hishtory" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "hishtory";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        hishtory
      ];
      sessionVariables = {
        HISHTORY_PATH = ".config/hishtory";
      };
    };

    programs.mcfly.enable = false;

    programs.zsh = mkIf config.my.modules.cli.zsh.enable {
      initExtra = ''
        if [[ $(hishtory config-get enable-control-r) != "true" ]]; then
          hishtory config-set enable-control-r true;
        fi
        hishtory config-set filter-duplicate-commands true
        hishtory config-set timestamp-format '2006-01-02 15:04'

        source ${pkgs.hishtory}/share/hishtory/config.zsh

        hishtory enable
      '';
    };
  };
}
