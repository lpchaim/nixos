{
  config,
  lib,
  osConfig ? {},
  pkgs,
  ...
}: let
  cfg = config.my.bars.dux-shell.plugins;
  pluginCfg = config.programs.dank-material-shell.plugins;
in {
  options.my.bars.dux-shell.plugins = {
    enable = lib.mkEnableOption "Dux shell plugins" // {default = config.my.bars.dux-shell.enable;};
  };

  config = lib.mkIf (cfg.enable) {
    programs.dank-material-shell = {
      managePluginSettings = true;
      plugins = {
        bitwarden = {
          enable = true;
          settings = {
            enabled = true;
          };
        };
        dankKDEConnect = {
          enable = osConfig.programs.kdeconnect.enable or false;
          settings = {
            enabled = true;
          };
        };
        enderPulse = {
          enable = true;
          settings = {
            enabled = true;
          };
        };
        quickCapture = {
          enable = true;
          settings = {
            enabled = true;
            doneAction = "clipboard";
            includeCursor = false;
            modalDisplayMode = "modal";
            resetLastRegion = false;
            skipConfirm = true;
          };
        };
      };
      session.showThirdPartyPlugins = true;
    };

    home = {
      file."/home/lpchaim/.config/dms/plugin_settings.json".onChange = ''
        cp --remove-destination $(readlink ${config.home.file."/home/lpchaim/.config/dms/plugin_settings.json".target}) ${config.home.file."/home/lpchaim/.config/dms/plugin_settings.json".target}
        chmod u+w ${config.home.file."/home/lpchaim/.config/dms/plugin_settings.json".target}
      '';
      packages =
        lib.optionals pluginCfg.bitwarden.enable [
          pkgs.bitwarden-cli
          pkgs.jq
        ]
        ++ lib.optionals pluginCfg.dankKDEConnect.enable [
          (osConfig.programs.kdeconnect.package or pkgs.kdeconnect-kde)
        ];
    };
  };
}
