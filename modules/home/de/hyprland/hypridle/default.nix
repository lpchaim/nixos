{
  config,
  lib,
  ...
}:
with lib; let
  namespace = ["my" "modules" "de" "hyprland"];
  cfg = getAttrFromPath namespace config;
in
  mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = "120";
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = "300";
            on-timeout = "loginctl lock-session";
          }
        ];
      };
    };
  }
