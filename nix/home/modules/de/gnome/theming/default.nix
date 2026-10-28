{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars) wallpaper;
  cfg = config.my.de.gnome.theming;
in {
  options.my.de.gnome.theming = {
    enable = lib.mkEnableOption "theming tweaks";
    enableGtkTheme = lib.mkEnableOption "custom GTK theme";
    enableGnomeShellTheme = lib.mkEnableOption "custom GNOME Shell theme";
    enableIconTheme = lib.mkEnableOption "custom icon theme";
    enableCursorTheme = lib.mkEnableOption "custom cursor theme";
    preferDarkTheme = lib.mkEnableOption "prefer-dark-theme flags";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      gtk.iconTheme = lib.mkIf cfg.enableIconTheme {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    }
    (
      lib.mkIf cfg.preferDarkTheme {
        gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk.gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    )
    {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          accent-color = "blue";
        };
        "org/gnome/desktop/background" = {
          color-shading-type = "solid";
          picture-options = "scaled";
          picture-uri = "file://${config.stylix.image}";
          picture-uri-dark = "file://${config.stylix.image}";
          primary-color = "#000000";
          secondary-color = "#000000000000";
        };
        "org/gnome/desktop/screensaver" = {
          color-shading-type = "solid";
          picture-options = "scaled";
          picture-uri = "file://${config.stylix.image}";
          primary-color = "#000000";
          secondary-color = "#000000000000";
        };
      };
    }
  ]);
}
