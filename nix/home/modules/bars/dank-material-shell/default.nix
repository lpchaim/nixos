{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars) wallpaper;
  cfg = config.my.bars.dank-material-shell;
in {
  options.my.bars.dank-material-shell.enable = lib.mkEnableOption "Dank material shell";

  config = lib.mkIf (cfg.enable) {
    stylix.targets.dank-material-shell.enable = false;

    programs.dank-material-shell = {
      enable = true;
      enableAudioWavelength = true;
      enableCalendarEvents = false;
      enableClipboardPaste = true;
      enableDynamicTheming = true;
      enableSystemMonitoring = true;
      enableVPN = true;

      # See https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SettingsSpec.js
      settings =
        lib.recursiveUpdate
        (./settings.json |> builtins.readFile |> builtins.fromJSON)
        {
          clockFormat = "24h";
          showSeconds = false;
          useFahrenheit = false;
          useAutoLocation = true;
          weatherEnabled = true;
          clockDateFormat = "dd/MM";
          lockDateFormat = "dd/MM";

          centeringMode = "geometric";
          currentThemeCategory = lib.mkDefault "generic";
          currentThemeName = lib.mkDefault "purple";
          customThemeFile = lib.mkDefault "";
          fontFamily = lib.mkDefault config.stylix.fonts.sansSerif.name;
          matugenScheme = "scheme-tonal-spot";
          matugenSourceMode = "value";
          matugenSpec = "dms";
          monoFontFamily = lib.mkDefault config.stylix.fonts.monospace.name;
          runDmsMatugenTemplates = true;
          runUserMatugenTemplates = true;
          wallpaperFillMode = "Fit";
          widgetBackgroundColor = "sth";
          widgetColorMode = "colorful";

          lockBeforeSuspend = true;
          lockPamExternallyManaged = true;
          lockScreenPowerOffMonitorsOnLock = false;
          lockScreenShowPowerActions = true;
          lockScreenShowProfileImage = true;
          loginctlLockIntegration = true;
          fadeToDpmsEnabled = true;
          fadeToDpmsGracePeriod = 5;
          fadeToLockEnabled = true;
          fadeToLockGracePeriod = 5;

          notificationCompactMode = true;
          notificationFocusedMonitor = true;
          notificationHistoryEnabled = true;
          notificationHistoryMaxAgeDays = 7;
          notificationHistoryMaxCount = 50;
          notificationHistorySaveCritical = true;
          notificationHistorySaveLow = false;
          notificationHistorySaveNormal = true;
          notificationOverlayEnabled = false;
          notificationPopupBodyInvokesAction = true;
          notificationPopupPosition = 0;
          notificationShowTimeoutBar = true;
          notificationTimeoutCritical = 0;
          notificationTimeoutLow = 5000;
          notificationTimeoutNormal = 5000;

          osdAlwaysShowValue = true;
          osdPosition = 7;
          osdAudioOutputEnabled = true;
          osdBrightnessEnabled = true;
          osdCapsLockEnabled = true;
          osdIdleInhibitorEnabled = true;
          osdMediaPlaybackEnabled = true;
          osdMediaVolumeEnabled = true;
          osdMicMuteEnabled = true;
          osdPowerProfileEnabled = true;
          osdVolumeEnabled = true;
          osdWorkspaceEnabled = false;

          powerMenuDefaultAction = "logout";
          powerMenuActions = [
            "reboot"
            "logout"
            "poweroff"
            "lock"
            "suspend"
            "restart"
            "hibernate"
          ];
          powerActionConfirm = true;
          powerActionHoldDuration = 0.25;
          powerMenuGridLayout = false;
        };

      # See https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SessionSpec.js
      session = {
        doNotDisturb = false;
        isLightMode = false;
        nightModeEnabled = false;
        showThirdPartyPlugins = true;
        timeLocale = "pt";
        wallpaperPath = wallpaper;
        nvidiaGpuTempEnabled = config.my.profiles.hardware.gpu.nvidia;
        nonNvidiaGpuTempEnabled = !config.my.profiles.hardware.gpu.nvidia;
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

    home.packages = [pkgs.libnotify];
  };
}
