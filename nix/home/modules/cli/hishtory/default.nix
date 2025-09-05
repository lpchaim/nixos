{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.modules.cli.hishtory;
in {
  options.my.modules.cli.hishtory.enable = mkEnableOption "hishtory";

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        hishtory
      ];
      sessionVariables = {
        HISHTORY_PATH = ".config/hishtory";
      };
    };

    programs = let
      commonPre = ''
        hishtory config-set filter-duplicate-commands true
        hishtory config-set timestamp-format '2006-01-02 15:04'
        # hishtory config-set enable-control-r true > /dev/null
      '';
      commonPost = ''
        hishtory enable
      '';
    in {
      mcfly.enable = false;
      fish.interactiveShellInit = ''
        ${commonPre}

        set enabled (hishtory config-get enable-control-r)
        if not $enabled
          hishtory config-set enable-control-r true
        end

        source ${pkgs.hishtory}/share/hishtory/config.fish
        eval $(${pkgs.hishtory}/bin/hishtory completion fish)

        ${commonPost}
      '';
      zsh.initContent = ''
        ${commonPre}

        if [[ $(hishtory config-get enable-control-r) != "true" ]]; then
          hishtory config-set enable-control-r true
        fi

        source ${pkgs.hishtory}/share/hishtory/config.zsh
        eval $(${pkgs.hishtory}/bin/hishtory completion zsh)

        ${commonPost}
      '';
    };
  };
}
