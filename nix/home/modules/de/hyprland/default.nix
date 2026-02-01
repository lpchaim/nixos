{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.self.lib.config) kb;
  cfg = config.my.modules.de.hyprland;
in {
  imports = [
    ./bars
    ./binds
    ./hypridle
    ./hyprlock
    ./launchers
    ./osd
    ./plugins
  ];

  options.my.modules.de.hyprland.enable = lib.mkEnableOption "Hyprland customizations";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      my.modules.de.hyprland = {
        bars.caelestia.enable = lib.mkDefault cfg.enable;
        binds.enableFnKeys = lib.mkDefault cfg.bars.caelestia.enable;
        binds.enable = lib.mkDefault cfg.enable;
        launchers.rofi.enable = lib.mkDefault cfg.enable;
        osd.swayosd.enable = lib.mkDefault false;
        plugins.enable = lib.mkDefault false;
      };
    }
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.variables = ["--all"];
        settings = {
          exec-once = [
            "hypridle"
            "hyprpaper"
            "[workspace 10 silent] steam -silent"
            "[workspace 10 silent] openrgb --startminimized"
          ];
          general = {
            gaps_in = 2;
            gaps_out = 5;
            border_size = 2;
            "col.active_border" = lib.mkDefault "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = lib.mkDefault "rgba(595959aa)";
            resize_on_border = true;
            allow_tearing = true;
            layout = "dwindle";
          };
          decoration = {
            rounding = 5;
            active_opacity = 0.9;
            inactive_opacity = 0.8;
            blur = {
              enabled = true;
              size = 10;
              passes = 3;
              noise = 0.1;
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
            smart_resizing = true;
            preserve_split = true;
          };
          master = {
            new_status = "master";
          };
          misc = {
            disable_hyprland_logo = true;
            focus_on_activate = true;
            vrr = 2; # Fullscreen only
          };
          input = {
            kb_layout = kb.default.layout;
            kb_variant = kb.default.variant;
            kb_options = kb.default.options;
            follow_mouse = 1;
            touchpad.natural_scroll = false;
            resolve_binds_by_sym = false;
          };
          device = [
            {
              name = "keychron--keychron-link--keyboard";
              kb_layout = kb.us.layout;
              kb_variant = kb.us.variant;
            }
          ];
          binds.workspace_center_on = 1; # Last active
          gesture = [
            "3, horizontal, workspace"
          ];
          env = [
            "XCURSOR_SIZE,32"
            "HYPRCURSOR_SIZE,32"
          ];
          monitor = [",highrr,auto,1"];
          opengl.nvidia_anti_flicker = true;
          windowrule = let
            mkAutoFloatRule = args:
              args
              // {
                opacity = "0.7 override";
                no_initial_focus = "on";
                float = "on";
                pin = "on";
                move = "(monitor_w-window_w-(monitor_w*0.03)) (monitor_h-window_h-(monitor_h*0.03))";
                size = "(monitor_w*0.25) (monitor_h*0.25)";
              };
          in [
            (mkAutoFloatRule {
              name = "floating-discord";
              "match:class" = "^(discord|vesktop)$";
              "match:initial_title" = "^(Discord Popout)$";
            })
            (mkAutoFloatRule {
              name = "floating-chromium";
              "match:initial_title" = "^(Picture in picture)$";
            })
            (mkAutoFloatRule {
              name = "floating-firefox";
              "match:class" = "^(Picture-in-Picture)$";
              "match:initial_title" = "^(Picture in picture)$";
            })
            {
              name = "steam-games";
              fullscreen = "on";
              idle_inhibit = "focus";
              monitor = 1;
              opacity = "1.0 override";
              workspace = 10;
              "match:class" = "^steam_appd+$";
            }
            {
              name = "hide-xwaylandvideobridge";
              max_size = "1 1";
              no_anim = "on";
              no_blur = "on";
              no_focus = "on";
              no_initial_focus = "on";
              opacity = "0.0 override";
              "match:class" = "^(xwaylandvideobridge)$";
            }
            {
              name = "rofi-focus";
              stay_focused = "on";
              "match:class" = "^(rofi)$";
            }
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
            preload = ["${config.stylix.image}"];
            wallpaper = [", ${config.stylix.image}"];
          };
        };
        wayland-pipewire-idle-inhibit = {
          enable = true;
          systemdTarget = "graphical-session.target";
          settings = {
            verbosity = "INFO";
            media_minimum_duration = 10;
            idle_inhibitor = "wayland";
            sink_whitelist = [];
            node_blacklist = [];
          };
        };
      };

      systemd.user.services.wljoywake = {
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${pkgs.wljoywake}/bin/wljoywake -t 10";
          Restart = "always";
          RestartSec = "5";
        };
        Unit = {
          After = ["graphical-session-pre.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Description = "wljoywake";
          PartOf = ["graphical-session.target"];
          X-Restart-Triggers = [pkgs.wljoywake];
        };
      };

      home = {
        packages = with pkgs; [
          brightnessctl
          hyprcursor
          hyprpaper
          hyprpicker
          wlinhibit
        ];
      };

      xdg.portal = {
        enable = true;
        config.common.default = ["hyprland" "wlr" "gtk"];
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
      };
    }
  ]);
}
