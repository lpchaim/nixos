{
  config,
  lib,
  ...
}: {
  imports = [
    ./barConfigs.nix
    ./controlCenterWidgets.nix
    ./greeterWidgetInstances.nix
    ./lockScreenWidgetInstances.nix
  ];

  config = lib.mkIf (config.my.bars.dux-shell.enable) {
    # See https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SettingsSpec.js
    programs.dank-material-shell.settings =
      (builtins.readFile ./settings.json)
      |> builtins.fromJSON
      |> (it:
        lib.removeAttrs it [
          "barConfigs"
          "controlCenterWidgets"
          "greeterWidgetInstances"
          "lockScreenWidgetInstances"
        ])
      |> (it:
        lib.recursiveUpdate it
        {
          clockFormat = "24h";
          showSeconds = false;
          useFahrenheit = false;
          useAutoLocation = true;
          weatherEnabled = true;
          clockDateFormat = "dd/MM";
          lockDateFormat = "dd/MM";

          dashOptions = {
            media = {
              lyrics = false;
              titleFont = "ui";
            };
          };

          audioVisualizerEnabled = true;
          avatarRing = "primary";
          centeringMode = "geometric";
          clipboardSize = "compact";
          currentThemeCategory = "dynamic";
          currentThemeName = "dynamic";
          matugenScheme = "scheme-tonal-spot";
          matugenSourceMode = "value";
          matugenSpec = "dms";
          fontFamily = config.stylix.fonts.sansSerif.name;
          monoFontFamily = config.stylix.fonts.monospace.name;
          runDmsMatugenTemplates = true;
          runUserMatugenTemplates = true;
          wallpaperFillMode = "Fit";
          lockScreenWallpaperFillMode = "Fit";
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
          notificationPopupPosition = -1;
          notificationShowTimeoutBar = true;
          notificationTimeoutCritical = 0;
          notificationTimeoutLow = 5000;
          notificationTimeoutNormal = 5000;

          osdAlwaysShowValue = true;
          osdPosition = 7;
          osdAudioOutputEnabled = true;
          osdBrightnessEnabled = true;
          osdCapsLockEnabled = true;
          osdIdleInhibitorEnabled = false;
          osdMediaPlaybackEnabled = false;
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
          acLockTimeout = 5 * 60;
          acMonitorTimeout = 10 * 60;
          batteryCriticalThreshold = 5;
          batteryLowThreshold = 15;
          batteryNotifyLow = true;
          batteryLowNotificationType = 0;

          scrollYBehavior = "none";
          scrollXBehavior = "none";
        });
  };
}
