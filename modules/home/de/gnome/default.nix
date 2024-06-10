{ config, lib, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "gnome" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "GTK/GNOME Shell customizations";
  };

  config = lib.mkIf cfg.enable (setAttrByPath namespace
    {
      extensions = {
        enable = mkDefault true;
        dash-to-panel.enable = mkDefault true;
      };
      theming = {
        enable = mkDefault true;
        enableGtkTheme = mkDefault false;
        enableGnomeShellTheme = mkDefault false;
        enableIconTheme = mkDefault true;
        enableCursorTheme = mkDefault true;
        preferDarkTheme = mkDefault true;
      };
    } // {
    gtk.enable = true;
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
      };
      "org/gnome/desktop/wm/keybindings" = {
        switch-applications = [ ];
        switch-applications-backward = [ ];
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backward = [ "<Shift><Alt>Tab" ];
      };
      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
      "org/gnome/shell" = {
        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "firefox.desktop"
        ];
      };
    };
  });
}
