{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  namespace = ["my" "modules" "de" "hyprland" "plugins"];
  cfg = getAttrFromPath namespace config;
in {
  options = setAttrByPath namespace {
    enable = mkEnableOption "Hyprland plugins";
  };

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
