{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.my.bars.dux-shell.enable) {
    programs.dank-material-shell.settings.greeterWidgetInstances = [
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
        enabled = false;
        id = "lw_1793446457961_ul1afwbjh";
        name = "Date";
        widgetType = "lockDate";
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
      {
        config = {
          displayPreferences = ["all"];
          syncPositionAcrossScreens = true;
        };
        enabled = true;
        id = "greeter_session";
        widgetType = "greeterSession";
      }
    ];
  };
}
