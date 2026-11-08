{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars) wallpaper;
  cfg = config.my.bars.dux-shell;
in {
  imports = [
    ./plugins.nix
    ./settings
  ];

  options.my.bars.dux-shell.enable = lib.mkEnableOption "Dux shell";

  config = lib.mkIf (cfg.enable) {
    stylix.targets.dank-material-shell.enable = false;

    programs.dank-material-shell = {
      enable = true;
      enableAudioWavelength = true;
      enableCalendarEvents = false;
      enableDynamicTheming = true;
      enableSystemMonitoring = true;
      enableVPN = true;

      # See https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SessionSpec.js
      session = {
        doNotDisturb = false;
        isLightMode = false;
        nightModeEnabled = false;
        timeLocale = "pt";
        wallpaperPath = wallpaper;
        nvidiaGpuTempEnabled = config.my.profiles.hardware.gpu.nvidia;
        nonNvidiaGpuTempEnabled = !config.my.profiles.hardware.gpu.nvidia;
        hiddenTrayIds = [
          "KDE Connect Indicator"
          "openrgb"
          "vesktop_status_icon_1"
        ];
      };

      clipboardSettings = {
        disabled = false;
        clearAtStartup = false;
        maxHistory = 25;
        maxEntrySize = 10 * 1048576;
        autoClearDays = 7;
        maxPinned = 5;
      };

      systemd = {
        enable = true;
        restartIfChanged = true;
      };
    };

    my.de.hyprland = {
      hypridle.enable = false;
      hypridle.lockCmd = "[[ $(dms ipc call lock isLocked) != 'false' ]] || dms ipc call lock lock";
      hyprlock.enable = false;
      hyprpaper.enable = false;
    };

    home = {
      file."${config.xdg.stateHome}/dms/session.json".mutable = true;
      packages = with pkgs; [
        efibootmgr
      ];
    };
  };
}
