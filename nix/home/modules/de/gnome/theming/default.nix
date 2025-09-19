{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) profilePicture wallpaper;
  cfg = config.my.modules.de.gnome.theming;
in {
  options.my.modules.de.gnome.theming = {
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
    (
      let
        destinationPath = config.home.homeDirectory;
      in {
        home.file."${destinationPath}/.wallpaper".source = wallpaper;

        dconf.settings = {
          "org/gnome/desktop/background" = {
            picture-uri = lib.mkDefault "${destinationPath}/.wallpaper";
            primary-color = "#000000";
            picture-options = "zoom";
          };
        };
      }
    )
  ]);
}
