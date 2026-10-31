{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.my.bars.dux-shell.enable) {
    programs.dank-material-shell = {
      settings.lockScreenWidgetInstances = [
        {
          config = {
            autoPosition = false;
            colorMode = "default";
            customColor = "#ffffff";
            displayPreferences = ["all"];
            showAnalogNumbers = false;
            showAnalogSeconds = true;
            showDate = false;
            showDigitalSeconds = false;
            style = "expressive";
            syncPositionAcrossScreens = true;
            transparency = 0;
            twoTone = true;
            weight = 0;
          };
          enabled = true;
          id = "lock_clock";
          widgetType = "desktopClock";
        }
        {
          config = {
            displayPreferences = ["all"];
            passwordVisibility = "always";
            profileVisibility = "always";
            style = "pill";
            syncPositionAcrossScreens = true;
          };
          enabled = true;
          id = "lock_auth";
          widgetType = "lockAuth";
        }
        {
          config = {
            displayPreferences = ["all"];
            mode = 2;
            syncPositionAcrossScreens = true;
          };
          enabled = true;
          id = "lock_notifications";
          widgetType = "lockNotifications";
        }
        {
          config = {
            background = false;
            displayPreferences = ["all"];
            showMediaPlayer = true;
            showWeather = true;
            syncPositionAcrossScreens = true;
          };
          enabled = true;
          id = "lock_status";
          widgetType = "lockStatus";
        }
        {
          config = {
            displayPreferences = ["all"];
            shape = "round";
            syncPositionAcrossScreens = true;
          };
          enabled = true;
          id = "lock_power";
          widgetType = "lockPower";
        }
        {
          config = {
            colorMode = "default";
            customColor = "#ffffff";
            displayPreferences = ["all"];
            format = "short";
            syncPositionAcrossScreens = true;
          };
          enabled = true;
          id = "lw_1793446491170_mo9cb9jkg";
          name = "Date";
          widgetType = "lockDate";
        }
      ];
      session.desktopWidgetInstancePositions = {
        lock_auth = {
          _synced = {
            anchorX = "center";
            anchorY = "center";
            x = 0;
            y = 0.0334961;
          };
        };
        lock_clock = {
          _synced = {
            anchorX = "center";
            anchorY = "center";
            height = 102.383;
            width = 378.113;
            x = 0;
            y = -0.0549769;
          };
        };
        lock_notifications = {
          _synced = {
            anchorX = "center";
            anchorY = "center";
            x = 0;
            y = 0.0954391;
          };
        };
        lw_1793446491170_mo9cb9jkg = {
          _synced = {
            x = 0.0125;
            y = 0.0222222;
          };
        };
      };
    };
  };
}
