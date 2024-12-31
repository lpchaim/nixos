# Use wayland instead of X11
# https://nixos.wiki/wiki/Wayland
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.traits.wayland;
in {
  options.my.traits.wayland.enable = lib.mkEnableOption "wayland trait";
  config = lib.mkIf cfg.enable {
    services.xserver.displayManager.gdm.wayland = true;
    programs.xwayland.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      wl-clipboard
      nur.repos.ataraxiasjel.waydroid-script
    ];

    # To init: sudo waydroid init -s GAPPS
    # See also: https://nixos.wiki/wiki/WayDroid
    # and https://github.com/casualsnek/waydroid_script
    virtualisation.waydroid.enable = true;
  };
}
