{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.gui.firefox;
in {
  options.my.gui.firefox.enable = lib.mkEnableOption "custom firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      package = pkgs.firefox-bin.override {
        cfg = {
          enableGnomeExtensions = config.my.de.gnome.enable or false;
          enablePlasmaBrowserIntegration = config.my.de.plasma.enable or false;
        };
        nativeMessagingHosts = [pkgs.gnomeExtensions.gsconnect];
      };
      profiles.default = {
        isDefault = true;
        name = "default";
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.showMobileBookmarks" = true;
          "browser.compactmode.show" = true;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.search.region" = "BR";
          "browser.search.isUS" = false;
          "browser.startup.homepage" = "about:newtab";
          "distribution.searchplugins.defaultLocale" = "pt-BR";
          "general.useragent.locale" = "pt-BR";
          "widget.use-xdg-desktop-portal.file-picker" =
            if (config.my.de.plasma.enable or false)
            then 1
            else 0;
        };
      };
    };
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
