{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.graphical;
in {
  options.my.profiles.graphical = lib.mkEnableOption "graphical profile";
  config = {
    boot.plymouth.enable = true;
    services.flatpak.enable = true;
    services.xserver.enable = cfg;
    xdg.portal = {
      enable = true;
      config.common.default = lib.mkDefault ["hyprland" "wlr" "gtk"];
      extraPortals = lib.mkDefault [pkgs.xdg-desktop-portal-gtk];
      xdgOpenUsePortal = true;
    };
  };
}
