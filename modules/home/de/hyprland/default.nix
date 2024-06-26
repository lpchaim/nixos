{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "hyprland" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "Hyprland customizations";
  };

  config = mkIf cfg.enable (mkMerge [
    (setAttrByPath namespace {
      bars.ags.enable = mkDefault true;
      bars.waybar.enable = mkDefault false;
      launchers.rofi.enable = mkDefault true;
      plugins.enable = mkDefault false;
    })
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.variables = [ "--all" ];
        settings = {
          exec-once = [
            "hypridle"
            "hyprpaper"
            "xwaylandvideobridge"
          ];
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            "col.active_border" = mkDefault "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = mkDefault "rgba(595959aa)";
            resize_on_border = true;
            allow_tearing = true;
            layout = "dwindle";
          };
          decoration = {
            rounding = 5;
            active_opacity = 0.9;
            inactive_opacity = 0.8;
            drop_shadow = true;
            shadow_range = 4;
            shadow_render_power = 3;
            "col.shadow" = mkDefault "rgba(1a1a1aee)";
            blur = {
              enabled = true;
              size = 8;
              passes = 3;
              noise = 0.2;
              contrast = 0.9;
              brightness = 0.8;
              vibrancy = 0.2;
              new_optimizations = true;
              popups = true;
              special = false;
              xray = true;
            };
          };
          animations = {
            enabled = true;
            bezier = [
              "easein, 0.42, 0, 0.58, 1"
              "easeout, 0.42, 0, 1, 1"
              "easeinout, 0, 0, 0.58, 1"
            ];
            animation = [
              "windows, 1, 2, easeinout"
              "layers, 1, 2, easeinout"
              "fade, 1, 2, easeinout"
              "border, 1, 2, easeinout"
              "borderangle, 1, 2, easeinout"
              "workspaces, 1, 4, easeinout"
            ];
          };
          dwindle = {
            pseudotile = true;
            smart_split = true;
            preserve_split = true;
            no_gaps_when_only = false;
          };
          master = {
            new_is_master = true;
            no_gaps_when_only = false;
          };
          misc = {
            disable_hyprland_logo = true;
            vrr = 2; # Fullscreen only
          };
          input = {
            kb_layout = "br,br,us";
            kb_variant = ",nodeadkeys,intl";
            follow_mouse = 1;
            touchpad.natural_scroll = false;
          };
          binds.workspace_center_on = 1; # Last active
          gestures = {
            workspace_swipe = true;
            workspace_swipe_touch = true;
            workspace_swipe_create_new = false;
            workspace_swipe_forever = true;
          };
          env = [
            "XCURSOR_SIZE,32"
            "HYPRCURSOR_SIZE,32"
          ];
          monitor = [ ",preferred,auto,1" ];
          opengl.nvidia_anti_flicker = true;
          windowrulev2 = [
            "maxsize 1 1,class:^(xwaylandvideobridge)$"
            "noanim,class:^(xwaylandvideobridge)$"
            "noblur,class:^(xwaylandvideobridge)$"
            "nofocus,class:^(xwaylandvideobridge)$"
            "noinitialfocus,class:^(xwaylandvideobridge)$"
            "opacity 0.0 override,class:^(xwaylandvideobridge)$"
          ];
          debug.disable_logs = false;
        };
      };

      services = {
        hyprpaper = {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;
            preload = [ "${config.stylix.image}" ];
            wallpaper = [ ", ${config.stylix.image}" ];
          };
        };
      };

      home = {
        file.".config/xdg-desktop-portal/hyprland-portals.conf".text = ''
          [preferred]
          default=hyprland;gtk
        '';
        packages = with pkgs; [
          hyprcursor
          hyprpaper
          hyprpicker
          xwaylandvideobridge
        ];
      };

      xdg.portal = {
        enable = true;
        config = {
          preferred.default = [ "hyprland" "gtk" ];
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
      };
    }
  ]);
}
