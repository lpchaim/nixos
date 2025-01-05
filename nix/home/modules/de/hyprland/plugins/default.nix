{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.de.hyprland.plugins;
in {
  options.my.modules.de.hyprland.plugins.enable = lib.mkEnableOption "Hyprland plugins";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, apostrophe, hyprexpo:expo, toggle"
      ];
    };
    wayland.windowManager.hyprland.plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
      hyprexpo
    ];
  };
}
