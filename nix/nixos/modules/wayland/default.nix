# Use wayland instead of X11
# https://nixos.wiki/wiki/Wayland
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.wayland;
in {
  options.my.wayland.enable = lib.mkEnableOption "wayland tweaks";
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.hardware.graphics.enable;
        message = "config.my.wayland.enable is useless without graphics";
      }
    ];

    services.displayManager.gdm.wayland = true;
    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      nur.repos.ataraxiasjel.waydroid-script
    ];

    # To init: sudo waydroid init -s GAPPS
    # See also: https://nixos.wiki/wiki/WayDroid
    # and https://github.com/casualsnek/waydroid_script
    virtualisation.waydroid.enable = true;
  };
}
