{
  config,
  inputs,
  lib,
  osConfig ? {},
  ...
}: let
  inherit (inputs.self.lib) isNvidia;
  inherit (inputs.self.lib.config) wallpaper;
  cfg = config.my.bars.dank-material-shell;
  isNvidia' = isNvidia osConfig;
in {
  options.my.bars.dank-material-shell.enable = lib.mkEnableOption "Dank material shell";

  config = lib.mkIf (cfg.enable) {
    programs.dank-material-shell = {
      enable = true;
      enableAudioWavelength = true;
      enableCalendarEvents = false;
      enableClipboardPaste = true;
      enableDynamicTheming = true;
      enableSystemMonitoring = true;
      enableVPN = false;

      # See https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SettingsSpec.js
      settings = import ./settings.nix;

      # See https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SessionSpec.js
      session =
        (import ./session.nix)
        // {
          doNotDisturb = false;
          isLightMode = false;
          nightModeEnabled = false;
          wallpaperPath = wallpaper;
          nvidiaGpuTempEnabled = isNvidia';
          nonNvidiaGpuTempEnabled = !isNvidia';
        };

      clipboardSettings = {
        maxHistory = 50;
      };

      systemd = {
        enable = true;
        restartIfChanged = true;
      };
    };

    my.de.hyprland = {
      hyprlock.enable = false;
      hypridle.lockCmd = "[[ $(dms ipc call lock isLocked) != 'false' ]] || dms ipc call lock lock";
    };
  };
}
