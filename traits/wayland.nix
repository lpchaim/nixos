# Use wayland instead of X11

{ ... }:

{
  services.xserver.displayManager.gdm.wayland = true;
  programs.xwayland.enable = true;
}
