{ config, lib, pkgs, ... }:

let
  namespace = [ "my" "modules" "de" "hyprland" "osd" "swayosd" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "sway-osd";
  };

  config = lib.mkIf cfg.enable {
    my.modules.de.hyprland.bars.ags.enableFnKeys = lib.mkForce false;
    home.packages = [ pkgs.swayosd ];
    wayland.windowManager.hyprland.settings = {
      exec-once = lib.mkBefore [ "${pkgs.swayosd}/bin/swayosd-server" ];
      binde =
        let client = pkgs.swayosd + /bin/swayosd-client;
        in lib.mkAfter [
          ", XF86AudioRaiseVolume, exec, ${client} --output-volume +5 --max-volume 110"
          ", XF86AudioLowerVolume, exec, ${client} --output-volume -5 --max-volume 110"
          ", XF86AudioMute, exec, ${client} --output-volume mute-toggle"
          ", XF86AudioMicMute, exec, ${client} --output-volume mute-toggle"
          ", XF86MonBrightnessUp, exec, ${client} --brightness +5"
          ", XF86MonBrightnessDown, exec, ${client} --brightness -5"
        ];
    };
  };
}
