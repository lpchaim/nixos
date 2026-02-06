# Use the GNOME desktop environment
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.de.gnome;
in {
  options.my.profiles.de.gnome = lib.mkEnableOption "gnome profile";
  config = lib.mkIf cfg {
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.gnome = {
      core-apps.enable = false;
      games.enable = false;
      gnome-keyring.enable = false;
      core-developer-tools.enable = false;
    };

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    ];
    environment.systemPackages = with pkgs; [
      gnome-system-monitor
      loupe
      nautilus
    ];
  };
}
