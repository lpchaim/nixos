# Use the Hyprland compositor
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  flakePkgs = inputs.hyprland.packages.${pkgs.system};
  flakeNixpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
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
      package = flakePkgs.hyprland;
      portalPackage = flakePkgs.xdg-desktop-portal-hyprland;
    };
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      package = flakeNixpkgs.mesa;
      package32 = flakeNixpkgs.pkgsi686Linux.mesa;
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
