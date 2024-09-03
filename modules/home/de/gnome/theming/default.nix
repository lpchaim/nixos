{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  namespace = ["my" "modules" "de" "gnome" "theming"];
  cfg = getAttrFromPath namespace config;
  toTitle = str: "${lib.toUpper (lib.substring 0 1 str)}${lib.substring 1 (lib.stringLength str) str}";
in {
  options = setAttrByPath namespace {
    enable = mkEnableOption "theming tweaks";
    enableGtkTheme = mkEnableOption "custom GTK theme";
    enableGnomeShellTheme = mkEnableOption "custom GNOME Shell theme";
    enableIconTheme = mkEnableOption "custom icon theme";
    enableCursorTheme = mkEnableOption "custom cursor theme";
    preferDarkTheme = mkEnableOption "prefer-dark-theme flags";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      gtk.iconTheme = mkIf cfg.enableIconTheme {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    }
    (
      mkIf cfg.preferDarkTheme {
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
        assetsPath = ../../../../assets;
        destinationPath = config.home.homeDirectory;
        pfp = "${assetsPath}/profile-picture.png";
        wallpaperLight = "${assetsPath}/wallpaper-light.png";
        wallpaperDark = "${assetsPath}/wallpaper-dark.png";
      in {
        home.file."${destinationPath}/.face".source = pfp;
        home.file."${destinationPath}/.wallpaper-light".source = wallpaperLight;
        home.file."${destinationPath}/.wallpaper-dark".source = wallpaperDark;

        dconf.settings = {
          "org/gnome/desktop/background" = {
            picture-uri = mkDefault "${destinationPath}/.wallpaper-light";
            picture-uri-dark = mkDefault "${destinationPath}/.wallpaper-dark";
            primary-color = "#000000";
            picture-options = "zoom";
          };
        };
      }
    )
  ]);
}
