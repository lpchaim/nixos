{ inputs, pkgs, ... }:

{
  my.modules.de.hyprland.enable = true;
  # wayland.windowManager.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
}
