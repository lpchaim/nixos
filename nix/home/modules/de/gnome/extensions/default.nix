{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.loaders) listNonDefault;
  cfg = config.my.modules.de.gnome.extensions;
  pre43 = lib.versionOlder pkgs.gnome-shell.version "43";
in {
  options.my.modules.de.gnome.extensions.enable = lib.mkEnableOption "GNOME Shell extensions";

  config = lib.mkIf cfg.enable {
    home.packages =
      [pkgs.gnome-tweaks]
      ++ (with pkgs.gnomeExtensions;
        [
          appindicator
          blur-my-shell
          caffeine
          clipboard-indicator
          dash-to-dock
          gsconnect
          show-desktop-button
          tailscale-qs
          tray-icons-reloaded
          user-themes
          vitals
        ]
        ++ lib.optionals pre43 [
          sound-output-device-chooser
        ]);

    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions =
          [
            "appindicatorsupport@rgcjonas.gmail.com"
            "blur-my-shell@aunetx"
            "caffeine@patapon.info"
            "clipboard-indicator@tudmotu.com"
            "dash-to-dock@micxgx.gmail.com"
            "gsconnect@andyholmes.github.io"
            "show-desktop-button@amivaleo"
            "tailscale@joaophi.github.com"
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            "Vitals@CoreCoding.com"
          ]
          ++ lib.optionals pre43 [
            "sound-output-device-chooser@kgshank.net"
          ];
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-fixed = false;
        dock-position = "BOTTOM";
        multi-monitor = true;
        show-apps-at-top = true;
        scroll-action = "cycle-windows";
        custom-theme-shrink = true;
        disable-overview-on-startup = true;
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

  imports = listNonDefault ./.;
}
