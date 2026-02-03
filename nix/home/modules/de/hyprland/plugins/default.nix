{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.my.de.hyprland.plugins;
in {
  options.my.de.hyprland.plugins.enable = lib.mkEnableOption "Hyprland plugins";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, apostrophe, hyprexpo:expo, toggle"
      ];
    };
    wayland.windowManager.hyprland.plugins = with inputs.hyprland-plugins.packages.${system}; [
      hyprexpo
    ];
  };
}
