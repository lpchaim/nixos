{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.graphical;
in {
  options.my.profiles.graphical = lib.mkEnableOption "graphical profile";
  config = lib.mkIf cfg {
    boot.plymouth.enable = true;
    hardware = {
      graphics.enable = true;
      graphics.enable32Bit = true;
    };
    services = {
      flatpak.enable = true;
      xserver.enable = lib.mkDefault true;
    };
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
