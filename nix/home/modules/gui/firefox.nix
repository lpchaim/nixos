{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.gui.firefox;
in {
  options.my.modules.gui.firefox.enable =
    lib.mkEnableOption "custom firefox"
    // {default = config.my.modules.gui.enable;};

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          enableGnomeExtensions = config.my.modules.de.gnome.enable or false;
          enablePlasmaBrowserIntegration = config.my.modules.de.plasma.enable or false;
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
          "browser.newtabpage.activity-stream.default.sites" = builtins.concatStringsSep "," [
            "https://www.youtube.com/"
            "https://www.reddit.com/"
            "https://www.wikipedia.org/"
          ];
          "browser.newtabpage.pinned" = [
            {
              title = "Home";
              url = "https://home.lpcha.im";
            }
          ];
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.search.region" = "BR";
          "browser.search.isUS" = false;
          "browser.startup.homepage" = "about:newtab";
          "distribution.searchplugins.defaultLocale" = "pt-BR";
          "general.useragent.locale" = "pt-BR";
          "mousewheel.default.delta_multiplier_x" = 20;
          "mousewheel.default.delta_multiplier_y" = 20;
          "widget.use-xdg-desktop-portal.file-picker" =
            if (config.my.modules.plasma.enable or false)
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
