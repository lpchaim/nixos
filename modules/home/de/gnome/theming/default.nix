{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "gnome" "theming" ];
  cfg = getAttrFromPath namespace config;
  toTitle = str: "${lib.toUpper (lib.substring 0 1 str)}${lib.substring 1 (lib.stringLength str) str}";
  catppuccin = {
    variant = "mocha";
    accent = "blue";
  };
in
{
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
      home.packages = with pkgs; [ ]
        ++ optional cfg.enableGnomeShellTheme (catppuccin-gtk.override {
        variant = catppuccin.variant;
        accents = [ catppuccin.accent ];
        tweaks = [ "normal" ];
        size = "standard";
      });

      gtk.theme = mkIf cfg.enableGtkTheme {
        name = "Catppuccin-${toTitle catppuccin.variant}-Standard-${toTitle catppuccin.accent}-Dark";
        package = pkgs.catppuccin-gtk;
      };

      gtk.iconTheme = mkIf cfg.enableIconTheme {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      gtk.cursorTheme = mkIf cfg.enableCursorTheme {
        name = "Catppuccin-Latte-Light-Cursors";
        package = pkgs.catppuccin-cursors.latteLight;
      };

      dconf.settings."org/gnome/shell/extensions/user-theme" = mkIf cfg.enableGnomeShellTheme {
        name = "Catppuccin-${toTitle catppuccin.variant}-Standard-${toTitle catppuccin.accent}-Dark";
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
      in
      {
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
