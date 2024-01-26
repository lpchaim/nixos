{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "cli" "hishtory" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "hishtory";
  };

  config = lib.mkIf cfg.enable {
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
        hishtory_tquery() {
          hishtory tquery
          zle reset-prompt
        }
        zle -N hishtory_tquery
        bindkey '^r' hishtory_tquery

        hishtory config-set filter-duplicate-commands true
        hishtory config-set timestamp-format '2006-01-02 15:04'
      '';
    };
  };
}
