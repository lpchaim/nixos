{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.modules.de.hyprland.plugins;
in {
  options.my.modules.de.hyprland.plugins.enable = mkEnableOption "Hyprland plugins";

  config = mkIf cfg.enable {
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
