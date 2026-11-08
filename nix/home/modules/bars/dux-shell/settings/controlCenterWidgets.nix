{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.my.bars.dux-shell.enable) {
    programs.dank-material-shell.settings.controlCenterWidgets = [
      {
        col = 0;
        enabled = true;
        h = 1;
        id = "user";
        row = 0;
        w = 5;
      }
      {
        col = 5;
        enabled = true;
        h = 1;
        id = "settings";
        o = 5;
        row = 0;
        small = true;
        w = 1;
      }
      {
        col = 6;
        enabled = true;
        h = 1;
        id = "lock";
        row = 0;
        small = true;
        w = 1;
      }
      {
        col = 7;
        enabled = true;
        h = 1;
        id = "power";
        row = 0;
        small = true;
        w = 1;
      }
      {
        col = 0;
        enabled = true;
        h = 1;
        id = "volumeSlider";
        row = 1;
        w = 4;
      }
      {
        col = 4;
        enabled = true;
        h = 1;
        id = "brightnessSlider";
        o = 4;
        row = 1;
        w = 4;
      }
      {
        col = 0;
        enabled = true;
        h = 1;
        id = "wifi";
        o = 0;
        row = 2;
        w = 4;
      }
      {
        col = 4;
        enabled = true;
        h = 1;
        id = "bluetooth";
        o = 4;
        row = 2;
        w = 4;
      }
      {
        col = 0;
        enabled = true;
        h = 1;
        id = "audioOutput";
        o = 0;
        row = 3;
        w = 4;
      }
      {
        col = 4;
        enabled = true;
        h = 1;
        id = "audioInput";
        o = 4;
        row = 3;
        w = 4;
      }
      {
        col = 0;
        enabled = true;
        h = 1;
        id = "builtin_vpn";
        row = 4;
        w = 4;
      }
      {
        col = 4;
        enabled = true;
        h = 1;
        id = "builtin_tailscale";
        o = 4;
        row = 4;
        w = 4;
      }
      {
        col = 0;
        enabled = true;
        h = 1;
        id = "nightMode";
        o = 0;
        row = 6;
        small = true;
        w = 1;
      }
      {
        col = 1;
        enabled = true;
        h = 1;
        id = "darkMode";
        row = 6;
        small = true;
        w = 1;
      }
      {
        col = 2;
        enabled = true;
        h = 1;
        id = "idleInhibitor";
        row = 6;
        small = true;
        w = 1;
      }
      {
        col = 3;
        enabled = true;
        h = 1;
        id = "doNotDisturb";
        row = 6;
        small = true;
        w = 1;
      }
      {
        col = 7;
        enabled = true;
        h = 1;
        id = "edit";
        row = 6;
        small = true;
        w = 1;
      }
      {
        col = 0;
        enabled = true;
        h = 1;
        id = "plugin_quickCapture";
        row = 5;
        w = 4;
      }
      {
        col = 4;
        enabled = true;
        h = 1;
        id = "plugin_dankKDEConnect";
        row = 5;
        w = 4;
      }
    ];
  };
}
