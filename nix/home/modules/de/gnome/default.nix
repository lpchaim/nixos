{
  config,
  lib,
  ...
}: let
  cfg = config.my.de.gnome;
in {
  imports = [
    ./extensions
    ./theming
  ];

  options.my.de.gnome.enable = lib.mkEnableOption "GTK/GNOME Shell customizations";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      my.de.gnome = {
        extensions = {
          enable = lib.mkDefault true;
          dash-to-panel.enable = lib.mkDefault true;
        };
        theming = {
          enable = lib.mkDefault true;
          enableGtkTheme = lib.mkDefault cfg.theming.enable;
          enableGnomeShellTheme = lib.mkDefault cfg.theming.enable;
          enableIconTheme = lib.mkDefault cfg.theming.enable;
          enableCursorTheme = lib.mkDefault cfg.theming.enable;
          preferDarkTheme = lib.mkDefault cfg.theming.enable;
        };
      };
    }
    {
      gtk.enable = true;
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          enable-hot-corners = true;
        };
        "org/gnome/desktop/sound" = {
          allow-volume-above-100-percent = true;
        };
        "org/gnome/desktop/wm/keybindings" = {
          close = ["<Super>q"];
          cycle-windows = ["<Super>Tab"];
          cycle-windows-backward = ["<Shift><Super>Tab"];
          maximize = ["<Super>z"];
          move-to-workspace-1 = ["<Shift><Super>1"];
          move-to-workspace-2 = ["<Shift><Super>2"];
          move-to-workspace-3 = ["<Shift><Super>3"];
          move-to-workspace-4 = ["<Shift><Super>4"];
          move-to-workspace-5 = ["<Shift><Super>5"];
          move-to-workspace-6 = ["<Shift><Super>6"];
          move-to-workspace-7 = ["<Shift><Super>7"];
          move-to-workspace-8 = ["<Shift><Super>8"];
          move-to-workspace-9 = ["<Shift><Super>9"];
          move-to-workspace-10 = ["<Shift><Super>0"];
          switch-applications = [];
          switch-applications-backward = [];
          switch-to-application-1 = [];
          switch-to-application-2 = [];
          switch-to-application-3 = [];
          switch-to-application-4 = [];
          switch-to-application-5 = [];
          switch-to-application-6 = [];
          switch-to-application-7 = [];
          switch-to-application-8 = [];
          switch-to-application-9 = [];
          switch-to-workspace-1 = ["<Super>1"];
          switch-to-workspace-2 = ["<Super>2"];
          switch-to-workspace-3 = ["<Super>3"];
          switch-to-workspace-4 = ["<Super>4"];
          switch-to-workspace-5 = ["<Super>5"];
          switch-to-workspace-6 = ["<Super>6"];
          switch-to-workspace-7 = ["<Super>7"];
          switch-to-workspace-8 = ["<Super>8"];
          switch-to-workspace-9 = ["<Super>9"];
          switch-to-workspace-10 = ["<Super>0"];
          switch-windows = ["<Alt>Tab"];
          switch-windows-backward = ["<Shift><Alt>Tab"];
          toggle-on-all-workspaces = ["<Super>f"];
        };
        "org/gnome/mutter" = {
          experimental-features = ["scale-monitor-framebuffer"];
          dynamic-workspaces = false;
        };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-schedule-from = 0.0;
          night-light-schedule-to = 23.99;
          night-light-temperature = 3700;
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          volume-step = 2;
        };
        "org/gnome/shell" = {
          current-workspace-only = true;
          favorite-apps = [
            "firefox.desktop"
            "org.gnome.Nautilus.desktop"
            "org.gnome.Terminal.desktop"
          ];
        };
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          num-workspaces = 10;
        };
      };
    }
  ]);
}
