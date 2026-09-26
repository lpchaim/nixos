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
          "browser.ai.control.default" = "blocked";
          "browser.ai.control.linkPreviewKeyPoints" = "blocked";
          "browser.ai.control.pdfjsAltText" = "blocked";
          "browser.ai.control.sidebarChatbot" = "blocked";
          "browser.ai.control.smartTabGroups" = "available";
          "browser.ai.control.translations" = "available";
          "browser.bookmarks.showMobileBookmarks" = true;
          "browser.compactmode.show" = true;
          "browser.newtabpage.activity-stream.default.sites" = builtins.concatStringsSep "," [];
          "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
          "browser.newtabpage.activity-stream.hideLogo" = true;
          "browser.newtabpage.activity-stream.newtabWallpapers.user.enabled" = true;
          "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper" = "firefox-desert-dark";
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.topSitesRows" = 1;
          "browser.search.isUS" = false;
          "browser.search.region" = "BR";
          "browser.startup.homepage" = "about:newtab";
          "browser.toolbars.bookmarks.visibility" = "never";
          "distribution.searchplugins.defaultLocale" = "pt-BR";
          "general.useragent.locale" = "pt-BR";
          "mousewheel.default.delta_multiplier_x" = 20;
          "mousewheel.default.delta_multiplier_y" = 20;
          "services.sync.prefs.sync.browser.uiCustomization.state" = true;
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
