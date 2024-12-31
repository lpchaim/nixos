# Use the KDE Plasma desktop environment
{
  config,
  lib,
  ...
}: let
  cfg = config.my.traits.de.plasma;
in {
  options.my.traits.de.plasma.enable = lib.mkEnableOption "plasma trait";
  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
  };
}
