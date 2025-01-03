# Use the KDE Plasma desktop environment
{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.de.plasma;
in {
  options.my.profiles.de.plasma = lib.mkEnableOption "plasma profile";
  config = lib.mkIf cfg {
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
  };
}
