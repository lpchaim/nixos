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
        "org/gnome/desktop/wm/keybindings" = {
          switch-applications = [];
          switch-applications-backward = [];
          switch-windows = ["<Alt>Tab"];
          switch-windows-backward = ["<Shift><Alt>Tab"];
        };
        "org/gnome/mutter" = {
          experimental-features = ["scale-monitor-framebuffer"];
        };
        "org/gnome/shell" = {
          favorite-apps = [
            "brave-browser.desktop"
            "org.gnome.Nautilus.desktop"
            "kitty.desktop"
          ];
        };
      };
    }
  ]);
}
