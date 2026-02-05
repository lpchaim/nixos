# Use wayland instead of X11
# https://nixos.wiki/wiki/Wayland
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.wayland;
in {
  options.my.profiles.wayland =
    lib.mkEnableOption "wayland profile"
    // {default = config.my.profiles.graphical;};
  config = lib.mkIf cfg {
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
