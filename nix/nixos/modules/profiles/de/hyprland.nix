# Use the Hyprland compositor
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.de.hyprland;
in {
  options.my.profiles.de.hyprland = lib.mkEnableOption "hyprland profile";
  config = lib.mkIf cfg {
    my.profiles = {
      pipewire = true;
      wayland = true;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    security = {
      pam.services.hyprlock = {};
      polkit.enable = true;
    };
    xdg.portal.wlr.enable = true;
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = with pkgs; [
        hypridle
        hyprlock
      ];
    };
  };
}
