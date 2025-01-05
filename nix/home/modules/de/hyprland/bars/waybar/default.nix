{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.de.hyprland.bars.waybar;
in {
  options.my.modules.de.hyprland.bars.waybar.enable = lib.mkEnableOption "Waybar";

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 32;
          # output = [
          #   "eDP-1"
          #   "HDMI-A-1"
          # ];
          modules-left = [
            "hyprland/window"
          ];
          modules-center = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "mpd"
            "battery"
            "tray"
            "wireplumber"
            "clock"
          ];

          "hyprland/workspaces" = {
            disable-scroll = false;
            all-outputs = true;
          };
          "custom/hello-from-waybar" = {
            format = "hello {}";
            max-length = 40;
            interval = "once";
            exec = pkgs.writeShellScript "hello-from-waybar" ''
              echo "from within waybar"
            '';
          };
        };
      };
      # style = [];
    };
  };
}
