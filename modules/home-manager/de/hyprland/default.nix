{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "hyprland" ];
  cfg = getAttrFromPath namespace config;
  assetsPath = ../../../../assets;
  wallpaperLight = "${assetsPath}/wallpaper-city-l.png";
  wallpaperDark = "${assetsPath}/wallpaper-city-d.png";
in
{
  imports = [
    ./bars
    ./binds.nix
    ./plugins
  ];

  options = setAttrByPath namespace {
    enable = mkOption {
      description = "Whether to enable Hyprland customizations.";
      type = types.bool;
      default = config.services.pipewire.enable;
    };
    command =
      let
        mkCommandOption = name: default:
          mkOption {
            inherit default;
            description = "${name} command";
            type = types.str;
          };
      in
      {
        mod = mkOption {
          description = "Main modifier key";
          type = types.str;
          default = "SUPER";
        };
        menu = mkCommandOption "Menu" "rofi -show drun";
        run = mkCommandOption "Run" "rofi -show run";
        terminal = mkCommandOption "Terminal" "kitty";
        fileManager = mkCommandOption "File manager" "nautilus";
        webBrowser = mkCommandOption "Web browser" "firefox";
      };
  };

  config =
    let
      font = elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
    in
    lib.mkIf cfg.enable (
      setAttrByPath namespace
        {
          plugins.enable = mkDefault false;
          bars.ags.enable = mkDefault true;
          bars.waybar.enable = mkDefault false;
        }
      // {
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.variables = [ "--all" ];
          settings = {
            general = {
              gaps_in = 5;
              gaps_out = 10;
              border_size = 2;
              "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
              "col.inactive_border" = "rgba(595959aa)";
              resize_on_border = true;
              allow_tearing = true;
              layout = "dwindle";
            };
            decoration = {
              rounding = 10;
              active_opacity = 1.0;
              inactive_opacity = 1.0;
              drop_shadow = true;
              shadow_range = 4;
              shadow_render_power = 3;
              "col.shadow" = "rgba(1a1a1aee)";
              blur = {
                enabled = true;
                size = 3;
                passes = 1;
                vibrancy = 0.1696;
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
              no_gaps_when_only = true;
            };
            master = {
              new_is_master = true;
              no_gaps_when_only = true;
            };
            misc = {
              disable_hyprland_logo = true;
              vrr = 2; # Fullscreen only
              enable_swallow = true;
              swallow_regex = "^(${cfg.command.terminal})";
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
          };
        };

        programs = {
          hyprlock = {
            enable = false;
            settings = { };
          };
          kitty = {
            enable = true;
            font.name = font;
          };
          rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
            terminal = cfg.command.terminal;
          };
        };

        services = {
          hypridle = {
            enable = false;
            settings = { };
          };
          hyprpaper = {
            enable = true;
            settings = {
              ipc = "on";
              splash = false;
              preload = [ wallpaperDark wallpaperLight ];
              wallpaper = [ ", ${wallpaperDark}" ];
            };
          };
        };

        home.file.".config/xdg-desktop-portal/hyprland-portals.conf".text = ''
          [preferred]
          default=hyprland;gtk
        '';

        home.packages = with pkgs; [
          grimblast
          hyprpicker
        ];
      }
    );
}
