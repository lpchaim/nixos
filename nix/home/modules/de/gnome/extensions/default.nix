{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.de.gnome.extensions;
in {
  imports = [
    ./dash-to-panel.nix
  ];

  options.my.de.gnome.extensions.enable = lib.mkEnableOption "GNOME Shell extensions";

  config = let
    enabledExtensions = with pkgs.gnomeExtensions; [
      appindicator
      caffeine
      clipboard-indicator
      dash-to-dock
      dynamic-music-pill
      gsconnect
      no-overview
      quick-sound-switcher
      show-desktop-button
      tailscale-qs
      touch-board
      tray-icons-reloaded
      user-accent-colors
      user-themes
      vitals
    ];
    extraExtensions = with pkgs.gnomeExtensions; [
      blur-my-shell
      just-perfection
      open-bar
      touchshell
      touchup
    ];
  in
    lib.mkIf cfg.enable {
      home.packages =
        [pkgs.gnome-tweaks]
        ++ enabledExtensions
        ++ extraExtensions;

      dconf.settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = map (ext: ext.passthru.extensionUuid) enabledExtensions;
        };
        "org/gnome/shell/extensions/dash-to-dock" = {
          apply-custom-theme = true;
          custom-theme-shrink = true;
          disable-overview-on-startup = true;
          dock-fixed = false;
          dock-position = "BOTTOM";
          hot-keys = false;
          multi-monitor = true;
          scroll-action = "cycle-windows";
          show-apps-at-top = true;
        };
        "org/gnome/shell/extensions/vitals" = {
          show-storage = true;
          show-voltage = true;
          show-memory = true;
          show-fan = true;
          show-temperature = true;
          show-processor = true;
          show-network = true;
          hot-sensors = ["_default_icon_"];
        };
      };
    };
}
