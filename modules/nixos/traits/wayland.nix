# Use wayland instead of X11
# https://nixos.wiki/wiki/Wayland
{
  pkgs,
  config,
  ...
}: {
  services.xserver.displayManager.gdm.wayland = true;
  programs.xwayland.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    wl-clipboard
    config.nur.repos.ataraxiasjel.waydroid-script
  ];

  # To init: sudo waydroid init -s GAPPS
  # See also: https://nixos.wiki/wiki/WayDroid
  # and https://github.com/casualsnek/waydroid_script
  virtualisation.waydroid.enable = true;
}
